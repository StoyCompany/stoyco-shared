import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';

/// {@template video_exclusive_blur}
/// A [VideoExclusiveBlur] molecule for the Atomic Design System.
///
/// ### Overview
/// Provides a blur and overlay effect with a lock/tag indicator for exclusive video content. This widget is typically used to visually indicate locked or premium areas, overlaying a blur and a customizable tag (with icon and message) above its child.
///
/// ### Atomic Level
/// **Molecule** – Composes multiple atoms (blur, overlay, tag) into a reusable UI pattern.
///
/// ### Parameters
/// - `isLocked`: Whether the blur and lock overlay are shown. Defaults to true.
/// - `onTapElementExclusive`: Callback when the locked overlay is tapped.
/// - `child`: The widget displayed beneath the blur and overlay.
/// - `width`, `height`: Optional dimensions for the blur area and child.
/// - `blurSigmaX`, `blurSigmaY`: Blur intensity for X and Y axes.
/// - `overlayColor`, `overlayOpacity`: Color and opacity for the overlay above the blur.
/// - `radius`, `borderRadius`: Border radius for the blur and overlay.
/// - `alignment`: Alignment for the tag/lock indicator.
/// - `message`, `messageStyle`: Text and style for the tag message.
/// - `padding`, `margin`: Spacing for the tag container.
/// - `widthTag`, `heightTag`: Size of the tag container.
/// - `backgroundColor`: Background color for the tag container.
/// - `tagLockIcon`, `tagLockIconWidth`, `tagLockIconHeight`: Custom icon and size for the tag.
///
/// ### Returns
/// Renders a [Stack] with the child, optional blur/overlay, and a tag/lock indicator. If `isLocked` is false, only the child is shown.
///
/// ### Example
/// ```dart
/// VideoExclusiveBlur(
///   isLocked: true,
///   child: Image.network('https://...'),
///   onTapElementExclusive: () => print('Locked tapped'),
/// )
/// ```
/// {@endtemplate}
class VideoExclusiveBlur extends StatelessWidget {
  /// {@macro video_exclusive_blur}
  const VideoExclusiveBlur({
    super.key,
    this.isLocked = true,
    this.onTapElementExclusive,
    required this.child,
    this.blurSigmaX = 5,
    this.blurSigmaY = 5,
    this.overlayColor = Colors.transparent,
    this.overlayOpacity = 0.3,
    this.radius = 16,
    this.borderRadius,
    this.alignment = Alignment.topCenter,
    this.width,
    this.height,
    this.message = 'Contenido exclusivo',
    this.messageStyle,
    this.padding,
    this.margin,
    this.widthTag,
    this.heightTag,
    this.backgroundColor,
    this.tagLockIcon,
    this.tagLockIconWidth,
    this.tagLockIconHeight,
  });

  /// Whether the blur effect with lock icon should be applied. Defaults to true.
  final bool isLocked;

  /// Callback when the locked overlay is tapped.
  final VoidCallback? onTapElementExclusive;

  /// The widget displayed beneath the blur and overlay.
  final Widget child;

  /// Optional width for the blur area and child.
  final double? width;

  /// Optional height for the blur area and child.
  final double? height;

  /// The sigmaX value for the blur effect. Controls horizontal blur intensity. Defaults to 5.
  final double blurSigmaX;

  /// The sigmaY value for the blur effect. Controls vertical blur intensity. Defaults to 5.
  final double blurSigmaY;

  /// The color overlay to apply above the blur. Useful for tinting. Defaults to transparent.
  final Color overlayColor;

  /// The opacity of the color overlay. Range 0.0–1.0. Defaults to 0.3.
  final double overlayOpacity;

  /// The border radius to apply to the image and blur overlay. Defaults to 16.
  final double radius;

  /// The border radius to apply to the image and blur overlay. Overrides [radius] if provided.
  final BorderRadiusGeometry? borderRadius;

  /// The alignment of the tag/lock indicator within the blurred area. Defaults to [Alignment.topCenter].
  final AlignmentGeometry alignment;

  /// The message displayed inside the tag/lock indicator. Defaults to 'Contenido exclusivo'.
  final String message;

  /// The text style for the tag message.
  final TextStyle? messageStyle;

  /// Padding inside the tag container.
  final EdgeInsetsGeometry? padding;

  /// Margin around the tag container.
  final EdgeInsetsGeometry? margin;

  /// Width of the tag container.
  final double? widthTag;

  /// Height of the tag container.
  final double? heightTag;

  /// Background color for the tag container.
  final Color? backgroundColor;

  /// Custom icon widget for the tag/lock indicator.
  final Widget? tagLockIcon;

  /// Width of the tag/lock icon.
  final double? tagLockIconWidth;

  /// Height of the tag/lock icon.
  final double? tagLockIconHeight;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: isLocked ? onTapElementExclusive : null,
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              child,
              if (isLocked) ...<Widget>[
                ClipRRect(
                  borderRadius: borderRadius ??
                      BorderRadius.circular(
                        StoycoScreenSize.radius(context, radius),
                      ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurSigmaX,
                      sigmaY: blurSigmaY,
                    ),
                    child: Container(
                      color: overlayColor.withValues(alpha: overlayOpacity),
                    ),
                  ),
                ),
                Align(
                  alignment: alignment,
                  child: Container(
                    width: widthTag ?? StoycoScreenSize.width(context, 166),
                    height: heightTag ?? StoycoScreenSize.height(context, 35),
                    padding: padding ??
                        StoycoScreenSize.symmetric(
                          context,
                          horizontal: 15,
                          vertical: 5,
                        ),
                    margin: margin ??
                        StoycoScreenSize.fromLTRB(
                          context,
                          top: 20,
                        ),
                    decoration: BoxDecoration(
                      color: backgroundColor ?? StoycoColors.darkBackground,
                      borderRadius: BorderRadius.circular(
                        StoycoScreenSize.radius(context, radius),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          padding: StoycoScreenSize.all(context, 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: StoycoColors.white2,
                          ),
                          child: tagLockIcon ?? Icon(
                            Icons.star,
                            color: StoycoColors.deepCharcoal,
                            size: StoycoScreenSize.fontSize(context, 12),
                          ),
                        ),
                        Gap(StoycoScreenSize.width(context, 8)),
                        Text(
                          message,
                          style: messageStyle ??
                            TextStyle(
                              fontSize: StoycoScreenSize.fontSize(context, 12),
                              fontWeight: FontWeight.w400,
                              color: StoycoColors.white2,
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
}
