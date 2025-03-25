import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';

class CoverImageWithFade extends StatelessWidget {
  const CoverImageWithFade({
    super.key,
    required this.imageUrl,
    this.child,
  });

  final String imageUrl;
  final Positioned? child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final double width = !StoycoScreenSize.isPhone(context)
              ? constraints.maxWidth
              : constraints.maxWidth * 0.8;
          final double height = width * 0.88571;
          return SizedBox(
            width: width,
            height: height,
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
                    width: width,
                    height: height - 2,
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
                    height: height,
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
