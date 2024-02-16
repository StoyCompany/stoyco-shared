import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stoyco_shared/core/gen/assets.gen.dart';

class NotificationActionWidget extends StatelessWidget {
  const NotificationActionWidget(
      {super.key,
      required this.callback,
      required this.count,
      required this.width,
      required this.height,
      required this.fontSize});

  final int count;
  final void Function() callback;

  final double width;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) => InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: callback,
        child: Badge(
          isLabelVisible: count > 0,
          backgroundColor: const Color(0xFF4639E7),
          label: Text(
            '$count',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontFamily: 'Akkurat Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
          child: SvgPicture.asset(
            AssetsShared.home.offNotification.path,
            width: width,
            height: height,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      );
}
