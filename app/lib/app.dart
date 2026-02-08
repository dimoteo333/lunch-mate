import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_constants.dart';

class LunchMateApp extends ConsumerWidget {
  const LunchMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShadApp.router(
      title: AppConstants.appName,
      theme: AppTheme.liquidGlassLightTheme,
      darkTheme: AppTheme.liquidGlassDarkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      materialThemeBuilder: (context, builtTheme) {
        final brightness = builtTheme.brightness;
        final base = brightness == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme;
        return base.copyWith(
          scaffoldBackgroundColor: Colors.transparent,
        );
      },
      builder: (context, child) {
        return ShadSonner(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
