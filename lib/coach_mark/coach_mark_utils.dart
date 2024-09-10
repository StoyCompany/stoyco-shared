import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:stoyco_shared/coach_mark/widgets/coach_mark_container_widget.dart';

/// Represents the content and configuration for a single coach mark target.
///
/// This class stores information like the target's key, title, description,
/// appearance settings, and callback functions for skip and finish actions.
///
/// It provides a `buildTargetFocus` method to generate a `TargetFocus` object
/// suitable for use in a `TutorialCoachMark`.
class CoachMarkTargetContent {
  /// Creates a [CoachMarkTargetContent].
  ///
  /// * [key]: The `GlobalKey` associated with the widget to highlight.
  /// * [title]: The main title of the coach mark.
  /// * [identity]: A unique identifier for this target.
  /// * [description]: A brief description or instructions.
  /// * [blur]: The blur intensity of the glassmorphic background (optional).
  /// * [width]: The width of the coach mark container (optional).
  /// * [shape]: The shape of the highlighted area (optional).
  /// * [height]: The height of the coach mark container (optional).
  /// * [radius]: The radius of the highlighted area (optional).
  /// * [border]: The border thickness of the coach mark container (optional).
  /// * [borderRadius]: The border radius of the coach mark container (optional).
  /// * [onSkip]: Callback function when the skip button is pressed (optional).
  /// * [onFinish]: Callback function when the finish button is pressed (optional).
  /// * [customPosition]: Custom positioning for the coach mark content (optional).
  /// * [align]: The alignment of the coach mark content relative to the target (default: `ContentAlign.bottom`).
  /// * [showSkip]: Whether to show the skip button (optional, default: true).
  /// * [showCheck]: Whether to show a checkmark when the target is completed (optional, default: false).
  CoachMarkTargetContent({
    required this.key,
    required this.title,
    required this.identity,
    required this.description,
    this.blur,
    this.width,
    this.shape,
    this.height,
    this.radius,
    this.border,
    this.onSkip,
    this.onFinish,
    this.showSkip,
    this.showCheck,
    this.borderRadius,
    this.customPosition,
    this.align = ContentAlign.bottom,
  });

  final String identity;
  final GlobalKey<State<StatefulWidget>>? key;

  final String title;

  final double? blur;
  final double? width;
  final double? height;
  final double? border;
  final String description;
  final double? borderRadius;
  final void Function()? onSkip;
  final void Function()? onFinish;
  final CustomTargetContentPosition? customPosition;
  final ContentAlign align;
  final ShapeLightFocus? shape;
  final double? radius;
  final bool? showSkip;
  final bool? showCheck;

  /// Builds a `TargetFocus` object based on the properties of this instance.
  TargetFocus buildTargetFocus() => TargetFocus(
        identify: identity,
        keyTarget: key,
        enableTargetTab: false,
        contents: [
          TargetContent(
            customPosition: customPosition,
            align: align,
            builder: (context, controller) => CoachMarkContainerWidget(
              title: title,
              description: description,
              onFinish: () {
                onFinish?.call();
                controller.next();
              },
              onSkip: () {
                onSkip?.call();
                controller.skip();
              },
              blur: blur,
              width: width,
              height: height,
              border: border,
              borderRadius: borderRadius,
              showSkip: showSkip ?? true,
              showCheck: showCheck ?? false,
            ),
          ),
        ],
        shape: shape ?? ShapeLightFocus.RRect,
        radius: radius ?? 10,
      );
}

class CoachMarkUtils {
  /// Builds a `TutorialCoachMark` widget with the specified configuration.
  ///
  /// * [hideSkip]: Whether to hide the skip button (default: false).
  /// * [useSafeArea]: Whether to use safe area insets for positioning (default: true).
  /// * [onSkip]: Callback function when the skip button is pressed (optional).
  /// * [onFinish]: Callback function when the tutorial is finished (optional).
  /// * [targets]: A list of `TargetFocus` objects defining the coach mark targets.
  /// * [onClickTarget]: Callback function when a target is clicked (optional).
  /// * [onClickOverlay]: Callback function when the overlay is clicked (optional).
  static TutorialCoachMark buildTutorialCoachMark({
    bool hideSkip = false,
    bool useSafeArea = true,
    bool Function()? onSkip,
    dynamic Function()? onFinish,
    required List<TargetFocus> targets,
    FutureOr<void> Function(TargetFocus)? onClickTarget,
    FutureOr<void> Function(TargetFocus)? onClickOverlay,
  }) =>
      TutorialCoachMark(
        colorShadow: const Color(0xFF0e1925),
        paddingFocus: 0,
        opacityShadow: 0.5,
        imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        useSafeArea: useSafeArea,
        hideSkip: hideSkip,
        onSkip: onSkip,
        onFinish: onFinish,
        onClickTarget: onClickTarget,
        onClickOverlay: onClickOverlay,
        targets: targets,
        showSkipInLastTarget: false,
      );

  /// Builds a list of `TargetFocus` objects from a list of `CoachMarkTargetContent`.
  static List<TargetFocus> buildTargets(
          List<CoachMarkTargetContent> targetContents) =>
      targetContents
          .map((targetContent) => targetContent.buildTargetFocus())
          .toList();
}
