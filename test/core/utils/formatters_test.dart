import 'package:flutter_test/flutter_test.dart';
import 'package:nova/core/utils/formatters.dart';

void main() {
  group('NovaFormatters', () {
    test('toPercentage converts ratios (0..1) to percentages (0..100)', () {
      expect(NovaFormatters.toPercentage(0.85), 85.0);
      expect(NovaFormatters.toPercentage(1.0), 100.0);
      expect(NovaFormatters.toPercentage(0.5), 50.0);
    });

    test('toPercentage preserves values already on 0..100 scale', () {
      expect(NovaFormatters.toPercentage(66.7), 66.7);
      expect(NovaFormatters.toPercentage(100.0), 100.0);
      expect(NovaFormatters.toPercentage(0.0), 0.0);
      expect(NovaFormatters.toPercentage(null), 0.0);
    });

    test('toFraction returns a normalized 0..1 value', () {
      expect(NovaFormatters.toFraction(66.7), closeTo(0.667, 0.001));
      expect(NovaFormatters.toFraction(0.85), 0.85);
      expect(NovaFormatters.toFraction(100.0), 1.0);
      expect(NovaFormatters.toFraction(0), 0.0);
      expect(NovaFormatters.toFraction(null), 0.0);
    });

    test('formatPercentage formats 66.7 as "66.7%" and not "6670%"', () {
      expect(NovaFormatters.formatPercentage(66.7), '66.7%');
      expect(
        NovaFormatters.formatPercentage(66.7, useArabicPercent: true),
        '66.7٪',
      );
    });

    test('formatPercentage formats raw repeating decimals properly', () {
      expect(NovaFormatters.formatPercentage(66.666667), '66.7%');
      expect(
        NovaFormatters.formatPercentage(66.666667, useArabicPercent: true),
        '66.7٪',
      );
    });

    test('formatPercentage formats whole numbers without decimal point', () {
      expect(NovaFormatters.formatPercentage(100), '100%');
      expect(NovaFormatters.formatPercentage(100.0), '100%');
      expect(NovaFormatters.formatPercentage(1.0), '100%');
      expect(NovaFormatters.formatPercentage(0.85), '85%');
      expect(NovaFormatters.formatPercentage(0), '0%');
      expect(NovaFormatters.formatPercentage(null), '0%');
    });
  });
}
