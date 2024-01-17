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
}) =>
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) => StoycoContainerModal(
        title: title,
        onTapAccept: onTapAccept,
        onTapCancel: onTapCancel,
        showActions: showActions ?? false,
        height: height ?? 400,
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

class StoycoContainerModal extends StatelessWidget {
  /// Constructs a [StoycoContainerModal] widget.
  ///
  /// The [child] parameter is required and represents the child widget to be displayed inside the container.
  /// The [height] parameter specifies the height of the container. The default value is 400.
  /// The [padding] parameter specifies the padding around the container. The default value is `EdgeInsets.symmetric(vertical: 12)`.
  /// The [decoration] parameter specifies the decoration of the container. The default value is a BoxDecoration with a rounded border and a specific color.
  const StoycoContainerModal({
    super.key,
    required this.child,
    this.height = 400,
    this.padding = const EdgeInsets.symmetric(
      vertical: 12,
    ),
    this.decoration = const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      color: Color(0xff253341),
    ),
    required this.title,
    this.onTapAccept,
    this.onTapCancel,
    this.showActions = false,
  });

  final Widget child;
  final double height;
  final EdgeInsets padding;
  final BoxDecoration decoration;
  final String title;
  final void Function()? onTapAccept;
  final void Function()? onTapCancel;
  final bool showActions;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: double.infinity,
        padding: padding,
        decoration: decoration,
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
              style: const TextStyle(
                fontFamily: 'Akkurat Pro',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xfff2f2fa),
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            const Divider(
              color: Color(0xff92929d),
              thickness: 1,
              indent: 32,
              endIndent: 32,
            ),
            child,
            showActions
                ? Column(
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
                : Container()
          ],
        ),
      );
}
