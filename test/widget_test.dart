import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:revoltronx_yoga_app/main.dart';

void main() {
  testWidgets('App loads and shows start screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('RevoltronX Wellness'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
  });
}
