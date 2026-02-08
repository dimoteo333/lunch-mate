import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/liquid_glass.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<ShadFormState>();
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Interests state for individual checkboxes
  final Map<String, bool> _interests = {
    'startup': false,
    'marketing': false,
    'tech': false,
    'finance': false,
    'career': false,
    'hobby': false,
  };

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 설정 (${_currentIndex + 1}/4)'),
        leading: _currentIndex > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              )
            : null,
      ),
      body: LiquidBackground(
        child: ShadForm(
          key: _formKey,
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
                if (value == null || value.isEmpty) {
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

  // Step 3: 관심사
  Widget _buildStep3(ShadThemeData theme) {
    final interestLabels = {
      'startup': '스타트업',
      'marketing': '마케팅',
      'tech': '테크/개발',
      'finance': '재테크/투자',
      'career': '커리어',
      'hobby': '취미',
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '관심사를 선택해주세요',
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
            ...interestLabels.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ShadCheckboxFormField(
                  id: 'interest_${entry.key}',
                  initialValue: _interests[entry.key] ?? false,
                  onChanged: (value) {
                    setState(() {
                      _interests[entry.key] = value ?? false;
                    });
                  },
                  label: Text(entry.value),
                ),
              );
            }),
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
            const SizedBox(height: 24),
            ShadInputFormField(
              id: 'home_lat',
              label: const Text('위도'),
              placeholder: const Text('예: 37.4979'),
              keyboardType: TextInputType.number,
              initialValue: '37.4979',
            ),
            const SizedBox(height: 16),
            ShadInputFormField(
              id: 'home_lon',
              label: const Text('경도'),
              placeholder: const Text('예: 127.0276'),
              keyboardType: TextInputType.number,
              initialValue: '127.0276',
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
                  : const Text('가입 완료'),
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _submit() async {
    final formData = <String, dynamic>{};

    // Collect form values
    final formValues = _formKey.currentState?.value ?? {};
    formData.addAll(Map<String, dynamic>.from(formValues));

    // Collect interests from individual checkboxes
    final interests = <String>[];
    for (final entry in _interests.entries) {
      if (entry.value) {
        interests.add(entry.key);
      }
    }
    formData['interests'] = interests;

    // Remove individual interest keys
    formData.removeWhere((key, _) => key.startsWith('interest_'));

    // 데이터 타입 변환 (문자열 -> 숫자)
    if (formData['home_lat'] is String) {
      formData['home_lat'] = double.tryParse(formData['home_lat']);
    }
    if (formData['home_lon'] is String) {
      formData['home_lon'] = double.tryParse(formData['home_lon']);
    }

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
