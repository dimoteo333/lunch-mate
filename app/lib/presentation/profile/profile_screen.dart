import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../providers/auth_provider.dart';
import '../widgets/liquid_glass.dart';
import '../../core/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final theme = ShadTheme.of(context);

    if (user == null) {
      return Scaffold(
        body: LiquidBackground(
          child: Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: LiquidBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Glass Header
              _GlassHeader(user: user, theme: theme),

              // Body Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  child: Column(
                    children: [
                      // Avatar Card
                      GlassCard(
                        borderRadius: 24,
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.primary
                                        .withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  user.nickname[0],
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primaryForeground,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              user.nickname,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.foreground,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: TextStyle(
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Info Cards
                      GlassCard(
                        borderRadius: 20,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildInfoTile(
                              Icons.business_rounded,
                              '회사',
                              user.companyName ?? '미입력',
                              theme,
                            ),
                            const SizedBox(height: 16),
                            _buildInfoTile(
                              Icons.groups_rounded,
                              '팀',
                              user.teamName ?? '미입력',
                              theme,
                            ),
                            const SizedBox(height: 16),
                            _buildInfoTile(
                              Icons.badge_rounded,
                              '직급',
                              user.jobTitle ?? '미입력',
                              theme,
                            ),
                            const SizedBox(height: 16),
                            _buildInfoTile(
                              Icons.star_rounded,
                              '매너 점수',
                              '${user.ratingScore}점',
                              theme,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Logout Button
                      ShadButton.destructive(
                        width: double.infinity,
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('로그아웃'),
                              content: const Text('정말 로그아웃하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('로그아웃'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await ref.read(authProvider.notifier).logout();
                            if (context.mounted) {
                              context.go('/login');
                            }
                          }
                        },
                        leading: const Icon(Icons.logout_rounded, size: 18),
                        child: const Text('로그아웃'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Glass Bottom Nav
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: 1,
        items: const [
          GlassNavItem(icon: Icons.home_rounded, label: '홈'),
          GlassNavItem(icon: Icons.person_rounded, label: '프로필'),
        ],
        onTap: (index) {
          if (index == 0) context.go('/home');
        },
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value,
    ShadThemeData theme,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.muted,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.mutedForeground,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.foreground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlassHeader extends StatelessWidget {
  final dynamic user;
  final ShadThemeData theme;

  const _GlassHeader({required this.user, required this.theme});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: AppTheme.glassDecoration(
              borderRadius: 100,
              backgroundColor: barBgColor,
              brightness: theme.brightness,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_rounded,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  '프로필',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.foreground,
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
