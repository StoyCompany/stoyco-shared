import 'package:flutter/material.dart';

/// A customizable button widget built with Flutter's [InkWell] and [Container].
///
/// This button supports customization for its dimensions, loading state, and tap interactions.
class WidgetButton extends StatelessWidget {
  /// Creates a [WidgetButton].
  ///
  /// The button can display either custom content or a loading indicator. The size, enabled state, and response to taps can be customized.
  ///
  /// Parameters:
  /// - [height]: Sets the height of the button, defaulting to 56.
  /// - [width]: Sets the width of the button, defaulting to 115.
  /// - [isLoading]: If true, shows a loading spinner instead of content.
  /// - [onTap]: Function to execute when the button is tapped. Can be null to disable taps.
  /// - [content]: Widget to display inside the button when not loading.
  const WidgetButton({
    super.key,
    this.height = 56,
    this.width = 115,
    this.enabled = true,
    this.isLoading = false,
    required this.onTap,
    required this.content,
  });

  /// The widget to display inside the button.
  final Widget content;

  /// The fixed width of the button.
  final double width;

  /// The fixed height of the button.
  final double height;

  /// The function to be called when the button is tapped.
  /// If null, the button will be disabled.
  final void Function()? onTap;

  /// Indicates whether the button is enabled.
  /// It's not used effectively in the current implementation to control the button's enabled state.
  final enabled;

  /// Shows a loading indicator if set to true, ignoring the [content].
  final bool isLoading;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(5, 43, 52, 69),
                offset: Offset(0, -20),
                blurRadius: 20,
              ),
              BoxShadow(
                color: Color.fromARGB(17, 255, 255, 255),
                offset: Offset(0, -8),
                blurRadius: 10,
              ),
            ],
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  if (!enabled) Colors.grey else const Color(0xFF211d8b),
                  if (!enabled) Colors.grey else const Color(0xFF4639E7),
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
            child: Center(
              child: !isLoading ? content : const CircularProgressIndicator(),
            ),
          ),
        ),
      );
}
