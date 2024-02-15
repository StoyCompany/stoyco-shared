import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// A widget that displays a profile edit button with a user photo.
///
/// The [StoycoProfileEditWidget] is a customizable widget that displays a circular container
/// with a user photo or an icon. It also includes an edit button at the bottom right corner.
/// The user can tap on the edit button to trigger the [onTapEdit] callback.
///
/// Example usage:
///
/// ```dart
/// StoycoProfileEditWidget(
///   width: 200,
///   height: 200,
///   borderWidth: 5,
///   editIconWidth: 30,
///   editIconHeight: 30,
///   editIconContainerWidth: 56,
///   editIconContainerHeight: 56,
///   backgroundColor: Colors.blue,
///   userPhoto: 'https://example.com/user.jpg',
///   onTapEdit: () {
///     // Handle edit button tap
///   },
/// )
/// ```
class StoycoProfileEditWidget extends StatelessWidget {
  /// Creates a [StoycoProfileEditWidget].
  ///
  /// The [width] and [height] parameters define the size of the circular container.
  /// The [borderWidth] parameter specifies the width of the container's border.
  /// The [editIconWidth] and [editIconHeight] parameters define the size of the edit icon.
  /// The [editIconContainerWidth] and [editIconContainerHeight] parameters define the size of the edit button container.
  /// The [backgroundColor] parameter sets the background color of the container.
  /// The [userPhoto] parameter specifies the URL of the user's photo.
  /// The [onTapEdit] parameter is a callback function that is triggered when the edit button is tapped.
  const StoycoProfileEditWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.borderWidth,
    required this.editIconWidth,
    required this.editIconHeight,
    required this.editIconContainerWidth,
    required this.editIconContainerHeight,
    required this.backgroundColor,
    required this.userPhoto,
    this.onTapEdit,
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

  @override
  Widget build(BuildContext context) => Stack(
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
            child: GestureDetector(
              onTap: onTapEdit,
              child: Container(
                width: editIconContainerWidth,
                height: editIconContainerHeight,
                padding: const EdgeInsets.all(8),
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
                  'packages/stoyco_shared/lib/assets/icons/edit_icon.svg',
                  width: editIconWidth,
                  height: editIconHeight,
                ),
              ),
            ),
          ),
        ],
      );
}
