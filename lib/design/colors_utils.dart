import 'dart:ui';

/// Utility class to convert hex color strings to [Color] objects.
class ColorUtils {
  /// Converts a hex color string (e.g., "#FFFFFF" or "FFFFFF") to a [Color].
  /// Supports both 6-digit (RGB) and 8-digit (ARGB) hex values.
  ///
  /// Example usage:
  /// ```dart
  /// Color color = ColorUtils.fromHex("#0F151A");
  /// ```
  static Color fromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Adds the alpha value if not present.
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
