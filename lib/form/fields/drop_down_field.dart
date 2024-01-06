import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stoyco_shared/form/forms.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A custom dropdown widget.
///
/// This widget extends [StatefulWidget]. It displays a dropdown that allows
/// the user to select an option. The selected option is displayed in a text field.
class StoycoDropdown extends StatefulWidget {
  /// Creates a [StoycoDropdown].
  ///
  /// The [formControl] and [options] arguments are required.
  const StoycoDropdown({
    Key? key,
    this.labelText,
    this.hintText,
    this.formControlName,
    this.inputFormatters,
    this.onChanged,
    this.validationMessages,
    required this.formControl,
    required this.options,
  }) : super(key: key);

  /// The label text of the dropdown.
  final String? labelText;

  /// The hint text of the dropdown.
  final String? hintText;

  /// The name of the form control.
  final String? formControlName;

  /// The form control of the dropdown.
  final FormControl<dynamic> formControl;

  /// The options of the dropdown.
  final List<String> options;

  /// The input formatters for the dropdown.
  final List<TextInputFormatter>? inputFormatters;

  /// The callback function that is called when the selected option changes.
  final void Function(FormControl<dynamic>)? onChanged;

  /// The validation messages for the dropdown.
  final Map<String, String Function(Object)>? validationMessages;

  @override
  _MyCustomDropdownState createState() => _MyCustomDropdownState();
}

class _MyCustomDropdownState extends State<StoycoDropdown>
    with SingleTickerProviderStateMixin {
  bool _isDropdownOpen = false;
  bool _isListViewClosed = true;
  bool _isInvalid = false;
  String _selectedOption = '';
  bool showErrorMessage = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  /// Toggles the dropdown.
  Future<void> _toggleDropdown() async {
    _clearErrorMessage();
    await _startAnimation();
    _updateErrorMessageVisibility();
  }

  /// Clears the error message.
  void _clearErrorMessage() {
    setState(() {
      _isListViewClosed = true;
    });
  }

  /// Starts the animation.
  Future<void> _startAnimation() async {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
      if (_isDropdownOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      _isListViewClosed = !_isDropdownOpen;
    });
    await _animationController.forward().whenComplete(() {
      setState(() {
        _isListViewClosed = !_isDropdownOpen;
      });
    });
  }

  /// Updates the visibility of the error message.
  void _updateErrorMessageVisibility() {
    setState(() {
      showErrorMessage = !_isDropdownOpen && _isInvalid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The text field that displays the selected option.
        StoyCoTextFormField(
          formControlName: widget.formControlName,
          labelText: widget.labelText,
          hintText: widget.hintText,
          inputFormatters: widget.inputFormatters,
          readOnly: true,
          mouseCursor: SystemMouseCursors.click,
          enableInteractiveSelection: false,
          showCursor: false,
          onTap: (value) {
            setState(() {
              _isInvalid = value.invalid;
            });
            _toggleDropdown();
          },
          onChanged: (formControl) {
            widget.onChanged?.call(formControl);
            setState(() {
              _isInvalid = formControl.invalid;
              if (!_isInvalid) {
                _selectedOption = formControl.value;
              } else {
                _selectedOption = '';
              }
            });
          },
          showErrors: (control) {
            return showErrorMessage && control.invalid && _isListViewClosed;
          },
          validationMessages:
              widget.validationMessages ?? StoycoForms.validationMessages(),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(1.00, 0.00),
                  end: Alignment(-1, 0),
                  colors: [Color(0xFF030A1A), Color(0xFF0C1B24)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                widget.labelText ?? '',
                style: const TextStyle(
                  color: Color(0xFF92929D),
                  fontSize: 12,
                  fontFamily: 'Akkurat Pro',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF92929D),
              fontSize: 14,
              fontFamily: 'Akkurat Pro',
              fontWeight: FontWeight.w400,
              height: 0.08,
            ),
            border: InputBorder.none,
            enabledBorder: !showErrorMessage && _isInvalid
                ? const OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF252836),
                      width: 1,
                    ),
                  )
                : null,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              borderSide: BorderSide(
                color: Color(0xFF252836),
                width: 1,
              ),
            ),
            suffixIcon: _isDropdownOpen
                ? const Icon(
                    Icons.expand_less_rounded,
                    color: Color(0xFF92929D),
                  )
                : const Icon(
                    Icons.expand_more_rounded,
                    color: Color(0xFF92929D),
                  ),
          ),
        ),
        // The dropdown that displays the options.
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isDropdownOpen ? 200.0 : 0.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF252836),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
          child: Opacity(
            opacity: _isDropdownOpen ? 1.0 : 0.0,
            child: ListView.builder(
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.options[index]),
                  onTap: () {
                    setState(() {
                      _selectedOption = widget.options[index];
                      widget.formControl.updateValue(_selectedOption);
                      _toggleDropdown();
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
