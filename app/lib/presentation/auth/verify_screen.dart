import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:app/core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/liquid_glass.dart';

class VerifyScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyScreen({super.key, this.email = ''});

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  final _formKey = GlobalKey<ShadFormState>();

  @override
  Widget build(BuildContext context) {
    final email = widget.email.isEmpty
        ? (GoRouterState.of(context).extra as String? ?? '')
        : widget.email;

    final authState = ref.watch(authProvider);
    final theme = ShadTheme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: LiquidBackground(
        child: Stack(
          children: [
            // ── Main content ──
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24, topPadding + 56 + 16, 24, 24),
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '$email 로\n전송된 인증 코드를 입력해주세요',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.foreground,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ShadForm(
                          key: _formKey,
                          child: ShadInputFormField(
                            id: 'code',
                            label: const Text('인증 코드 6자리'),
                            placeholder: const Text('123456'),
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            leading: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(Icons.lock_outline, size: 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '인증 코드를 입력해주세요';
                              }
                              if (value.length < 6) {
                                return '6자리를 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        ShadButton(
                          enabled: !authState.isLoading,
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              final code =
                                  _formKey.currentState?.value['code'] as String?;
                              if (code == null) return;
                              try {
                                final isNewUser = await ref
                                    .read(authProvider.notifier)
                                    .verifyCode(email, code);

                                if (context.mounted) {
                                  if (isNewUser) {
                                    context.go('/onboarding');
                                  } else {
                                    context.go('/home');
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ShadSonner.of(context).show(
                                    ShadToast.destructive(
                                      title: Text('인증 실패: $e'),
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
                                    color: theme.colorScheme.primaryForeground,
                                  ),
                                )
                              : const Text('인증하기'),
                        ),
                      ],
                    ),
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
                      '이메일 인증',
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
