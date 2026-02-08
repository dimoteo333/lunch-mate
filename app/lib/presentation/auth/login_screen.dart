import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/liquid_glass.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<ShadFormState>();
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_fadeAnim);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Status Badge (glass pill) ──
                      _buildStatusBadge(theme),
                      const SizedBox(height: 32),

                      // ── Title with gradient text ──
                      const GradientText(
                        text: 'Lunch\nMate',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w800,
                          height: 0.95,
                          letterSpacing: -3,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Subtitle ──
                      Text(
                        '따분한 점심을, 즐거운 약속으로.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.mutedForeground,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // ── Glass Card with login form ──
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '시작하기',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.foreground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '회사 이메일로 인증하세요',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ShadForm(
                              key: _formKey,
                              child: ShadInputFormField(
                                id: 'email',
                                label: const Text('회사 이메일'),
                                placeholder: const Text('user@company.com'),
                                keyboardType: TextInputType.emailAddress,
                                leading: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.email_outlined, size: 16),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '이메일을 입력해주세요';
                                  }
                                  if (!value.contains('@') ||
                                      !value.contains('.')) {
                                    return '올바른 이메일 형식이 아닙니다';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 24),

                            // ── Primary CTA ──
                            ShadButton(
                              enabled: !authState.isLoading,
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  final email =
                                      _formKey.currentState?.value['email']
                                          as String?;
                                  if (email == null) return;
                                  try {
                                    await ref
                                        .read(authProvider.notifier)
                                        .sendVerification(email);
                                    if (context.mounted) {
                                      context.push('/verify', extra: email);
                                      ShadSonner.of(context).show(
                                        const ShadToast(
                                          title: Text('인증 코드가 발송되었습니다'),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ShadSonner.of(context).show(
                                        ShadToast.destructive(
                                          title: Text('오류 발생: $e'),
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              child: authState.isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color:
                                            theme.colorScheme.primaryForeground,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('인증 코드 받기'),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward, size: 18),
                                      ],
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
        ),
      ),
    );
  }

  /// Glass pill badge matching the hero section badge
  Widget _buildStatusBadge(ShadThemeData theme) {
    return GlassCard(
      borderRadius: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PulsingDot(color: AppTheme.blue400, size: 6),
          const SizedBox(width: 10),
          Text(
            '새로운 점심 메이트를 만나보세요',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.foreground.withValues(alpha: 0.8),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
