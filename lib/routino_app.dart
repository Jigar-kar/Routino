import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'features/dashboard/views/dashboard_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/views/create_pin_screen.dart';
import 'features/auth/views/pin_lock_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      ref.read(authProvider.notifier).lockApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(authProvider);
    final themeType = ref.watch(themeProvider);

    Widget getHome() {
      switch (authStatus) {
        case AuthStatus.loading:
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        case AuthStatus.setupNeeded:
          return const CreatePinScreen();
        case AuthStatus.locked:
          return const PinLockScreen();
        case AuthStatus.unlocked:
          return const DashboardScreen();
      }
    }

    ThemeData getTheme() {
      final themeNotifier = ref.read(themeProvider.notifier);
      switch (themeType) {
        case ThemeType.light:
          return AppTheme.lightTheme;
        case ThemeType.dark:
          return AppTheme.darkTheme;
        case ThemeType.colorful:
          return AppTheme.colorfulTheme;
        case ThemeType.minimalist:
          return AppTheme.minimalistTheme;
        case ThemeType.glass:
          return AppTheme.glassTheme;
        case ThemeType.custom:
          return AppTheme.customTheme(
            primary: themeNotifier.primaryColor,
            secondary: themeNotifier.secondaryColor,
            background: themeNotifier.backgroundColor,
            surface: themeNotifier.surfaceColor,
            textPrimary: themeNotifier.textColor,
            textSecondary: themeNotifier.textColor.withOpacity(0.7),
          );
      }
    }

    return Scaffold(
      body: getHome(),
    );
  }
}