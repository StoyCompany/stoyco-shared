/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsHomeGen {
  const $AssetsHomeGen();

  /// File path: assets/home/horizontal_dots.svg
  SvgGenImage get horizontalDots =>
      const SvgGenImage('assets/home/horizontal_dots.svg');

  /// File path: assets/home/off_notification.svg
  SvgGenImage get offNotification =>
      const SvgGenImage('assets/home/off_notification.svg');

  /// File path: assets/home/trash.svg
  SvgGenImage get trash => const SvgGenImage('assets/home/trash.svg');

  /// List of all assets
  List<SvgGenImage> get values => [horizontalDots, offNotification, trash];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/arrow-down-icon.svg
  SvgGenImage get arrowDownIcon =>
      const SvgGenImage('assets/icons/arrow-down-icon.svg');

  /// File path: assets/icons/arrow_back.svg
  SvgGenImage get arrowBack => const SvgGenImage('assets/icons/arrow_back.svg');

  /// File path: assets/icons/calendar.svg
  SvgGenImage get calendar => const SvgGenImage('assets/icons/calendar.svg');

  /// File path: assets/icons/check_icon.svg
  SvgGenImage get checkIcon => const SvgGenImage('assets/icons/check_icon.svg');

  /// File path: assets/icons/close_icon.svg
  SvgGenImage get closeIcon => const SvgGenImage('assets/icons/close_icon.svg');

  /// File path: assets/icons/done_white_18dp.svg
  SvgGenImage get doneWhite18dp =>
      const SvgGenImage('assets/icons/done_white_18dp.svg');

  /// File path: assets/icons/down_arrow_icon.svg
  SvgGenImage get downArrowIcon =>
      const SvgGenImage('assets/icons/down_arrow_icon.svg');

  /// File path: assets/icons/keyboard_arrow_down_white_18dp.svg
  SvgGenImage get keyboardArrowDownWhite18dp =>
      const SvgGenImage('assets/icons/keyboard_arrow_down_white_18dp.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        arrowDownIcon,
        arrowBack,
        calendar,
        checkIcon,
        closeIcon,
        doneWhite18dp,
        downArrowIcon,
        keyboardArrowDownWhite18dp
      ];
}

class AssetsShared {
  AssetsShared._();

  static const $AssetsHomeGen home = $AssetsHomeGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
