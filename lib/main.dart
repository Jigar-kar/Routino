import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/services/notification_service.dart';
import 'features/splash/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init failed: $e. Make sure to add google-services.json.');
  }

  // Initialize notifications (permissions, channel, FCM handlers)
  await NotificationService().initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeType = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    ThemeData getTheme() {
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
            textSecondary: themeNotifier.textColor.withValues(alpha: 0.7),
          );
      }
    }

    return MaterialApp(
      title: 'Routino',
      theme: getTheme(),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
