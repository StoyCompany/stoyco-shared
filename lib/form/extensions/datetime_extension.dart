import 'package:flutter/material.dart';

const kNumberCellsOfMonth = 42;
const kNumberOfWeekday = 7;
const kNumberOfMonth = 12;

const kWeekdayNames = <String>[
  'Domingo',
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
];
const kWeekdayShortNames = <String>[
  'Dom',
  'Lun',
  'Mar',
  'Mié',
  'Jue',
  'Vie',
  'Sáb',
];
const kWeekdayAbbreviations = <String>['D', 'L', 'M', 'X', 'J', 'V', 'S'];
const kMonthNames = <String>[
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];
const kMonthShortNames = <String>[
  'Ene',
  'Feb',
  'Mar',
  'Abr',
  'May',
  'Jun',
  'Jul',
  'Ago',
  'Sep',
  'Oct',
  'Nov',
  'Dic',
];

extension DateTimeExtension on DateTime {
  DateTime get nextMonth => DateTime(year, month + 1);
  DateTime get previousMonth => DateTime(year, month - 1);

  DateTime get nextYear => DateTime(year + 1);
  DateTime get previousYear => DateTime(year - 1);

  DateTimeRange monthDateTimeRange({
    bool includeTrailingAndLeadingDates = false,
  }) {
    DateTime start = DateTime(year, month);
    if (includeTrailingAndLeadingDates) {
      start = start.subtract(Duration(days: start.weekday % kNumberOfWeekday));
    }
    final DateTime end = includeTrailingAndLeadingDates
        ? start.add(const Duration(days: kNumberCellsOfMonth))
        : DateTime(year, month + 1, 0);
    return DateTimeRange(start: start, end: end);
  }

  bool isInRange(DateTimeRange range) =>
      difference(range.start).inSeconds >= 0 &&
      difference(range.end).inSeconds <= 0;

  int monthCompareTo(DateTime other) {
    if (year < other.year) {
      return -1;
    } else if (year > other.year) {
      return 1;
    } else {
      if (month < other.month) {
        return -1;
      } else if (month > other.month) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  int dateCompareTo(DateTime other) {
    final cmp = monthCompareTo(other);
    if (cmp == 0) {
      if (day < other.day) {
        return -1;
      } else if (day > other.day) {
        return 1;
      } else {
        return 0;
      }
    } else {
      return cmp;
    }
  }
}
