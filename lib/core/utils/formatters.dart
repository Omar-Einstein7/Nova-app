/// Utility functions for formatting values across the NOVA application.
class NovaFormatters {
  NovaFormatters._();

  /// Converts a rate value into a percentage double in the range [0.0, 100.0].
  ///
  /// Handles both representations:
  /// - Ratio representation (0.0 to 1.0): e.g. 0.85 -> 85.0, 1.0 -> 100.0
  /// - Percentage representation (0.0 to 100.0): e.g. 66.7 -> 66.7, 100.0 -> 100.0
  static double toPercentage(num? rate) {
    if (rate == null) return 0.0;
    final val = rate.toDouble();
    if (val <= 0.0) return 0.0;
    // If val is <= 1.0 (e.g. 0.667 or 1.0 or 0.85), treat as a ratio (0..1)
    if (val <= 1.0) {
      return (val * 100.0).clamp(0.0, 100.0);
    }
    // Otherwise it's already a percentage (e.g. 66.7, 85.0, 100.0)
    return val.clamp(0.0, 100.0);
  }

  /// Converts a rate into a normalized fraction in the range [0.0, 1.0],
  /// suitable for progress bars, linear indicators, and widthFactor.
  static double toFraction(num? rate) {
    if (rate == null) return 0.0;
    final pct = toPercentage(rate);
    return (pct / 100.0).clamp(0.0, 1.0);
  }

  /// Formats a success rate into a clean percentage string.
  ///
  /// Examples:
  /// - 66.7 -> "66.7%" (or "66.7٪" if [useArabicPercent] is true)
  /// - 66.66667 -> "66.7%"
  /// - 100.0 -> "100%"
  /// - 0.85 -> "85%"
  /// - 0 -> "0%"
  static String formatPercentage(
    num? rate, {
    bool useArabicPercent = false,
    int decimalPlaces = 1,
  }) {
    final pct = toPercentage(rate);
    final fixedStr = pct.toStringAsFixed(decimalPlaces);
    final isWhole = (pct % 1 == 0) || fixedStr.endsWith('.0');
    final numberStr = isWhole ? pct.round().toString() : fixedStr;
    final symbol = useArabicPercent ? '٪' : '%';
    return '$numberStr$symbol';
  }
}
