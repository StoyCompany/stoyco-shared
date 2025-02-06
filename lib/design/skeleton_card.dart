import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: width,
        margin: margin,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(25),
          child: Stack(
            children: [
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 11, 18, 44),
                highlightColor: const Color.fromARGB(255, 20, 35, 88),
                child: Container(
                  height: height,
                ),
              ),
            ],
          ),
        ),
      );
}
