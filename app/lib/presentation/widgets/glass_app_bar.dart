import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../core/theme/app_theme.dart';

/// Reusable glassmorphic pill-shaped app bar with backdrop blur.
///
/// Used across detail screens (PartyDetail, PartyCreate, RestaurantSearch, Verify)
/// to provide a consistent transparent app bar with back navigation.
class GlassAppBar extends StatelessWidget {
  final String title;
  final double topPadding;
  final VoidCallback? onBack;

  const GlassAppBar({
    super.key,
    required this.title,
    required this.topPadding,
    this.onBack,
  });

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
                      onPressed:
                          onBack ?? () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: theme.colorScheme.foreground,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      title,
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
