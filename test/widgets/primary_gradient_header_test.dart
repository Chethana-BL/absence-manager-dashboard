import 'package:absence_manager_dashboard/core/theme/app_theme.dart';
import 'package:absence_manager_dashboard/core/widgets/primary_gradient_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PrimaryGradientHeader renders title and subtitle', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PrimaryGradientHeader(
            title: 'Absence Manager',
            subtitle: 'Subtitle',
          ),
        ),
      ),
    );

    expect(find.text('Absence Manager'), findsOneWidget);
    expect(find.text('Subtitle'), findsOneWidget);
  });

  testWidgets('PrimaryGradientHeader uses expected gradient colors', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PrimaryGradientHeader(title: 'Title', subtitle: 'Subtitle'),
        ),
      ),
    );

    final containerFinder = find.byKey(const Key('primary_gradient_header'));
    expect(containerFinder, findsOneWidget);

    final container = tester.widget<Container>(containerFinder);
    final decoration = container.decoration! as BoxDecoration;
    final gradient = decoration.gradient! as LinearGradient;

    expect(gradient.colors, <Color>[AppTheme.primary, AppTheme.secondary]);
  });
}
