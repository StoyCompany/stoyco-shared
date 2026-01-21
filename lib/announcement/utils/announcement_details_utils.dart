import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/utils/logger.dart';

class AnnouncementDetailsUtils {
  /// Formats a UTC date string to a more readable format.
  ///
  /// Takes a date string in ISO 8601 format (e.g., "2023-09-15T10:30:00Z")
  /// and converts it to a user-friendly format with month abbreviation,
  /// day with suffix, and 12-hour time format with am/pm.
  ///
  /// Returns an empty string if [dateString] is empty.
  ///
  /// Example:
  /// ```dart
  /// // Returns "Sep 15th, 10:30 am" (adjusted to local timezone)
  /// final formattedDate = AnnouncementDetailsUtils.formatDate("2023-09-15T10:30:00Z");
  /// ```
  static String formatDate(String dateString, {bool showTime = true}) {
    if (dateString.isEmpty) return '';

    try {
      // Parse the UTC date string
      final DateTime utcDate = DateTime.parse(dateString);

      // Convert to local time
      final DateTime localDate = utcDate.toLocal();

      // Month abbreviation
      final List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final String month = months[localDate.month - 1];

      // Day with suffix
      final String day = _getDayWithSuffix(localDate.day);

      // Time in 12-hour format with am/pm
      final int hour = localDate.hour > 12
          ? localDate.hour - 12
          : (localDate.hour == 0 ? 12 : localDate.hour);
      final String period = localDate.hour >= 12 ? 'PM' : 'AM';
      final String minute = localDate.minute.toString().padLeft(2, '0');

      return '$month $day${showTime ? ', $hour:$minute $period' : ''}';
    } catch (e) {
      return dateString;
    }
  }

  /// Adds the appropriate suffix to a day number.
  ///
  /// Handles special cases for 11th, 12th, and 13th, and then
  /// applies the appropriate suffix (st, nd, rd, th) based on
  /// the last digit of the day.
  ///
  /// Examples:
  /// ```dart
  /// AnnouncementDetailsUtils._getDayWithSuffix(1);  // Returns "1st"
  /// AnnouncementDetailsUtils._getDayWithSuffix(2);  // Returns "2nd"
  /// AnnouncementDetailsUtils._getDayWithSuffix(3);  // Returns "3rd"
  /// AnnouncementDetailsUtils._getDayWithSuffix(4);  // Returns "4th"
  /// AnnouncementDetailsUtils._getDayWithSuffix(11); // Returns "11th"
  /// AnnouncementDetailsUtils._getDayWithSuffix(21); // Returns "21st"
  /// ```
  static String _getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }

    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  static Map<String, String>? buildHtmlCustomStyles({
    required BuildContext context,
    required dynamic element,
  }) {
    final bool isPhone = StoycoScreenSize.isPhone(context);
    final bool containsImage =
        element.children.any((child) => child.localName == 'img');

    // Base styles - set all text to white
    final Map<String, String> baseStyles = {
      'color': 'white',
    };

    // Element-specific styles
    Map<String, String> elementSpecificStyles = {};

    switch (element.localName) {
      case 'p':
        String textAlign = 'justify';
        if (containsImage) {
          if (element.className == 'ql-align-right') {
            textAlign = 'right';
          } else if (element.className == 'ql-align-center') {
            textAlign = 'center';
          }
        }
        elementSpecificStyles = {
          'font-size': '${StoycoScreenSize.fontSize(
            context,
            14,
            phone: 12,
            tablet: 13,
            desktopLarge: 16,
          )}px',
          'text-align': textAlign,
        };
      case 'img':
        return {
          'border-radius': '15px',
          'max-height': '${StoycoScreenSize.height(
            context,
            595,
            phone: 300,
            tablet: 450,
            desktopLarge: 650,
          )}px',
          'object-fit': 'cover',
        };
      case 'h1':
        elementSpecificStyles = {
          'font-size': '${StoycoScreenSize.fontSize(
            context,
            isPhone ? 16 : 24,
            phone: 16,
            tablet: 20,
            desktopLarge: 28,
          )}px',
          'font-weight': 'bold',
        };
      case 'h2':
        elementSpecificStyles = {
          'font-size': '${StoycoScreenSize.fontSize(
            context,
            isPhone ? 15 : 20,
            phone: 15,
            tablet: 18,
            desktopLarge: 24,
          )}px',
          'font-weight': 'bold',
        };
      case 'h3':
        elementSpecificStyles = {
          'font-size': '${StoycoScreenSize.fontSize(
            context,
            isPhone ? 14 : 16,
            phone: 14,
            tablet: 15,
            desktopLarge: 18,
          )}px',
          'font-weight': 'bold',
        };
      case 'h4':
        elementSpecificStyles = {
          'font-size': '${StoycoScreenSize.fontSize(
            context,
            isPhone ? 13 : 14,
            phone: 13,
            tablet: 14,
            desktopLarge: 16,
          )}px',
          'font-weight': 'bold',
        };
      case 'a':
        elementSpecificStyles = {
          // Links can keep their blue color
          'color': '#579dff',
          'font-weight': 'bold',
          'text-decoration': 'none',
          'font-size': '${StoycoScreenSize.fontSize(
            context,
            16,
            phone: 14,
            tablet: 15,
            desktopLarge: 18,
          )}px',
        };
      default:
        if (element.classes.contains('ql-align-right')) {
          elementSpecificStyles = {
            'text-align': 'right',
          };
        }
    }

    // Merge base styles with element-specific styles
    return {...baseStyles, ...elementSpecificStyles};
  }

  static String removeBackgroundColors(String htmlContent) {
    // Remove background-color inline styles
    final RegExp backgroundColorRegex = RegExp(
      r'background-color:\s*[^;]*;',
      caseSensitive: false,
    );
    String result = htmlContent.replaceAll(backgroundColorRegex, '');

    // Remove background inline styles
    final RegExp backgroundRegex = RegExp(
      r'background:\s*[^;]*;',
      caseSensitive: false,
    );
    result = result.replaceAll(backgroundRegex, '');

    // Replace all text colors with white
    final RegExp colorRegex = RegExp(
      r'color:\s*[^;]*;',
      caseSensitive: false,
    );
    result = result.replaceAll(colorRegex, 'color: white;');

    return result;
  }

  static int calculateCrossAxisCount(
    double maxWidth,
    double minCardWidth,
    double spacing,
  ) {
    final int count = ((maxWidth + spacing) / (minCardWidth + spacing)).floor();
    return count.clamp(1, 4);
  }

  static String formatCreationDate(String createdAt) {
    final int currentYear = DateTime.now().year;
    String formattedDate = '';

    try {
      final String dateStr = createdAt;
      if (dateStr.isNotEmpty) {
        final DateTime date = DateTime.parse(dateStr).toLocal();
        formattedDate = date.year == currentYear
            ? DateFormat('MMM dd | HH:mm').format(date)
            : DateFormat('MMM dd - yyyy | HH:mm').format(date);
      }
    } catch (e) {
      StoyCoLogger.info('Error parsing date: $e');
    }

    return formattedDate;
  }

  static const List<Color> primaryGradientColors = [
    Color(0xFF6C61FF),
    Color(0xFF6C61FF),
  ];
}
