import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/utils/text_button.dart';

/// Shows a modal dialog with the specified [child] widget.
///
/// The [context] parameter is the build context.
/// The [barrierDismissible] parameter determines whether the modal can be dismissed by tapping outside of it.
///
/// Returns a [Future] that resolves to the value returned by the modal.
/// The type of the value is specified by the generic type parameter [T].
///
/// Example usage:
/// ```dart
/// Future<String?> result = showStoycoModal<String>(
///   context: context,
///   child: MyModalContent(),
///   barrierDismissible: false,
/// );
/// ```
Future<T?> showStoycoModal<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
  required String title,
  void Function()? onTapAccept,
  void Function()? onTapCancel,
  bool? showActions,
  double? height,
  bool? showDivider,
  BoxDecoration? decoration,
  TextStyle? titleTextStyle,
  bool? useRootNavigator,
}) =>
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      useRootNavigator: useRootNavigator ?? false,
      builder: (BuildContext context) => StoycoContainerModal(
        title: title,
        onTapAccept: onTapAccept,
        onTapCancel: onTapCancel,
        showActions: showActions ?? false,
        height: height ?? 400,
        showDivider: showDivider ?? true,
        decoration: decoration,
        titleTextStyle: titleTextStyle,
        child: child,
      ),
    );

/// A container modal widget that provides a customizable container with a child widget.
///
/// This widget is used to display a container with a child widget inside a modal.
/// It allows customization of the container's height, padding, and decoration.
///
/// Example usage:
///
/// ```dart
/// StoycoContainerModal(
///   child: Text('Hello World'),
///   height: 300,
///   padding: EdgeInsets.all(16),
///   decoration: BoxDecoration(
///     color: Colors.blue,
///     borderRadius: BorderRadius.circular(8),
///   ),
/// )
/// ```

/// A modal container widget used in the Stoyco application.
///
/// This widget displays a container with a title, child widget, and optional actions.
/// The container has a specified height, padding, and decoration.
/// By default, the container has a rounded border and a specific color.
/// The title is displayed at the top of the container.
/// The child widget is displayed below the title.
/// If [showActions] is true, additional actions are displayed at the bottom of the container.
/// The actions include a cancel button and an accept button.
/// The cancel button triggers [onTapCancel] when pressed.
/// The accept button triggers [onTapAccept] when pressed.
/// The [showDivider] property determines whether to show a divider between the title and the child widget.
class StoycoContainerModal extends StatelessWidget {
  /// Constructs a [StoycoContainerModal] widget.
  ///
  /// The [child] parameter is required and represents the child widget to be displayed inside the container.
  /// The [height] parameter specifies the height of the container. The default value is 400.
  /// The [padding] parameter specifies the padding around the container. The default value is `EdgeInsets.symmetric(vertical: 12)`.
  /// The [decoration] parameter specifies the decoration of the container. The default value is a BoxDecoration with a rounded border and a specific color.
  /// The [title] parameter specifies the title of the container.
  /// The [onTapAccept] parameter specifies the callback function when the accept button is pressed.
  /// The [onTapCancel] parameter specifies the callback function when the cancel button is pressed.
  /// The [showActions] parameter determines whether to show the actions at the bottom of the container. The default value is false.
  /// The [showDivider] parameter determines whether to show a divider between the title and the child widget. The default value is true.
  const StoycoContainerModal({
    super.key,
    required this.child,
    this.height = 400,
    this.padding = const EdgeInsets.symmetric(
      vertical: 12,
    ),
    this.decoration,
    required this.title,
    this.onTapAccept,
    this.onTapCancel,
    this.showActions = false,
    this.showDivider = true,
    this.titleTextStyle,
  });

  final Widget child;
  final double height;
  final EdgeInsets padding;
  final BoxDecoration? decoration;
  final String title;
  final void Function()? onTapAccept;
  final void Function()? onTapCancel;
  final bool showActions;
  final bool showDivider;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: double.infinity,
        padding: padding,
        decoration: decoration ??
            const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              color: Color(0xff253341),
            ),
        child: Column(
          children: [
            Container(
              height: 2,
              width: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xff92929d),
              ),
            ),
            const Gap(36),
            Text(
              title,
              style: titleTextStyle ??
                  const TextStyle(
                    fontFamily: 'Akkurat Pro',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xfff2f2fa),
                    decoration: TextDecoration.none,
                  ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            if (showDivider)
              const Divider(
                color: Color(0xff92929d),
                thickness: 1,
                indent: 32,
                endIndent: 32,
              ),
            child,
            if (showActions)
              Column(
                children: [
                  const Divider(
                    color: Color(0xff92929d),
                    thickness: 1,
                    indent: 32,
                    endIndent: 32,
                  ),
                  const Gap(16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: onTapCancel ?? () {},
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                fontFamily: 'Akkurat Pro',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffde2424),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: TextButtonStoyco(
                            text: 'Aceptar',
                            height: 40,
                            onTap: onTapAccept ?? () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Container(),
          ],
        ),
      );
}
