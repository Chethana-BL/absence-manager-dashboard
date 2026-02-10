import 'package:absence_manager_dashboard/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders Absence Manager header', (WidgetTester tester) async {
    await tester.pumpWidget(const AbsenceManagerApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Absence Manager'), findsOneWidget);
  });
}
