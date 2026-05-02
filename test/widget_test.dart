import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mad_vibz/firebase_options.dart';
import 'package:mad_vibz/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  testWidgets('Vibzcheck shows auth or lobby shell', (WidgetTester tester) async {
    await tester.pumpWidget(const VibzcheckApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
