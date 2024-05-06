import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stoyco_shared/utils/widget_button.dart';

/// A StatelessWidget for rendering a button designed to trigger purchasing actions for an event.
///
/// The button is styled and displays loading state, and uses the `WidgetButton` for consistent button behavior across the app.
class BuyEventButton extends StatelessWidget {
  /// Creates a [BuyEventButton] widget.
  ///
  /// Requires [buttonInfo] to configure the button text and actions, and [isLoading] to determine if the button should display a loading indicator.
  const BuyEventButton({
    super.key,
    required this.buttonInfo,
    required this.isLoading,
  });

  /// Configuration and data for the button, such as text and tap callback.
  final InfoToBuyEventButton buttonInfo;

  /// Indicates whether the button is in a loading state.
  final bool isLoading;

  /// Builds the widget using a `WidgetButton` to handle tap actions and display either text and icon or a loading indicator.
  @override
  Widget build(BuildContext context) => WidgetButton(
        onTap: buttonInfo.onTap,
        width: MediaQuery.of(context).size.width * 0.9,
        isLoading: isLoading,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/home/ticketIco.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 10),
            Text(
              buttonInfo.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}

/// A class holding the necessary data to configure a [BuyEventButton].
///
/// Includes the button's text, tap callback, and enabled state.
class InfoToBuyEventButton {
  /// Constructs an instance of [InfoToBuyEventButton].
  ///
  /// Requires [text] for the button's display text, [onTap] as the tap callback, and [enabled] to determine if the button is interactive.
  InfoToBuyEventButton({
    required this.text,
    required this.onTap,
    required this.enabled,
  });

  /// The text to display on the button.
  final String text;

  /// The callback to execute when the button is tapped. It is nullable, meaning the button can be disabled.
  final Function()? onTap;

  /// Indicates whether the button is enabled or disabled.
  final bool enabled;
}
