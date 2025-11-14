import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'package:stoyco_shared/design/screen_size.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    this.icon,
    this.svgAsset,
    required this.count,
    required this.color,
    required this.onPressed,
    required this.isProcessing,
    required this.iconSize,
    required this.counterFontSize,
    this.animation,
    this.isReadOnly = false,
  }): assert(icon != null || svgAsset != null, 'Either icon or svgAsset must be provided');
  final IconData? icon;
  final String? svgAsset;
  final int count;
  final Color color;
  final VoidCallback onPressed;
  final bool isProcessing;
  final Animation<double>? animation;
  final double iconSize;
  final double counterFontSize;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;

    if (svgAsset != null) {
      iconWidget = SvgPicture.asset(
        svgAsset!,
        width: StoycoScreenSize.width(context, iconSize),
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else {
      iconWidget = Icon(
        icon!,
        size: StoycoScreenSize.width(context, iconSize),
        color: color,
      );
    }

    if (animation != null) {
      iconWidget = AnimatedBuilder(
        animation: animation!,
        builder: (_, child) => Transform.scale(
          scale: animation!.value,
          child: child,
        ),
        child: iconWidget,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isReadOnly ? null : (isProcessing ? null : onPressed),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              Gap(StoycoScreenSize.width(context, 8)),
              Text(
                _formatCount(count),
                style: TextStyle(
                  color: color,
                  fontSize: StoycoScreenSize.fontSize(
                    context,
                    counterFontSize,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
