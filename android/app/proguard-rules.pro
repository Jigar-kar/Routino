# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Workaround for local_auth and plugins that require reflection
-keep class androidx.biometric.** { *; }
-keep class androidx.core.** { *; }
-keep class androidx.lifecycle.** { *; }
