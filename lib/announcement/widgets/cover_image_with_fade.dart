import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';

/// A widget that displays a cached network image with a fade gradient effect at the bottom.
///
/// This widget is commonly used for cover images in announcements, cards or profile headers
/// where text needs to be overlaid on top of the image. The fade gradient ensures
/// text remains readable regardless of the image content.
///
/// Example usage:
///
/// ```dart
/// CoverImageWithFade(
///   imageUrl: 'https://example.com/image.jpg',
///   width: 300,
///   height: 200,
///   child: Positioned(
///     bottom: 16,
///     left: 16,
///     child: Text('Cover title', style: TextStyle(color: Colors.white)),
///   ),
/// )
/// ```
///
/// The widget automatically calculates width and height based on the parent
/// constraints if not explicitly provided, with different behavior on mobile vs larger screens.
class CoverImageWithFade extends StatelessWidget {
  /// Creates a cover image with a fade gradient effect.
  ///
  /// The [imageUrl] parameter is required and must not be null.
  ///
  /// If [width] and [height] are not provided, they will be calculated based on the
  /// parent constraints, with mobile screens using 80% of the available width.
  ///
  /// The [child] parameter can be used to overlay content on top of the image.
  const CoverImageWithFade({
    super.key,
    required this.imageUrl,
    this.child,
    this.width,
    this.height,
  });

  /// The URL of the image to be displayed.
  final String imageUrl;

  /// Optional widget to be positioned on top of the image.
  /// Must be a [Positioned] widget to specify exact positioning within the stack.
  final Positioned? child;

  /// Optional explicit width of the image container.
  /// If null, width will be calculated based on available constraints.
  final double? width;

  /// Optional explicit height of the image container.
  /// If null, height will be calculated based on the width using a 0.88571 aspect ratio.
  final double? height;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final double calculatedWidth = width ??
              (!StoycoScreenSize.isPhone(context)
                  ? constraints.maxWidth
                  : constraints.maxWidth * 0.8);
          final double calculatedHeight = height ?? (calculatedWidth * 0.88571);

          return SizedBox(
            width: calculatedWidth,
            height: calculatedHeight,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    StoycoScreenSize.radius(
                      context,
                      20,
                      phone: 16,
                      tablet: 18,
                      desktopLarge: 24,
                    ),
                  ),
                  child: SizedBox(
                    width: calculatedWidth,
                    height: calculatedHeight - 2,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
                if (child != null) child!,
                Positioned.fill(
                  child: Container(
                    height: calculatedHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.3, 0.7, 1.0],
                        colors: [
                          Colors.transparent,
                          StoycoColors.deepCharcoal.withOpacity(0.2),
                          StoycoColors.deepCharcoal.withOpacity(0.6),
                          StoycoColors.deepCharcoal,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
}
