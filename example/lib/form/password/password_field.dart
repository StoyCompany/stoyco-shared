// import 'package:flutter_svg/svg.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:gap/gap.dart';

// import 'package:stoyco_shared/form/forms.dart';
// import 'package:reactive_forms/reactive_forms.dart';

// // Constantes de expresiones regulares
// const _digitRegExp = r'[0-9]';
// const _specialCharacterRegExp = r'[!@#$%^&*(),.?":{}|<>]';
// const _capitalLetterRegExp = r'[A-Z]';
// const _lowercaseLetterRegExp = r'[a-z]';
// const _spaceRegExp = r'[ ]';

// class StoycoPasswordField extends StatefulWidget {
//   final InputDecoration? decoration;
//   final String formControlName;
//   final FormControl<dynamic> formControl;
//   final String labelText;
//   final String hintText;
//   const StoycoPasswordField({
//     Key? key,
//     this.decoration,
//     required this.formControlName,
//     required this.formControl,
//     required this.labelText,
//     required this.hintText,
//   }) : super(key: key);

//   @override
//   State<StoycoPasswordField> createState() => _StoycoPasswordFielState();
// }

// class PasswordError {
//   final String message;
//   final bool Function()? validator;
//   const PasswordError({
//     required this.message,
//     required this.validator,
//   });
// }

// class _StoycoPasswordFielState extends State<StoycoPasswordField> {
//   late List<PasswordError> passwordErrors;
//   final Map<String, String Function(Object)> _validationMessages = {
//     ValidationMessage.required: (_) => '',
//     ValidationMessage.minLength: (_) => '',
//     ValidationMessage.mustMatch: (_) => '',
//     'digit': (_) => '',
//     'specialCharacter': (_) => '',
//     'capitalLetter': (_) => '',
//     'lowercaseLetter': (_) => '',
//     'space': (_) => '',
//   };

//   late bool isValid = true;

//   Map<String, dynamic>? _requiredPattern(
//       AbstractControl<dynamic> control, String pattern, String errorKey) {
//     final bool hasMatch = RegExp(pattern).hasMatch(control.value);
//     return hasMatch ? null : <String, dynamic>{errorKey: true};
//   }

//   //initState
//   @override
//   void initState() {
//     super.initState();
//     _addValidators();

//     passwordErrors = [
//       PasswordError(
//         message: '8 caracteres',
//         validator: () => widget.formControl.value.length >= 8,
//       ),
//       PasswordError(
//         message: '1 número',
//         validator: () =>
//             _requiredPattern(widget.formControl, _digitRegExp, 'digit') == null,
//       ),
//       PasswordError(
//         message: '1 letra mayúscula',
//         validator: () =>
//             _requiredPattern(
//                 widget.formControl, _capitalLetterRegExp, 'capitalLetter') ==
//             null,
//       ),
//       PasswordError(
//         message: '1 letra minúscula',
//         validator: () =>
//             _requiredPattern(widget.formControl, _lowercaseLetterRegExp,
//                 'lowercaseLetter') ==
//             null,
//       ),
//       PasswordError(
//         message: '1 símbolo',
//         validator: () =>
//             _requiredPattern(widget.formControl, _specialCharacterRegExp,
//                 'specialCharacter') ==
//             null,
//       ),
//     ];
//   }

//   void _addValidators() {
//     List<Validator> validators = [
//       Validators.required,
//       Validators.minLength(8),
//       Validators.delegate(
//           (control) => _requiredPattern(control, _digitRegExp, 'digit')),
//       Validators.delegate((control) => _requiredPattern(
//           control, _specialCharacterRegExp, 'specialCharacter')),
//       Validators.delegate((control) =>
//           _requiredPattern(control, _capitalLetterRegExp, 'capitalLetter')),
//       Validators.delegate((control) =>
//           _requiredPattern(control, _lowercaseLetterRegExp, 'lowercaseLetter')),
//     ];
//     widget.formControl.setValidators(validators);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         StoyCoTextFormField(
//             formControlName: widget.formControlName,
//             labelText: widget.labelText,
//             hintText: widget.hintText,
//             validationMessages: _validationMessages,
//             obscureText: false,
//             inputFormatters: <TextInputFormatter>[
//               FilteringTextInputFormatter.deny(
//                 RegExp(_spaceRegExp),
//               )
//             ],
//             keyboardType: TextInputType.visiblePassword,
//             onChanged: (value) {
//               setState(() {
//                 value.invalid
//                     ? isValid = false
//                     : isValid = passwordErrors
//                         .every((e) => e.validator?.call() ?? false);
//               });
//             },
//             decoration: InputDecoration(
//               hintText: widget.hintText,
//               errorStyle: const TextStyle(height: 0),
//               label: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                 decoration: ShapeDecoration(
//                   gradient: const LinearGradient(
//                     begin: Alignment(1.00, 0.00),
//                     end: Alignment(-1, 0),
//                     colors: [Color(0xFF030A1A), Color(0xFF0C1B24)],
//                   ),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: Text(
//                   widget.labelText,
//                   style: const TextStyle(
//                     color: Color(0xFF92929D),
//                     fontSize: 12,
//                     fontFamily: 'Akkurat Pro',
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//             )),
//         Gap(30),
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 9.5),
//           child: Column(
//             children: passwordErrors.map((e) {
//               return VerificationWidgetWithMessage(
//                 isValid: e.validator?.call() ?? false,
//                 message: e.message,
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class VerificationWidgetWithMessage extends StatelessWidget {
//   final bool isValid;
//   final String message;
//   const VerificationWidgetWithMessage({
//     Key? key,
//     this.isValid = false,
//     required this.message,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8.0),
//       child: Row(
//         children: [
//           SvgPicture.asset(
//             isValid
//                 ? 'assets/icons/check_icon.svg'
//                 : 'assets/icons/close_icon.svg',
//             width: 12,
//             height: 12,
//           ),
//           const SizedBox(width: 8.0),
//           Text(
//             message,
//             style: const TextStyle(
//               color: Color(0xFFF2F2FA),
//               fontSize: 10,
//               fontFamily: 'Akkurat Pro',
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
