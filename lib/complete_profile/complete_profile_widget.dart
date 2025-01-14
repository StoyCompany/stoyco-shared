import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/design/screen_size.dart';

/// A widget that displays a profile completion call-to-action container.
///
/// This widget creates a customizable profile completion prompt with an icon
/// and text. It's commonly used to encourage users to complete their profile
/// information.
///
/// Example:
/// ```dart
/// CompleteProfileWidget(
///   text: 'Complete your profile',
///   icon: Icons.person,
///   onPressed: () {
///     // Handle tap
///   },
/// )
/// ```
class CompleteProfileWidget extends StatelessWidget {
  /// Creates a complete profile widget.
  ///
  /// * [onPressed] - Callback function triggered when the widget is tapped.
  /// * [margin] - Optional external padding around the container.
  /// * [padding] - Optional internal padding for the content.
  /// * [icon] - The icon to display, defaults to [Icons.person_outline].
  /// * [text] - The message to display, defaults to a profile completion prompt.
  const CompleteProfileWidget({
    super.key,
    this.onPressed,
    this.margin,
    this.padding,
    this.icon = Icons.person_outline,
    this.text =
        'Completa tu perfil en StoyCo para disfrutar de una experiencia personalizada al máximo',
  });

  /// Callback function executed when the widget is tapped.
  final void Function()? onPressed;

  /// The external padding around the container.
  final EdgeInsetsGeometry? margin;

  /// The internal padding for the content.
  final EdgeInsetsGeometry? padding;

  /// The icon to display in the widget.
  final IconData icon;

  /// The text message to display next to the icon.
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        margin: margin ??
            StoycoScreenSize.symmetric(
              context,
              horizontal: 16,
            ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: .95),
        ),
        child: GestureDetector(
          onTap: () {
            Feedback.forTap(context);
            onPressed?.call();
          },
          child: Padding(
            padding: padding ??
                StoycoScreenSize.symmetric(
                  context,
                  vertical: 15,
                  horizontal: 21,
                ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    icon,
                    color: Colors.black,
                    size: StoycoScreenSize.fontSize(context, 24),
                  ),
                  onPressed: onPressed,
                ),
                Gap(StoycoScreenSize.width(context, 8)),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: StoycoScreenSize.fontSize(context, 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
