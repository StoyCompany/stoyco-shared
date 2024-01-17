import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/utils/text_button.dart';

/// Enum representing the type of selector in a custom Cupertino date picker.
enum _SelectorType { day, month, year }

/// A custom Cupertino-style date picker widget.
///
/// This widget allows the user to select a date from a range of selectable dates.
/// It provides various customization options such as item extent, selection overlay,
/// diameter ratio, background color, text styles, and more.
///
/// Example usage:
///
/// ```dart
/// StoycoCupertinoDatePicker(
///   itemExtent: 50,
///   onSelectedItemChanged: (DateTime selectedDate) {
///     // Handle selected date change
///   },
///   minDate: DateTime(2022, 1, 1),
///   maxDate: DateTime(2022, 12, 31),
///   selectedDate: DateTime.now(),
///   selectedStyle: TextStyle(color: Colors.blue),
///   unselectedStyle: TextStyle(color: Colors.grey),
///   disabledStyle: TextStyle(color: Colors.red),
///   backgroundColor: Colors.white,
///   squeeze: 1.45,
///   diameterRatio: 1.1,
///   magnification: 1.0,
///   offAxisFraction: 0.0,
///   useMagnifier: false,
///   selectionOverlay: CupertinoPickerDefaultSelectionOverlay(),
/// )
/// ```

class StoycoCupertinoDatePicker extends StatefulWidget {
  final double itemExtent;
  final Widget selectionOverlay;
  final double diameterRatio;
  final Color? backgroundColor;
  final double offAxisFraction;
  final bool useMagnifier;
  final double magnification;
  final double squeeze;
  final void Function(DateTime) onSelectedItemChanged;
  // Text style of selected item
  final TextStyle? selectedStyle;
  // Text style of unselected item
  final TextStyle? unselectedStyle;
  // Text style of disabled item
  final TextStyle? disabledStyle;
  // Minimum selectable date
  final DateTime? minDate;
  // Maximum selectable date
  final DateTime? maxDate;
  // Initially selected date
  final DateTime? selectedDate;
  const StoycoCupertinoDatePicker({
    Key? key,
    required this.itemExtent,
    required this.onSelectedItemChanged,
    this.minDate,
    this.maxDate,
    this.selectedDate,
    this.selectedStyle,
    this.unselectedStyle,
    this.disabledStyle,
    this.backgroundColor,
    this.squeeze = 1.45,
    this.diameterRatio = 1.1,
    this.magnification = 1.0,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.selectionOverlay = const CupertinoPickerDefaultSelectionOverlay(),
  }) : super(key: key);
  @override
  State<StoycoCupertinoDatePicker> createState() =>
      _StoycoCupertinoDatePickerState();
}

class _StoycoCupertinoDatePickerState extends State<StoycoCupertinoDatePicker> {
  late DateTime _minDate;
  late DateTime _maxDate;
  late DateTime _selectedDate;
  late int _selectedDayIndex;
  late int _selectedMonthIndex;
  late int _selectedYearIndex;
  late final FixedExtentScrollController _dayScrollController;
  late final FixedExtentScrollController _monthScrollController;
  late final FixedExtentScrollController _yearScrollController;
  final _days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  final _months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio ',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  @override
  void initState() {
    super.initState();
    _validateDates();
    _dayScrollController = FixedExtentScrollController();
    _monthScrollController = FixedExtentScrollController();
    _yearScrollController = FixedExtentScrollController();
    _initDates();
  }

  void _validateDates() {
    if (widget.minDate != null && widget.maxDate != null) {
      assert(!widget.minDate!.isAfter(widget.maxDate!));
    }
    if (widget.minDate != null && widget.selectedDate != null) {
      assert(!widget.minDate!.isAfter(widget.selectedDate!));
    }
    if (widget.maxDate != null && widget.selectedDate != null) {
      assert(!widget.selectedDate!.isAfter(widget.maxDate!));
    }
  }

  void _initDates() {
    final currentDate = DateTime.now();
    _minDate = widget.minDate ?? DateTime(currentDate.year - 100);
    _maxDate = widget.maxDate ?? DateTime(currentDate.year + 100);
    if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate!;
    } else if (!currentDate.isBefore(_minDate) &&
        !currentDate.isAfter(_maxDate)) {
      _selectedDate = currentDate;
    } else {
      _selectedDate = _minDate;
    }
    _selectedDayIndex = _selectedDate.day - 1;
    _selectedMonthIndex = _selectedDate.month - 1;
    _selectedYearIndex = _selectedDate.year - _minDate.year;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => {
        _scrollList(_dayScrollController, _selectedDayIndex),
        _scrollList(_monthScrollController, _selectedMonthIndex),
        _scrollList(_yearScrollController, _selectedYearIndex),
      },
    );
  }

  void _scrollList(FixedExtentScrollController controller, int index) {
    controller.animateToItem(
      index,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
    );
  }

  /// check if selected year is a leap year
  bool _isLeapYear() {
    final year = _minDate.year + _selectedYearIndex;
    return year % 4 == 0 &&
        (year % 100 != 0 || (year % 100 == 0 && year % 400 == 0));
  }

  /// get number of days for the selected month
  int _numberOfDays() {
    if (_selectedMonthIndex == 1) {
      _days[1] = _isLeapYear() ? 29 : 28;
    }
    return _days[_selectedMonthIndex];
  }

  void _onSelectedItemChanged(int index, _SelectorType type) {
    DateTime temp;
    switch (type) {
      case _SelectorType.day:
        temp = DateTime(
          _minDate.year + _selectedYearIndex,
          _selectedMonthIndex + 1,
          index + 1,
        );
        break;
      case _SelectorType.month:
        temp = DateTime(
          _minDate.year + _selectedYearIndex,
          index + 1,
          _selectedDayIndex + 1,
        );
        break;
      case _SelectorType.year:
        temp = DateTime(
          _minDate.year + index,
          _selectedMonthIndex + 1,
          _selectedDayIndex + 1,
        );
        break;
    }

    // return if selected date is not the min - max date range
    // scroll selector back to the valid point
    if (temp.isBefore(_minDate) || temp.isAfter(_maxDate)) {
      switch (type) {
        case _SelectorType.day:
          _dayScrollController.jumpToItem(_selectedDayIndex);
          break;
        case _SelectorType.month:
          _monthScrollController.jumpToItem(_selectedMonthIndex);
          break;
        case _SelectorType.year:
          _yearScrollController.jumpToItem(_selectedYearIndex);
          break;
      }
      return;
    }
    // update selected date
    _selectedDate = temp;
    // adjust other selectors when one selctor is changed
    switch (type) {
      case _SelectorType.day:
        _selectedDayIndex = index;
        break;
      case _SelectorType.month:
        _selectedMonthIndex = index;
        // if month is changed to february &
        // selected day is greater than 29,
        // set the selected day to february 29 for leap year
        // else to february 28
        if (_selectedMonthIndex == 1 && _selectedDayIndex > 27) {
          _selectedDayIndex = _isLeapYear() ? 28 : 27;
        }
        // if selected day is 31 but current selected month has only
        // 30 days, set selected day to 30
        if (_selectedDayIndex == 30 && _days[_selectedMonthIndex] == 30) {
          _selectedDayIndex = 29;
        }
        break;
      case _SelectorType.year:
        _selectedYearIndex = index;
        // if selected month is february & selected day is 29
        // But now year is changed to non-leap year
        // set the day to february 28
        if (!_isLeapYear() &&
            _selectedMonthIndex == 1 &&
            _selectedDayIndex == 28) {
          _selectedDayIndex = 27;
        }
        break;
    }
    HapticFeedback.heavyImpact();
    setState(() {});
    widget.onSelectedItemChanged(_selectedDate);
  }

  /// check if the given day, month or year index is disabled
  bool _isDisabled(int index, _SelectorType type) {
    DateTime temp;
    switch (type) {
      case _SelectorType.day:
        temp = DateTime(
          _minDate.year + _selectedYearIndex,
          _selectedMonthIndex + 1,
          index + 1,
        );
        break;
      case _SelectorType.month:
        temp = DateTime(
          _minDate.year + _selectedYearIndex,
          index + 1,
          _selectedDayIndex + 1,
        );
        break;
      case _SelectorType.year:
        temp = DateTime(
          _minDate.year + index,
          _selectedMonthIndex + 1,
          _selectedDayIndex + 1,
        );
        break;
    }
    return temp.isAfter(_maxDate) || temp.isBefore(_minDate);
  }

  Widget _selector({
    required List<dynamic> values,
    required int selectedValueIndex,
    required bool Function(int) isDisabled,
    required void Function(int) onSelectedItemChanged,
    required FixedExtentScrollController scrollController,
  }) =>
      CupertinoPicker.builder(
        childCount: values.length,
        squeeze: widget.squeeze,
        itemExtent: widget.itemExtent,
        scrollController: scrollController,
        useMagnifier: widget.useMagnifier,
        diameterRatio: widget.diameterRatio,
        magnification: widget.magnification,
        backgroundColor: widget.backgroundColor,
        offAxisFraction: widget.offAxisFraction,
        selectionOverlay: Container(),
        onSelectedItemChanged: onSelectedItemChanged,
        itemBuilder: (context, index) => Container(
          height: widget.itemExtent,
          alignment: Alignment.center,
          child: Text(
            '${values[index]}',
            style: index == selectedValueIndex
                ? widget.selectedStyle ??
                    const TextStyle(
                      fontFamily: 'Akkurat Pro',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xfff2f2fa),
                    )
                : isDisabled(index)
                    ? widget.disabledStyle ??
                        const TextStyle(
                          fontFamily: 'Akkurat Pro',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xfff2f2fa),
                        )
                    : widget.unselectedStyle ??
                        const TextStyle(
                          fontFamily: 'Akkurat Pro',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xfff2f2fa),
                        ),
          ),
        ),
      );

  Widget _daySelector() => _selector(
        values: List.generate(_numberOfDays(), (index) => index + 1),
        selectedValueIndex: _selectedDayIndex,
        scrollController: _dayScrollController,
        isDisabled: (index) => _isDisabled(index, _SelectorType.day),
        onSelectedItemChanged: (v) => _onSelectedItemChanged(
          v,
          _SelectorType.day,
        ),
      );

  Widget _monthSelector() => _selector(
        values: _months,
        selectedValueIndex: _selectedMonthIndex,
        scrollController: _monthScrollController,
        isDisabled: (index) => _isDisabled(index, _SelectorType.month),
        onSelectedItemChanged: (v) => _onSelectedItemChanged(
          v,
          _SelectorType.month,
        ),
      );

  Widget _yearSelector() => _selector(
        values: List.generate(
          _maxDate.year - _minDate.year + 1,
          (index) => _minDate.year + index,
        ),
        selectedValueIndex: _selectedYearIndex,
        scrollController: _yearScrollController,
        isDisabled: (index) => _isDisabled(index, _SelectorType.year),
        onSelectedItemChanged: (v) => _onSelectedItemChanged(
          v,
          _SelectorType.year,
        ),
      );

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                Positioned(
                  left: 40,
                  right: 32,
                  top: 85,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF4639E7)),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: _daySelector()),
                    Expanded(child: _monthSelector()),
                    Expanded(child: _yearSelector()),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xff92929d),
            thickness: 1,
            indent: 32,
            endIndent: 32,
          ),
          const Gap(16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        fontFamily: 'Akkurat Pro',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffde2424),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: TextButtonStoyco(
                    text: 'Aceptar',
                    height: 40,
                    onTap: () {
                      Navigator.of(context).pop(_selectedDate);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  @override
  void dispose() {
    _dayScrollController.dispose();
    _monthScrollController.dispose();
    _yearScrollController.dispose();
    super.dispose();
  }
}
