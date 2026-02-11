import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:app/data/repositories/kakao_repository.dart';
import 'package:app/providers/location_provider.dart';
import 'package:app/core/theme/app_theme.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/kakao_map_widget.dart';

class RestaurantSearchScreen extends ConsumerStatefulWidget {
  const RestaurantSearchScreen({super.key});

  @override
  ConsumerState<RestaurantSearchScreen> createState() =>
      _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState
    extends ConsumerState<RestaurantSearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  List<KakaoPlace> _results = [];
  bool _isSearching = false;
  KakaoPlace? _selectedPlace;
  String? _activeCategory;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (query.trim().isNotEmpty) {
        _searchKeyword(query.trim());
      }
    });
  }

  Future<void> _searchKeyword(String query) async {
    setState(() {
      _isSearching = true;
      _activeCategory = null;
    });

    try {
      final location = ref.read(locationProvider);
      final kakao = ref.read(kakaoRepositoryProvider);
      final results = await kakao.searchKeyword(
        query,
        lat: location.lat,
        lon: location.lon,
        radius: 3000,
      );
      if (mounted) {
        setState(() {
          _results = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  Future<void> _searchCategory(String code, String label) async {
    final location = ref.read(locationProvider);
    if (location.lat == null || location.lon == null) {
      ShadSonner.of(context).show(
        const ShadToast(title: Text('위치를 먼저 확인해주세요')),
      );
      return;
    }

    setState(() {
      _isSearching = true;
      _activeCategory = code;
      _searchController.clear();
    });

    try {
      final kakao = ref.read(kakaoRepositoryProvider);
      final results = await kakao.searchCategory(
        code,
        lat: location.lat!,
        lon: location.lon!,
        radius: 3000,
      );
      if (mounted) {
        setState(() {
          _results = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final location = ref.watch(locationProvider);
    final mapLat = _selectedPlace?.lat ?? location.lat ?? 37.5665;
    final mapLon = _selectedPlace?.lon ?? location.lon ?? 126.9780;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: LiquidBackground(
        child: Stack(
          children: [
            // ── Main content ──
            Column(
              children: [
                SizedBox(height: topPadding + 56 + 16),

                // ── Search bar ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: ShadInput(
                    controller: _searchController,
                    placeholder: const Text('식당이나 카페를 검색하세요'),
                    leading: const Icon(Icons.search_rounded, size: 18),
                    onChanged: _onSearchChanged,
                  ),
                ),

                // ── Category quick filters ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      _CategoryChip(
                        label: '음식점',
                        icon: Icons.restaurant_rounded,
                        isActive: _activeCategory == 'FD6',
                        onTap: () => _searchCategory('FD6', '음식점'),
                      ),
                      const SizedBox(width: 8),
                      _CategoryChip(
                        label: '카페',
                        icon: Icons.coffee_rounded,
                        isActive: _activeCategory == 'CE7',
                        onTap: () => _searchCategory('CE7', '카페'),
                      ),
                    ],
                  ),
                ),

                // ── Map ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: KakaoMapWidget(
                    latitude: mapLat,
                    longitude: mapLon,
                    height: 180,
                    zoomLevel: 4,
                    interactive: true,
                    markers: _results
                        .map((p) => MapMarkerData(
                              lat: p.lat,
                              lon: p.lon,
                              label: p.placeName,
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),

                // ── Results list ──
                Expanded(
                  child: _isSearching
                      ? Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ),
                        )
                      : _results.isEmpty
                          ? Center(
                              child: Text(
                                '검색어를 입력하거나 카테고리를 선택하세요',
                                style: TextStyle(
                                  color: theme.colorScheme.mutedForeground,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                              itemCount: _results.length,
                              itemBuilder: (context, index) {
                                final place = _results[index];
                                final isSelected =
                                    _selectedPlace?.placeName == place.placeName &&
                                        _selectedPlace?.lat == place.lat;
                                return _PlaceCard(
                                  place: place,
                                  isSelected: isSelected,
                                  onTap: () {
                                    setState(() => _selectedPlace = place);
                                  },
                                );
                              },
                            ),
                ),

                // ── Confirm button ──
                if (_selectedPlace != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        child: ShadButton(
                          onPressed: () {
                            context.pop(_selectedPlace);
                          },
                          leading: const Icon(Icons.check_rounded, size: 18),
                          child: Text(
                            '${_selectedPlace!.placeName} 선택',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // ── Glass AppBar ──
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _GlassAppBar(topPadding: topPadding),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassAppBar extends StatelessWidget {
  final double topPadding;

  const _GlassAppBar({required this.topPadding});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final barBgColor =
        isDark ? const Color(0x66000000) : const Color(0x66FFFFFF);

    return Column(
      children: [
        SizedBox(height: topPadding),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: AppTheme.glassDecoration(
                  borderRadius: 100,
                  backgroundColor: barBgColor,
                  brightness: theme.brightness,
                ),
                child: Row(
                  children: [
                    ShadButton.ghost(
                      size: ShadButtonSize.sm,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: theme.colorScheme.foreground,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '식당 검색',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.foreground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isActive
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : theme.colorScheme.muted,
          border: Border.all(
            color: isActive
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : theme.colorScheme.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.mutedForeground,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final KakaoPlace place;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlaceCard({
    required this.place,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          borderRadius: 16,
          padding: const EdgeInsets.all(16),
          backgroundColor: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : null,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.placeName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.foreground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      place.roadAddressName ?? place.addressName,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                    if (place.categoryName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        place.categoryName!,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.mutedForeground
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (place.distance != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: theme.colorScheme.muted,
                  ),
                  child: Text(
                    place.distance! < 1000
                        ? '${place.distance}m'
                        : '${(place.distance! / 1000).toStringAsFixed(1)}km',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.check_circle_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
