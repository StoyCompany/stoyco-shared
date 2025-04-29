import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/announcement/models/announcement_form_config.dart';

import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/utils/dialog_container.dart';
import 'package:stoyco_shared/utils/logger.dart';
import 'package:stoyco_shared/utils/text_button.dart';

/// A dialog widget for displaying announcements with configurable content and appearance.
///
/// This dialog provides a simple and customizable way to show announcements to users
/// with a title, description, and action button.
///
/// ## Example
///
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => AnnouncementBasicDialog<bool>(
///     config: AnnouncementInfoBasicDialog(
///       title: 'New Feature Available!',
///       description: 'We have added a new exciting feature to the app.',
///       buttonText: 'Got it',
///     ),
///     onSubmit: (data) async {
///       // Perform actions after button press
///       await analyticsService.logAnnouncementSeen();
///       return true;
///     },
///   ),
/// );
/// ```
class AnnouncementBasicDialog<T> extends StatefulWidget {
  /// Creates an announcement dialog.
  ///
  /// The [config] parameter customizes the dialog's content.
  /// The [onSubmit] callback is triggered when the user presses the action button.
  ///
  /// ## Example
  ///
  /// ```dart
  /// AnnouncementBasicDialog<void>(
  ///   config: AnnouncementInfoBasicDialog(
  ///     title: 'Welcome!',
  ///     description: 'Thank you for joining our platform.',
  ///     buttonText: 'Continue',
  ///   ),
  ///   onSubmit: (_) async {
  ///     await userPreferences.setWelcomeShown(true);
  ///   },
  /// )
  /// ```
  const AnnouncementBasicDialog({
    super.key,
    this.onSubmit,
    AnnouncementInfoBasicDialog? config,
    this.dialogPadding,
    this.closeIconSize,
    this.titleGap,
    this.titleStyle,
    this.descriptionPadding,
    this.descriptionStyle,
    this.descriptionGap,
    this.buttonWidth,
    this.buttonHeight,
    this.buttonFontSize,
    this.loadingIndicatorSize,
    this.buttonDisabledColor,
  }) : config = config ?? const AnnouncementInfoBasicDialog();

  /// Callback function triggered when the user presses the action button.
  ///
  /// The function receives an empty map that can be extended in subclasses
  /// to pass data from the dialog. It returns a Future of type T.
  final Future<T> Function(Map<String, dynamic>)? onSubmit;

  /// Configuration options for the dialog content.
  ///
  /// This includes the title, description, and button text.
  final AnnouncementInfoBasicDialog config;

  /// Padding for the dialog container
  final EdgeInsets? dialogPadding;

  /// Size for the close icon
  final Size? closeIconSize;

  /// Gap between close icon and title
  final double? titleGap;

  /// Text style for the title
  final TextStyle? titleStyle;

  /// Padding for the description text
  final EdgeInsets? descriptionPadding;

  /// Text style for the description
  final TextStyle? descriptionStyle;

  /// Gap between description and button
  final double? descriptionGap;

  /// Width of the button
  final double? buttonWidth;

  /// Height of the button
  final double? buttonHeight;

  /// Font size for the button text
  final double? buttonFontSize;

  /// Size for the loading indicator
  final double? loadingIndicatorSize;

  /// Color for the disabled button
  final Color? buttonDisabledColor;

  @override
  State<AnnouncementBasicDialog<T>> createState() =>
      _ParticipationFormDialogState<T>();
}

class _ParticipationFormDialogState<T>
    extends State<AnnouncementBasicDialog<T>> {
  bool _isLoading = false;

  /// Handles the submission when the action button is pressed.
  ///
  /// This method:
  /// 1. Sets the loading state to true
  /// 2. Calls the onSubmit callback if provided
  /// 3. Closes the dialog with a result of true
  /// 4. Handles any errors that occur during submission
  /// 5. Resets the loading state
  Future<void> _handleSubmit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.onSubmit != null) {
        await widget.onSubmit!({});
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      StoyCoLogger.error('Error submitting: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _closeDialog() {
    Navigator.of(context).pop({});
  }

  @override
  Widget build(BuildContext context) => DialogContainer(
        padding: widget.dialogPadding ??
            StoycoScreenSize.fromLTRB(
              context,
              top: 24,
              topPhone: 20,
              topTablet: 22,
              left: 24,
              leftPhone: 20,
              leftTablet: 22,
              right: 24,
              rightPhone: 20,
              rightTablet: 22,
              bottom: 61,
              bottomPhone: 50,
              bottomTablet: 56,
            ),
        children: [
          if (!_isLoading)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      _closeDialog();
                    },
                    child: SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/simple_close_icon.svg',
                      width: widget.closeIconSize?.width ??
                          StoycoScreenSize.width(context, 14),
                      height: widget.closeIconSize?.height ??
                          StoycoScreenSize.height(context, 14),
                      color: const Color(0xFFFAFAFA),
                    ),
                  ),
                ),
              ],
            ),
          Gap(widget.titleGap ?? StoycoScreenSize.height(context, 40)),
          Text(
            widget.config.title,
            style: widget.titleStyle ??
                TextStyle(
                  fontSize: StoycoScreenSize.width(
                    context,
                    20,
                    phone: 14,
                  ),
                  fontWeight: FontWeight.bold,
                ),
          ),
          Gap(StoycoScreenSize.height(context, 40)),
          Padding(
            padding: widget.descriptionPadding ??
                StoycoScreenSize.symmetric(
                  context,
                  horizontal: 21.5,
                  horizontalPhone: 10,
                ),
            child: Text(
              widget.config.description,
              textAlign: TextAlign.center,
              style: widget.descriptionStyle ??
                  TextStyle(
                    fontSize: StoycoScreenSize.width(
                      context,
                      14,
                    ),
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          Gap(widget.descriptionGap ?? StoycoScreenSize.height(context, 40)),
          TextButtonStoyco(
            width: widget.buttonWidth ??
                StoycoScreenSize.width(
                  context,
                  200,
                  phone: 150,
                  tablet: 180,
                ),
            height: widget.buttonHeight ??
                StoycoScreenSize.height(
                  context,
                  46,
                  phone: 36,
                  tablet: 42,
                ),
            fontSize: widget.buttonFontSize ??
                StoycoScreenSize.fontSize(
                  context,
                  15,
                  phone: 11,
                  tablet: 13,
                  desktopLarge: 16,
                ),
            fontWeight: FontWeight.bold,
            text: widget.config.buttonText,
            isLoading: _isLoading,
            onTap: !_isLoading ? _handleSubmit : () {},
            backgroundColor: !_isLoading
                ? null
                : (widget.buttonDisabledColor ?? const Color(0xFF92929D)),
            loadingIndicatorSize: widget.loadingIndicatorSize ??
                StoycoScreenSize.width(
                  context,
                  24,
                  phone: 20,
                  tablet: 22,
                ),
          ),
        ],
      );
}
