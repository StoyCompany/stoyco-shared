import 'package:flutter/material.dart';
import 'package:stoyco_shared/utils/border_gradient_stoyco.dart';
import 'package:stoyco_shared/design/colors.dart';

/// A custom outlined button widget with a gradient background and border.
///
/// This button is designed with a rounded border and a gradient background.
/// It can be used to create visually appealing buttons in your app.
///
/// The button supports an `onTap` callback function that will be called when the button is tapped.
/// It also allows you to customize the button's text, width, height, and text style.
///
/// Example usage:
/// ```dart
/// StoycoOutlinedButton(
///   onTap: () {
///     // Handle button tap
///   },
///   text: 'Click me',
///   width: 120,
///   height: 50,
///   style: TextStyle(
///     fontSize: 18,
///     fontWeight: FontWeight.bold,
///   ),
/// )
/// ```
/// This example creates a button with the text 'Click me', a width of 120, a height of 50, and a custom text style.
/// When the button is tapped, the `onTap` function will be called.
///
/// Parameters:
/// - [text]: The text to display on the button.
/// - [width]: The width of the button. Defaults to 115.
/// - [height]: The height of the button. Defaults to 56.
/// - [style]: The text style to apply to the button text.
/// - [onTap]: The function to call when the button is tapped.
///
/// Returns:
/// A custom outlined button widget with a gradient background and border.
///
/// See also:
/// - [BorderGradientStoyco], a custom widget that creates a gradient border around its child.
/// - [StoycoColors], a class that defines the color palette used in the Stoyco app.
///
/// Author: Stoyco team
class StoycoOutlinedButton extends StatelessWidget {
  const StoycoOutlinedButton({
    super.key,
    this.onTap,
    this.height = 56,
    required this.text,
    this.width = 115,
    this.style,
  });

  final String text;
  final double width;
  final double height;
  final TextStyle? style;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(60, 35, 35, 54),
                Color.fromARGB(60, 35, 35, 54),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2B3445).withOpacity(0.5),
                offset: const Offset(0, -20),
                blurRadius: 30,
              ),
              const BoxShadow(
                color: Color(0xFF10141C),
                offset: Offset(0, 20),
                blurRadius: 30,
              ),
            ],
          ),
          child: BorderGradientStoyco(
            strokeWidth: 1,
            radius: 12,
            gradient: LinearGradient(
              colors: [
                const Color(0xFF211d8b),
                StoycoColors.blue,
              ],
              stops: const [
                0.0751,
                0.5643,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
}
