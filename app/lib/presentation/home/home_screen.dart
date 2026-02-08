import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:app/providers/party_provider.dart';
import 'package:app/presentation/widgets/party_card.dart';
import 'package:app/presentation/widgets/liquid_glass.dart';
import 'package:app/core/theme/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partiesAsync = ref.watch(partyListProvider);
    final theme = ShadTheme.of(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: LiquidBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Glass Navbar ──
              _GlassAppBar(
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
                child: RefreshIndicator(
                  color: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.card,
                  onRefresh: () async {
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
                            onTap: () => context
                                .push('/party/${parties[index].partyId}'),
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
                ),
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

  Widget _buildEmptyState(BuildContext context, ShadThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlassCard(
              borderRadius: 24,
              padding: const EdgeInsets.all(24),
              child: Icon(
                Icons.lunch_dining_rounded,
                size: 48,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '모집 중인 점심 파티가 없습니다',
              style: TextStyle(
                color: theme.colorScheme.mutedForeground,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ShadButton(
              onPressed: () => context.push('/party/create'),
              leading: const Icon(Icons.arrow_forward, size: 18),
              child: const Text('첫 파티 만들기'),
            ),
          ],
        ),
      ),
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
              '오류 발생: $err',
              style: TextStyle(color: theme.colorScheme.mutedForeground),
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

/// Glass-morphic app bar matching the liquid-glass navbar.
class _GlassAppBar extends StatelessWidget {
  final VoidCallback onFilterTap;

  const _GlassAppBar({required this.onFilterTap});

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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: AppTheme.glassDecoration(
              borderRadius: 100,
              backgroundColor: barBgColor,
              brightness: theme.brightness,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: theme.colorScheme.foreground,
                    ),
                    children: [
                      const TextSpan(text: 'Lunch Mate'),
                      TextSpan(
                        text: '.',
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ],
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
