import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_go/app/theme/theme.dart';
import 'package:e_go/app/theme/colors.dart';

void main() {
  testWidgets('EGoTheme creates valid ThemeData', (WidgetTester tester) async {
    final theme = EGoTheme.light;
    expect(theme, isNotNull);
    expect(theme.colorScheme.primary, equals(EGoColors.brandPrimary));
    expect(theme.colorScheme.surface, equals(const Color(0xFFFFFFFF)));
    expect(theme.scaffoldBackgroundColor, equals(EGoColors.grey50));
  });
}
