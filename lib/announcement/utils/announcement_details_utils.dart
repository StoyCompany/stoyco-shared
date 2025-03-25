import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/utils/logger.dart';

class AnnouncementDetailsUtils {
  static String formatDate(String dateString) {
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
      final String period = localDate.hour >= 12 ? 'pm' : 'am';
      final String minute = localDate.minute.toString().padLeft(2, '0');

      return '$month $day, $hour:$minute $period';
    } catch (e) {
      return dateString;
    }
  }

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
        return {
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
        return {
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
        return {
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
        return {
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
        return {
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
        return {
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
          return {'text-align': 'right'};
        }
        return null;
    }
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
    Color(0xFF1f1c86),
    Color(0xFF4236df),
  ];
}
