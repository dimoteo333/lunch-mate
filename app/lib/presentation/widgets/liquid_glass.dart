import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../core/theme/app_theme.dart';

/// Animated background blobs matching the liquid-glass hero section.
/// Creates 3 colored blobs (blue, purple, indigo) that drift organically.
class LiquidBackground extends StatefulWidget {
  final Widget child;
  const LiquidBackground({super.key, required this.child});

  @override
  State<LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<LiquidBackground>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDark = ShadTheme.of(context).brightness == Brightness.dark;
    final blobAlpha = isDark ? 0.2 : 0.08;
    final bgColor = isDark ? AppTheme.background : AppTheme.lightBackground;

    return Stack(
      children: [
        // Background
        Container(color: bgColor),

        // Animated blobs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;
            return Stack(
              children: [
                // Blue blob (top-left)
                _Blob(
                  color: AppTheme.blue600.withValues(alpha: blobAlpha),
                  size: size.width * 1.0,
                  offset: Offset(
                    -size.width * 0.2 + math.sin(t * 2 * math.pi) * 30,
                    -size.height * 0.1 + math.cos(t * 2 * math.pi) * 50,
                  ),
                  blur: 120,
                ),
                // Purple blob (top-right, delayed)
                _Blob(
                  color: AppTheme.purple600.withValues(alpha: blobAlpha),
                  size: size.width * 0.8,
                  offset: Offset(
                    size.width * 0.5 +
                        math.sin((t + 0.33) * 2 * math.pi) * 30,
                    size.height * 0.15 +
                        math.cos((t + 0.33) * 2 * math.pi) * 50,
                  ),
                  blur: 120,
                ),
                // Indigo blob (bottom-left, delayed more)
                _Blob(
                  color: AppTheme.indigo600.withValues(alpha: blobAlpha),
                  size: size.width * 0.9,
                  offset: Offset(
                    size.width * 0.1 +
                        math.sin((t + 0.66) * 2 * math.pi) * 20,
                    size.height * 0.6 +
                        math.cos((t + 0.66) * 2 * math.pi) * 20,
                  ),
                  blur: 120,
                ),
              ],
            );
          },
        ),

        // Content
        widget.child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  final Offset offset;
  final double blur;

  const _Blob({
    required this.color,
    required this.size,
    required this.offset,
    required this.blur,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        foregroundDecoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: blur,
            sigmaY: blur,
            tileMode: TileMode.decal,
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

/// A card with glassmorphism effect matching the liquid-glass GlassCard.
/// Semi-transparent bg, backdrop blur, subtle white border, shadow.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final Color? backgroundColor;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.all(32),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = ShadTheme.of(context).brightness;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: padding,
          decoration: AppTheme.glassDecoration(
            borderRadius: borderRadius,
            backgroundColor: backgroundColor,
            brightness: brightness,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Gradient text effect matching liquid-glass text-gradient.
/// White → 80% white → 50% white from left to right.
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final List<Color>? colors;

  const GradientText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ShadTheme.of(context).brightness == Brightness.dark;
    final defaultColors = isDark
        ? const [
            Color(0xFFFFFFFF),
            Color(0xCCFFFFFF),
            Color(0x80FFFFFF),
          ]
        : const [
            Color(0xFF0F172A),
            Color(0xFF334155),
            Color(0xFF64748B),
          ];

    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: colors ?? defaultColors,
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}

/// Pulsing dot indicator matching the liquid-glass hero badge.
class PulsingDot extends StatefulWidget {
  final Color color;
  final double size;

  const PulsingDot({
    super.key,
    this.color = AppTheme.blue500,
    this.size = 8,
  });

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2,
      height: widget.size * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ping effect
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Transform.scale(
                scale: 1.0 + _controller.value * 1.5,
                child: Opacity(
                  opacity: (1.0 - _controller.value) * 0.75,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                    ),
                  ),
                ),
              );
            },
          ),
          // Static dot
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Glass-styled bottom navigation bar with backdrop blur.
class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<GlassNavItem> items;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = isDark ? AppTheme.textSubtle : AppTheme.lightTextSubtle;
    final navBgColor = isDark
        ? const Color(0x66000000)
        : const Color(0x66FFFFFF);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 64,
            decoration: AppTheme.glassDecoration(
              borderRadius: 100,
              backgroundColor: navBgColor,
              brightness: theme.brightness,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(items.length, (i) {
                final selected = i == currentIndex;
                return GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[i].icon,
                          color: selected ? selectedColor : unselectedColor,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[i].label,
                          style: TextStyle(
                            color: selected ? selectedColor : unselectedColor,
                            fontSize: 11,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassNavItem {
  final IconData icon;
  final String label;
  const GlassNavItem({required this.icon, required this.label});
}
