import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:intl/intl.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:app/providers/party_provider.dart';
import 'package:app/data/repositories/kakao_repository.dart';
import 'package:app/core/theme/app_theme.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/kakao_map_widget.dart';

class PartyCreateScreen extends ConsumerStatefulWidget {
  const PartyCreateScreen({super.key});

  @override
  ConsumerState<PartyCreateScreen> createState() => _PartyCreateScreenState();
}

class _PartyCreateScreenState extends ConsumerState<PartyCreateScreen> {
  final _formKey = GlobalKey<ShadFormState>();

  // Date/time state managed separately (no ShadDatePicker form field)
  DateTime _startTime = DateTime.now().add(const Duration(minutes: 30));

  // Selected restaurant location
  double? _selectedLat;
  double? _selectedLon;
  String? _selectedLocationName;
  String? _selectedCategoryName;

  // Map state
  double _mapCenterLat = 37.5665;
  double _mapCenterLon = 126.9780;

  // Nearby restaurants from map tap
  List<KakaoPlace> _nearbyRestaurants = [];
  bool _isLoadingNearby = false;

  Future<void> _onMapTap(LatLng latLng) async {
    final lat = latLng.latitude;
    final lon = latLng.longitude;

    setState(() {
      _selectedLat = lat;
      _selectedLon = lon;
      _mapCenterLat = lat;
      _mapCenterLon = lon;
      _isLoadingNearby = true;
      _nearbyRestaurants = [];
      _selectedLocationName = null;
      _selectedCategoryName = null;
    });

    try {
      final kakaoRepo = ref.read(kakaoRepositoryProvider);

      // Run reverse geocoding and category search in parallel
      final results = await Future.wait([
        kakaoRepo.coordToAddress(lat, lon),
        kakaoRepo.searchCategory('FD6', lat: lat, lon: lon, radius: 1000, size: 5),
      ]);

      final address = results[0] as KakaoAddress?;
      final restaurants = results[1] as List<KakaoPlace>;

      if (!mounted) return;

      setState(() {
        _nearbyRestaurants = restaurants;
        _isLoadingNearby = false;

        if (restaurants.isNotEmpty) {
          // Auto-select the closest restaurant
          _selectRestaurant(restaurants.first);
        } else if (address != null) {
          _selectedLocationName = address.shortAddress;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingNearby = false;
      });
    }
  }

  void _selectRestaurant(KakaoPlace place) {
    setState(() {
      _selectedLat = place.lat;
      _selectedLon = place.lon;
      _selectedLocationName = place.placeName;
      _selectedCategoryName = place.categoryName;
      _mapCenterLat = place.lat;
      _mapCenterLon = place.lon;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(partyControllerProvider).isLoading;
    final theme = ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: LiquidBackground(
        child: Stack(
          children: [
            // ── Main scrollable content ──
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, topPadding + 56 + 16, 16, 16),
              child: GlassCard(
                child: ShadForm(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ShadInputFormField(
                        id: 'title',
                        label: const Text('제목'),
                        placeholder: const Text('파티 제목을 입력하세요'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '제목을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date/Time picker (dialog-based)
                      Text(
                        '일시',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.foreground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ShadButton.outline(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _startTime,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          );
                          if (date != null && context.mounted) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(_startTime),
                            );
                            if (time != null) {
                              setState(() {
                                _startTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                            }
                          }
                        },
                        leading: const Icon(Icons.calendar_today, size: 16),
                        child: Text(
                          DateFormat('yyyy-MM-dd HH:mm').format(_startTime),
                        ),
                      ),
                      const SizedBox(height: 16),

                      ShadSelectFormField<String>(
                        id: 'location_type',
                        label: const Text('장소 유형'),
                        placeholder: const Text('장소 유형을 선택하세요'),
                        initialValue: 'company_nearby',
                        options: const [
                          ShadOption(value: 'company_nearby', child: Text('회사 근처')),
                          ShadOption(value: 'midpoint', child: Text('중간 지점')),
                          ShadOption(value: 'specific', child: Text('직접 입력')),
                        ],
                        selectedOptionBuilder: (context, value) {
                          final labels = {
                            'company_nearby': '회사 근처',
                            'midpoint': '중간 지점',
                            'specific': '직접 입력',
                          };
                          return Text(labels[value] ?? value);
                        },
                      ),
                      const SizedBox(height: 16),

                      // ── Interactive Map ──
                      Text(
                        '지도에서 장소 선택',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.foreground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: KakaoMapWidget(
                            latitude: _mapCenterLat,
                            longitude: _mapCenterLon,
                            height: double.infinity,
                            zoomLevel: 4,
                            interactive: true,
                            onTap: _onMapTap,
                            markers: _selectedLat != null && _selectedLon != null
                                ? [
                                    MapMarkerData(
                                      lat: _selectedLat!,
                                      lon: _selectedLon!,
                                      label: _selectedLocationName ?? '',
                                    ),
                                    ..._nearbyRestaurants
                                        .where((r) =>
                                            r.lat != _selectedLat ||
                                            r.lon != _selectedLon)
                                        .map((r) => MapMarkerData(
                                              lat: r.lat,
                                              lon: r.lon,
                                              label: r.placeName,
                                            )),
                                  ]
                                : [],
                          ),
                        ),
                      ),

                      // ── Loading indicator for nearby search ──
                      if (_isLoadingNearby) ...[
                        const SizedBox(height: 12),
                        const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ],

                      // ── Selected place info card ──
                      if (_selectedLocationName != null && !_isLoadingNearby) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.black.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.place_rounded,
                                    size: 18,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      _selectedLocationName!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.foreground,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (_selectedCategoryName != null) ...[
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child: Text(
                                    _selectedCategoryName!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.mutedForeground,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],

                      // ── Nearby restaurant chips ──
                      if (_nearbyRestaurants.length > 1 && !_isLoadingNearby) ...[
                        const SizedBox(height: 8),
                        Text(
                          '주변 음식점',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _nearbyRestaurants.length.clamp(0, 3),
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final place = _nearbyRestaurants[index];
                              final isSelected =
                                  place.placeName == _selectedLocationName;
                              return GestureDetector(
                                onTap: () => _selectRestaurant(place),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : isDark
                                            ? Colors.white.withValues(alpha: 0.08)
                                            : Colors.black.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.border,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.restaurant_rounded,
                                        size: 14,
                                        color: isSelected
                                            ? theme.colorScheme.primaryForeground
                                            : theme.colorScheme.mutedForeground,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        place.placeName,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? theme.colorScheme.primaryForeground
                                              : theme.colorScheme.foreground,
                                        ),
                                      ),
                                      if (place.distance != null) ...[
                                        const SizedBox(width: 4),
                                        Text(
                                          '${place.distance}m',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: isSelected
                                                ? theme.colorScheme.primaryForeground
                                                    .withValues(alpha: 0.7)
                                                : theme.colorScheme.mutedForeground,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // 장소 검색 필드
                      Text(
                        '장소명',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.foreground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final result = await context.push<KakaoPlace>(
                            '/party/create/search-restaurant',
                          );
                          if (result != null) {
                            setState(() {
                              _selectedLat = result.lat;
                              _selectedLon = result.lon;
                              _selectedLocationName = result.placeName;
                              _selectedCategoryName = result.categoryName;
                              _mapCenterLat = result.lat;
                              _mapCenterLon = result.lon;
                              _nearbyRestaurants = [];
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.colorScheme.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                size: 18,
                                color: theme.colorScheme.mutedForeground,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedLocationName ?? '장소를 검색하세요',
                                  style: TextStyle(
                                    color: _selectedLocationName != null
                                        ? theme.colorScheme.foreground
                                        : theme.colorScheme.mutedForeground,
                                  ),
                                ),
                              ),
                              if (_selectedLocationName != null)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedLat = null;
                                      _selectedLon = null;
                                      _selectedLocationName = null;
                                      _selectedCategoryName = null;
                                      _nearbyRestaurants = [];
                                    });
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                    color: theme.colorScheme.mutedForeground,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Max participants select
                      ShadSelectFormField<double>(
                        id: 'max_participants',
                        label: const Text('최대 인원'),
                        placeholder: const Text('인원을 선택하세요'),
                        initialValue: 4.0,
                        options: List.generate(7, (i) {
                          final val = (i + 2).toDouble();
                          return ShadOption(
                            value: val,
                            child: Text('${val.toInt()}명'),
                          );
                        }),
                        selectedOptionBuilder: (context, value) {
                          return Text('${value.toInt()}명');
                        },
                      ),
                      const SizedBox(height: 16),

                      ShadInputFormField(
                        id: 'description',
                        label: const Text('상세 설명'),
                        placeholder: const Text('파티에 대해 설명해주세요'),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '설명을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      ShadButton(
                        enabled: !isLoading,
                        onPressed: _submit,
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.primaryForeground,
                                ),
                              )
                            : const Text('파티 생성'),
                      ),
                    ],
                  ),
                ),
              ),
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

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final formData =
          Map<String, dynamic>.from(_formKey.currentState!.value);

      // Add manually managed date/time
      formData['start_time'] = _startTime.toIso8601String();

      // Add selected location coordinates
      if (_selectedLat != null) formData['location_lat'] = _selectedLat;
      if (_selectedLon != null) formData['location_lon'] = _selectedLon;
      if (_selectedLocationName != null) {
        formData['location_name'] = _selectedLocationName;
      }
      if (_selectedCategoryName != null) {
        formData['category_name'] = _selectedCategoryName;
      }

      try {
        await ref.read(partyControllerProvider.notifier).createParty(formData);
        if (mounted) {
          context.pop();
          ShadSonner.of(context).show(
            const ShadToast(
              title: Text('파티가 생성되었습니다!'),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ShadSonner.of(context).show(
            ShadToast.destructive(
              title: Text('생성 실패: $e'),
            ),
          );
        }
      }
    }
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
                      '파티 만들기',
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
