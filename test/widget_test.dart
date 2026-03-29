import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routino/features/splash/views/splash_screen.dart';
import 'package:routino/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Test App Loading', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SplashScreen()));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
