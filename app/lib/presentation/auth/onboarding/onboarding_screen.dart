import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../data/repositories/kakao_repository.dart';
import '../../widgets/liquid_glass.dart';
import '../../widgets/kakao_map_widget.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<ShadFormState>();
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Food category interests (multi-select)
  final Set<String> _selectedFoods = {};

  static const _foodCategories = [
    ('한식', Icons.rice_bowl_rounded),
    ('중식', Icons.ramen_dining_rounded),
    ('일식', Icons.set_meal_rounded),
    ('양식', Icons.dinner_dining_rounded),
    ('분식', Icons.lunch_dining_rounded),
    ('치킨', Icons.kebab_dining_rounded),
    ('피자', Icons.local_pizza_rounded),
    ('패스트푸드', Icons.fastfood_rounded),
    ('카페', Icons.coffee_rounded),
    ('뷔페', Icons.brunch_dining_rounded),
    ('술집', Icons.sports_bar_rounded),
  ];

  // Home location state
  double? _homeLat;
  double? _homeLon;
  String? _homeAddressName;
  bool _isLoadingHomeLocation = false;

  // Map center (local copy — does NOT watch locationProvider to avoid rebuild loops)
  double _homeMapCenterLat = 37.5665;
  double _homeMapCenterLon = 126.9780;
  bool _isLocationLoading = false;

  // Home location search
  final _homeSearchController = TextEditingController();
  Timer? _homeSearchDebounce;
  List<KakaoPlace> _homeSearchResults = [];
  bool _isHomeSearching = false;

  @override
  void dispose() {
    _pageController.dispose();
    _homeSearchController.dispose();
    _homeSearchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = ShadTheme.of(context);

    return Scaffold(
      body: LiquidBackground(
        child: ShadForm(
          key: _formKey,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildGlassAppBar(theme),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: [
                      _buildStep1(theme),
                      _buildStep2(theme),
                      _buildStep3(theme),
                      _buildStep4(authState.isLoading, theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Step 1: 기본 정보
  Widget _buildStep1(ShadThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '기본 정보를 입력해주세요',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.foreground,
              ),
            ),
            const SizedBox(height: 24),
            ShadInputFormField(
              id: 'nickname',
              label: const Text('닉네임'),
              placeholder: const Text('닉네임을 입력하세요'),
              validator: (value) {
                if (value.isEmpty) {
                  return '닉네임을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ShadInputFormField(
              id: 'team_name',
              label: const Text('팀/부서 (선택)'),
              placeholder: const Text('팀/부서명'),
            ),
            const SizedBox(height: 16),
            ShadInputFormField(
              id: 'job_title',
              label: const Text('직급 (선택)'),
              placeholder: const Text('직급을 입력하세요'),
            ),
            const SizedBox(height: 32),
            ShadButton(
              onPressed: () => _nextPage(),
              child: const Text('다음'),
            ),
          ],
        ),
      ),
    );
  }

  // Step 2: 상세 정보
  Widget _buildStep2(ShadThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '자신을 소개해주세요',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.foreground,
              ),
            ),
            const SizedBox(height: 24),
            ShadSelectFormField<String>(
              id: 'gender',
              label: const Text('성별'),
              placeholder: const Text('성별을 선택하세요'),
              options: const [
                ShadOption(value: 'male', child: Text('남성')),
                ShadOption(value: 'female', child: Text('여성')),
                ShadOption(value: 'other', child: Text('기타')),
              ],
              selectedOptionBuilder: (context, value) {
                final labels = {'male': '남성', 'female': '여성', 'other': '기타'};
                return Text(labels[value] ?? value);
              },
            ),
            const SizedBox(height: 16),
            ShadSelectFormField<String>(
              id: 'age_group',
              label: const Text('연령대'),
              placeholder: const Text('연령대를 선택하세요'),
              options: const [
                ShadOption(value: '20s', child: Text('20대')),
                ShadOption(value: '30s', child: Text('30대')),
                ShadOption(value: '40s', child: Text('40대')),
                ShadOption(value: '50+', child: Text('50대 이상')),
              ],
              selectedOptionBuilder: (context, value) {
                final labels = {
                  '20s': '20대',
                  '30s': '30대',
                  '40s': '40대',
                  '50+': '50대 이상',
                };
                return Text(labels[value] ?? value);
              },
            ),
            const SizedBox(height: 16),
            ShadInputFormField(
              id: 'bio',
              label: const Text('한줄 소개'),
              placeholder: const Text('자기소개를 입력하세요'),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ShadButton(
              onPressed: () => _nextPage(),
              child: const Text('다음'),
            ),
          ],
        ),
      ),
    );
  }

  // Step 3: 음식 카테고리 선택 (multi-select chip grid)
  Widget _buildStep3(ShadThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '좋아하는 음식을 선택해주세요',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.foreground,
              ),
            ),
            Text(
              '복수 선택 가능',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _foodCategories.map((category) {
                final (label, icon) = category;
                final isSelected = _selectedFoods.contains(label);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedFoods.remove(label);
                      } else {
                        _selectedFoods.add(label);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: isSelected
                          ? theme.colorScheme.primary.withValues(alpha: 0.15)
                          : theme.colorScheme.muted,
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 16,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.mutedForeground,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ShadButton(
              onPressed: () => _nextPage(),
              child: const Text('다음'),
            ),
          ],
        ),
      ),
    );
  }

  // Step 4: 위치 설정 & 완료
  Widget _buildStep4(bool isLoading, ShadThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final mapLat = _homeLat ?? _homeMapCenterLat;
    final mapLon = _homeLon ?? _homeMapCenterLon;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '거주지 위치를 설정해주세요',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.foreground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '정확한 위치는 공개되지 않으며,\n주변 파티 추천에만 사용됩니다.',
              style: TextStyle(color: theme.colorScheme.mutedForeground),
            ),
            const SizedBox(height: 16),

            // Search field
            ShadInput(
              controller: _homeSearchController,
              placeholder: const Text('동네를 검색하세요'),
              leading: const Icon(Icons.search_rounded, size: 18),
              onChanged: _onHomeSearchChanged,
            ),
            const SizedBox(height: 12),

            // Square map (1:1 aspect ratio)
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: KakaoMapWidget(
                  latitude: mapLat,
                  longitude: mapLon,
                  height: double.infinity,
                  zoomLevel: 4,
                  interactive: true,
                  onTap: _onHomeMapTap,
                  markers: _homeLat != null && _homeLon != null
                      ? [
                          MapMarkerData(
                            lat: _homeLat!,
                            lon: _homeLon!,
                            label: _homeAddressName ?? '거주지',
                          ),
                        ]
                      : [],
                ),
              ),
            ),

            // Loading indicator
            if (_isLoadingHomeLocation || _isHomeSearching) ...[
              const SizedBox(height: 12),
              const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ],

            // Selected location info card
            if (_homeAddressName != null && !_isLoadingHomeLocation) ...[
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
                child: Row(
                  children: [
                    Icon(
                      Icons.home_rounded,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _homeAddressName!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.foreground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Search results list
            if (_homeSearchResults.isNotEmpty && !_isHomeSearching) ...[
              const SizedBox(height: 8),
              ..._homeSearchResults.take(5).map(
                    (place) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: GestureDetector(
                        onTap: () => _selectHomePlace(place),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.black.withValues(alpha: 0.03),
                            border: Border.all(color: theme.colorScheme.border),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.place_rounded,
                                size: 16,
                                color: theme.colorScheme.mutedForeground,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place.placeName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: theme.colorScheme.foreground,
                                      ),
                                    ),
                                    if (place.roadAddressName != null)
                                      Text(
                                        place.roadAddressName!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              theme.colorScheme.mutedForeground,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            ],

            const SizedBox(height: 16),

            // Current location button
            ShadButton.outline(
              onPressed: _isLocationLoading ? null : _useCurrentLocation,
              leading: _isLocationLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location_rounded, size: 16),
              child: const Text('현재 위치 사용'),
            ),
            const SizedBox(height: 12),

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
                  : const Text('가입 완료'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassAppBar(ShadThemeData theme) {
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: AppTheme.glassDecoration(
              borderRadius: 100,
              backgroundColor: barBgColor,
              brightness: theme.brightness,
            ),
            child: Row(
              children: [
                if (_currentIndex > 0)
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.foreground,
                      size: 20,
                    ),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                else
                  const SizedBox(width: 48),
                Expanded(
                  child: Text(
                    '프로필 설정 (${_currentIndex + 1}/4)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.foreground,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentIndex == 0) {
      if (!(_formKey.currentState?.validate() ?? false)) {
        return;
      }
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onHomeSearchChanged(String query) {
    _homeSearchDebounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() => _homeSearchResults = []);
      return;
    }
    _homeSearchDebounce = Timer(const Duration(milliseconds: 400), () {
      _searchHomeLocation(query.trim());
    });
  }

  Future<void> _searchHomeLocation(String query) async {
    setState(() => _isHomeSearching = true);
    try {
      final location = ref.read(locationProvider);
      final kakao = ref.read(kakaoRepositoryProvider);
      final results = await kakao.searchKeyword(
        query,
        lat: location.lat,
        lon: location.lon,
        radius: 5000,
      );
      if (mounted) {
        setState(() {
          _homeSearchResults = results;
          _isHomeSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isHomeSearching = false);
      }
    }
  }

  Future<void> _onHomeMapTap(LatLng latLng) async {
    final lat = latLng.latitude;
    final lon = latLng.longitude;
    setState(() {
      _homeLat = lat;
      _homeLon = lon;
      _homeAddressName = null;
      _isLoadingHomeLocation = true;
      _homeSearchResults = [];
      _homeSearchController.clear();
    });

    try {
      final kakao = ref.read(kakaoRepositoryProvider);
      final address = await kakao.coordToAddress(lat, lon);
      if (mounted) {
        setState(() {
          _homeAddressName = address?.shortAddress ?? '선택한 위치';
          _isLoadingHomeLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _homeAddressName = '선택한 위치';
          _isLoadingHomeLocation = false;
        });
      }
    }
  }

  void _selectHomePlace(KakaoPlace place) {
    setState(() {
      _homeLat = place.lat;
      _homeLon = place.lon;
      _homeAddressName = place.placeName;
      _homeSearchResults = [];
      _homeSearchController.clear();
    });
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLocationLoading = true);
    await ref.read(locationProvider.notifier).getCurrentLocation();
    if (!mounted) return;

    final location = ref.read(locationProvider);
    setState(() => _isLocationLoading = false);

    if (location.permissionDenied) {
      final shouldOpen = await showAdaptiveDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog.adaptive(
          title: const Text('위치 권한 필요'),
          content: const Text('위치 권한이 거부되었습니다.\n설정에서 위치 권한을 허용해주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('설정 열기'),
            ),
          ],
        ),
      );
      if (shouldOpen == true) {
        await Geolocator.openAppSettings();
      }
      return;
    }

    if (location.error != null) {
      ShadSonner.of(context).show(
        ShadToast.destructive(title: Text(location.error!)),
      );
      return;
    }

    if (location.lat != null) {
      setState(() {
        _homeLat = location.lat;
        _homeLon = location.lon;
        _homeMapCenterLat = location.lat!;
        _homeMapCenterLon = location.lon!;
        _homeAddressName = location.shortAddress ?? location.addressName;
      });
    }
  }

  Future<void> _submit() async {
    final formData = <String, dynamic>{};
    final formValues = _formKey.currentState?.value ?? {};
    formData.addAll(Map<String, dynamic>.from(formValues));

    formData['interests'] = _selectedFoods.toList();
    if (_homeLat != null) formData['home_lat'] = _homeLat;
    if (_homeLon != null) formData['home_lon'] = _homeLon;

    try {
      await ref.read(authProvider.notifier).completeOnboarding(formData);
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ShadSonner.of(context).show(
          ShadToast.destructive(
            title: Text('가입 실패: $e'),
          ),
        );
      }
    }
  }
}
