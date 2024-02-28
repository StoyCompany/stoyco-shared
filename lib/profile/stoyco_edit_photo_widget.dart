import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';

class StoycoEditPhotoWidget extends StatelessWidget {
  const StoycoEditPhotoWidget({
    super.key,
    required this.width,
    required this.height,
    required this.borderWidth,
    required this.editIconWidth,
    required this.editIconHeight,
    required this.principalText,
    required this.secondaryText,
    required this.editIconContainerWidth,
    required this.editIconContainerHeight,
    required this.backgroundColor,
    required this.userPhoto,
    this.spacing,
    this.direction,
    this.onTapEdit,
    this.principalTextSize,
    this.secondaryTextSize,
  });

  /// The width of the circular container.
  final double width;

  /// The height of the circular container.
  final double height;

  /// The width of the container's border.
  final double borderWidth;

  /// The width of the edit icon.
  final double editIconWidth;

  /// The height of the edit icon.
  final double editIconHeight;

  /// The width of the edit button container.
  final double editIconContainerWidth;

  /// The height of the edit button container.
  final double editIconContainerHeight;

  /// The background color of the container.
  final Color backgroundColor;

  /// The URL of the user's photo.
  final String userPhoto;

  /// A callback function that is triggered when the edit button is tapped.
  final Function()? onTapEdit;

  /// The text that is displayed at the top of the circular container.
  final String principalText;

  /// The text that is displayed at the bottom of the circular container.
  final String secondaryText;

  /// The size of the principal text.
  final double? principalTextSize;

  /// The size of the secondary text.
  final double? secondaryTextSize;

  /// The Spacing between the image and the text.
  final double? spacing;

  /// The direction to show the the image and the text. For example, if the direction is horizontal, the image will be shown to the left and the text to the right. If the direction is vertical, the image will be shown at the top and the text at the bottom.
  final Axis? direction;

  @override
  Widget build(BuildContext context) => Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: direction ?? Axis.horizontal,
        spacing: spacing ?? 30,
        runSpacing: spacing ?? 30,
        children: [
          Stack(
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x60191919),
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFF4639E7).withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: width - borderWidth,
                    height: height - borderWidth,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: backgroundColor,
                      image: userPhoto.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(userPhoto),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: !userPhoto.isNotEmpty
                        ? const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onTapEdit,
                    child: Container(
                      width: editIconContainerWidth,
                      height: editIconContainerHeight,
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Color(0xFF1C197F), Color(0xFF4639E7)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(56),
                        ),
                      ),
                      child: SvgPicture.asset(
                        'packages/stoyco_shared/lib/assets/icons/camera.svg',
                        width: editIconWidth,
                        height: editIconHeight,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: direction == Axis.horizontal
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                principalText,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFFF2F2FA),
                  fontSize: principalTextSize ?? 32,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Akkurat_Pro',
                ),
                textAlign: direction == Axis.horizontal
                    ? TextAlign.left
                    : TextAlign.center,
              ),
              const Gap(10),
              Text(
                secondaryText,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF92929D),
                  fontSize: secondaryTextSize ?? 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Akkurat_Pro',
                ),
              ),
            ],
          ),
        ],
      );
}
