import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:app/providers/party_provider.dart';
import 'package:app/providers/location_provider.dart';
import 'package:app/presentation/widgets/party_card.dart';
import 'package:app/presentation/widgets/liquid_glass.dart';
import 'package:app/presentation/widgets/kakao_map_widget.dart';
import 'package:app/core/theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showMapView = false;

  @override
  void initState() {
    super.initState();
    // 위치 초기화 → partyFilterProvider 업데이트 → partyListProvider 자동 재조회
    Future.microtask(() {
      ref.read(locationProvider.notifier).getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final partiesAsync = ref.watch(partyListProvider);
    final locationState = ref.watch(locationProvider);
    final theme = ShadTheme.of(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: LiquidBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Location AppBar ──
              _LocationAppBar(
                locationState: locationState,
                showMapView: _showMapView,
                onLocationTap: () {
                  ref.read(locationProvider.notifier).getCurrentLocation();
                },
                onToggleMapView: () {
                  setState(() => _showMapView = !_showMapView);
                },
                onFilterTap: () {
                  ShadSonner.of(context).show(
                    const ShadToast(
                      title: Text('필터 기능 준비 중'),
                    ),
                  );
                },
              ),

              // ── Body Content ──
              Expanded(
                child: _showMapView
                    ? _buildMapView(context, ref, partiesAsync, locationState, theme)
                    : _buildListView(context, ref, partiesAsync, theme),
              ),
            ],
          ),
        ),
      ),

      // ── Glass FAB ──
      floatingActionButton: _GlassFAB(
        onPressed: () => context.push('/party/create'),
      ),

      // ── Glass Bottom Nav ──
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: 0,
        items: const [
          GlassNavItem(icon: Icons.home_rounded, label: '홈'),
          GlassNavItem(icon: Icons.person_rounded, label: '프로필'),
        ],
        onTap: (index) {
          if (index == 1) context.go('/profile');
        },
      ),
    );
  }

  Widget _buildListView(
      BuildContext context, WidgetRef ref, AsyncValue<List> partiesAsync, ShadThemeData theme) {
    return RefreshIndicator(
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.card,
      onRefresh: () async {
        ref.read(locationProvider.notifier).getCurrentLocation();
        return ref.refresh(partyListProvider);
      },
      child: partiesAsync.when(
        data: (parties) {
          if (parties.isEmpty) {
            return _buildEmptyState(context, theme);
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: parties.length,
            itemBuilder: (context, index) {
              return PartyCard(
                party: parties[index],
                onTap: () =>
                    context.push('/party/${parties[index].partyId}'),
              );
            },
          );
        },
        error: (err, stack) =>
            _buildErrorState(context, ref, err, theme),
        loading: () => Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildMapView(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List> partiesAsync,
    LocationState locationState,
    ShadThemeData theme,
  ) {
    final lat = locationState.lat ?? 37.5665;
    final lon = locationState.lon ?? 126.9780;

    return partiesAsync.when(
      data: (parties) {
        final markers = <MapMarkerData>[];
        for (final party in parties) {
          if (party.locationLat != null && party.locationLon != null) {
            markers.add(MapMarkerData(
              lat: party.locationLat!,
              lon: party.locationLon!,
              label: party.title,
              partyId: party.partyId,
            ));
          }
        }

        return KakaoMapWidget(
          latitude: lat,
          longitude: lon,
          height: double.infinity,
          zoomLevel: 5,
          markers: markers,
          interactive: true,
          onMarkerTap: (partyId) {
            if (partyId != null) {
              context.push('/party/$partyId');
            }
          },
        );
      },
      error: (err, stack) => _buildErrorState(context, ref, err, theme),
      loading: () => Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ShadThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.15),
        Center(
          child: GlassCard(
            borderRadius: 24,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lunch_dining_rounded,
                  size: 56,
                  color: theme.colorScheme.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 24),
                Text(
                  '아직 모집 중인 점심 파티가 없어요',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.foreground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '첫 번째 파티를 만들어\n함께 점심 먹을 동료를 찾아보세요!',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.mutedForeground,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ShadButton(
                  onPressed: () => context.push('/party/create'),
                  leading: const Icon(Icons.add_rounded, size: 18),
                  child: const Text('파티 만들기'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(
      BuildContext context, WidgetRef ref, Object err, ShadThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GlassCard(
              borderRadius: 24,
              padding: EdgeInsets.all(24),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '파티 목록을 불러오지 못했어요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.foreground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '네트워크 연결을 확인하고 다시 시도해주세요.',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ShadButton.outline(
              onPressed: () => ref.refresh(partyListProvider),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Location-aware app bar with glassmorphic pill design.
class _LocationAppBar extends StatelessWidget {
  final LocationState locationState;
  final bool showMapView;
  final VoidCallback onLocationTap;
  final VoidCallback onToggleMapView;
  final VoidCallback onFilterTap;

  const _LocationAppBar({
    required this.locationState,
    required this.showMapView,
    required this.onLocationTap,
    required this.onToggleMapView,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final barBgColor = isDark
        ? const Color(0x66000000)
        : const Color(0x66FFFFFF);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: AppTheme.glassDecoration(
              borderRadius: 100,
              backgroundColor: barBgColor,
              brightness: theme.brightness,
            ),
            child: Row(
              children: [
                // Location info (tappable)
                Expanded(
                  child: GestureDetector(
                    onTap: onLocationTap,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        if (locationState.isLoading)
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.primary,
                            ),
                          )
                        else
                          Expanded(
                            child: Text(
                              locationState.shortAddress ?? '위치를 확인하세요',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: locationState.shortAddress != null
                                    ? theme.colorScheme.foreground
                                    : theme.colorScheme.mutedForeground,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Map/List toggle button
                ShadButton.ghost(
                  size: ShadButtonSize.sm,
                  onPressed: onToggleMapView,
                  child: Icon(
                    showMapView ? Icons.list_rounded : Icons.map_rounded,
                    color: theme.colorScheme.foreground.withValues(alpha: 0.8),
                    size: 20,
                  ),
                ),

                // Filter button
                ShadButton.ghost(
                  size: ShadButtonSize.sm,
                  onPressed: onFilterTap,
                  child: Icon(
                    Icons.tune_rounded,
                    color: theme.colorScheme.foreground.withValues(alpha: 0.8),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Glass-styled FAB with blur background.
class _GlassFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const _GlassFAB({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.add_rounded,
            color: theme.colorScheme.primaryForeground,
            size: 28,
          ),
        ),
      ),
    );
  }
}
