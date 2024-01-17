import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stoyco_shared/form/forms.dart';
import 'package:reactive_forms/reactive_forms.dart';

class StoycoDropdown extends StatefulWidget {
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

  final String? labelText;
  final String? hintText;
  final String? formControlName;
  final FormControl<dynamic> formControl;
  final List<String> options;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(FormControl<dynamic>)? onChanged;
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

  Future<void> _toggleDropdown() async {
    _clearErrorMessage();
    await _startAnimation();
    _updateErrorMessageVisibility();
  }

  void _clearErrorMessage() {
    setState(() {
      _isListViewClosed = true;
    });
  }

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

  void _updateErrorMessageVisibility() {
    setState(() {
      showErrorMessage = !_isDropdownOpen && _isInvalid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            suffixIcon: UnconstrainedBox(
              child: SvgPicture.asset(
                'packages/stoyco_shared/lib/assets/icons/arrow-down-icon.svg',
                height: 20,
                width: 20,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFF2F2FA),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
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
