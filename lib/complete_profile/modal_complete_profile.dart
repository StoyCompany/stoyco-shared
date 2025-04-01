import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/utils/dialog_container.dart';
import 'package:stoyco_shared/utils/text_button.dart';

/// A modal widget that displays a profile completion reminder dialog.
///
/// This widget shows a customizable dialog with a title, subtitle, and a call-to-action button.
/// It's primarily used to encourage users to complete their profile information.
///
/// Example:
/// ```dart
/// ModalCompleteProfile(
///   title: 'Custom Title',
///   subtitle: 'Custom message here',
///   buttonText: 'Action Button',
///   onTap: () => print('Custom action'),
/// )
/// ```
class ModalCompleteProfile extends StatelessWidget {
  const ModalCompleteProfile(
      {super.key,
      this.padding,
      this.title = '¡Hola de nuevo!',
      this.subtitle =
          '¡No olvides completar tu perfil en StoyCo para disfrutar de una experiencia personalizada al máximo!',
      this.buttonText = 'Completar mi perfil',
      this.onTap,});

  /// Custom padding for the modal content.
  /// If null, default padding will be applied using [StoycoScreenSize].
  final EdgeInsets? padding;

  /// The title displayed at the top of the modal.
  /// Defaults to '¡Hola de nuevo!'.
  final String title;

  /// The descriptive text shown below the title.
  /// Defaults to a message encouraging profile completion.
  final String subtitle;

  /// The text displayed on the action button.
  /// Defaults to 'Completar mi perfil'.
  final String buttonText;

  /// Callback function triggered when the action button is tapped.
  /// If null, defaults to navigating to the profile detail screen.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => DialogContainer(
        canClose: true,
        padding: padding ??
            StoycoScreenSize.symmetric(
              context,
              horizontal: 35.5,
              vertical: 33,
            ),
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textScaler: TextScaler.noScaling,
          ),
          Gap(StoycoScreenSize.height(context, 8)),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            textScaler: TextScaler.noScaling,
          ),
          Gap(StoycoScreenSize.height(context, 28)),
          TextButtonStoyco(
              width: double.infinity,
              height: 60,
              text: buttonText,
              onTap: onTap ?? () {},),
        ],
      );
}
