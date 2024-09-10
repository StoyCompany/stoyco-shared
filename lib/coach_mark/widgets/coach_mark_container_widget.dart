import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

/// A customizable widget for displaying coach marks (or tooltips) in your Flutter application.
///
/// This widget uses a [GlassmorphicContainer] to create a visually appealing and blurred background.
/// It displays a title, description, and provides optional skip and finish buttons.
///
/// **Key features:**
///
/// * Customizable appearance: Adjust blur, width, height, border, border radius, and more.
/// * Optional skip and finish buttons: Control the visibility and actions of these buttons.
/// * Responsive layout: Adapts to different screen sizes using [StoycoScreenSize].
///
/// **Example usage:**
///
/// ```dart
/// CoachMarkContainerWidget(
///   title: 'Welcome!',
///   description: 'This is a quick tour of our app.',
///   onSkip: () => print('User skipped the coach mark'),
///   onFinish: () => print('User finished the coach mark'),
/// )
/// ```
class CoachMarkContainerWidget extends StatelessWidget {
  /// Creates a [CoachMarkContainerWidget].
  ///
  /// * [title]: The main title of the coach mark.
  /// * [description]: A brief description or instructions.
  /// * [onSkip]: Callback function when the skip button is pressed (optional).
  /// * [onFinish]: Callback function when the finish button is pressed (optional).
  /// * [blur]: The blur intensity of the glassmorphic background (default: 15).
  /// * [width]: The width of the container (default: adapts to screen size).
  /// * [height]: The height of the container (default: adapts to screen size).
  /// * [border]: The border thickness of the container (default: 2).
  /// * [borderRadius]: The border radius of the container (default: 16).
  /// * [showSkip]: Whether to show the skip button (default: true).
  /// * [showCheck]: Whether to show a check icon instead of the finish button (default: false).
  /// * [key]: An optional key to identify this widget.
  const CoachMarkContainerWidget({
    super.key,
    required this.title,
    required this.description,
    this.blur,
    this.width,
    this.height,
    this.border,
    this.onSkip,
    this.onFinish,
    this.borderRadius,
    this.showSkip = true,
    this.showCheck = false,
  });

  final String title;
  final bool showSkip;
  final double? blur;
  final double? width;
  final double? height;
  final double? border;
  final String description;
  final double? borderRadius;
  final void Function()? onSkip;
  final void Function()? onFinish;
  final bool showCheck;

  /// Creates a copy of this widget with the specified properties overridden.
  CoachMarkContainerWidget copyWith({
    String? title,
    String? description,
    void Function()? onSkip,
    void Function()? onFinish,
    double? blur,
    double? width,
    double? height,
    double? border,
    double? borderRadius,
    bool? showSkip,
    bool? showCheck,
  }) =>
      CoachMarkContainerWidget(
        key: key,
        title: title ?? this.title,
        description: description ?? this.description,
        onSkip: onSkip ?? this.onSkip,
        onFinish: onFinish ?? this.onFinish,
        blur: blur ?? this.blur,
        width: width ?? this.width,
        height: height ?? this.height,
        border: border ?? this.border,
        borderRadius: borderRadius ?? this.borderRadius,
        showSkip: showSkip ?? this.showSkip,
        showCheck: showCheck ?? this.showCheck,
      );

  @override
  Widget build(BuildContext context) => Container(
        // blur: blur ?? 15,
        // borderRadius: borderRadius ?? 16,
        // border: border ?? 2,

        decoration: BoxDecoration(
          border: const GradientBoxBorder(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x00FFFFFF),
                Color(0xFF4639E7),
              ],
              stops: [
                0,
                1,
              ],
            ),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF030A1A).withOpacity(0.7),
              const Color(0xFF0C1B24).withOpacity(0.3),
            ],
            stops: const [
              0.1,
              1,
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showSkip)
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: onSkip,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            const Gap(2),
            Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const Gap(4),
            Text(
              description,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.2,
              ),
            ),
            const Gap(2),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onFinish,
                child: !showCheck
                    ? const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 4,
                        ),
                        child: SvgPicture.asset(
                          'packages/stoyco_shared/lib/assets/icons/check_icon_coach_mark.svg',
                          height: 17,
                          width: 15,
                        ),
                      ),
              ),
            ),
          ],
        ),
      );
}
