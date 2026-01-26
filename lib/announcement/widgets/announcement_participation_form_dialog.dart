import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import 'package:reactive_forms/reactive_forms.dart';

import 'package:stoyco_shared/announcement/models/announcement_form_config.dart';
import 'package:stoyco_shared/core/ui/atoms/atoms.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/form/fields/text_field.dart';
import 'package:stoyco_shared/utils/dialog_container.dart';
import 'package:stoyco_shared/utils/logger.dart';
import 'package:stoyco_shared/utils/text_button.dart';

/// A dialog widget that displays a form for participation in announcements.
///
/// This dialog collects TikTok username and post URL from users who want to
/// participate in an announcement or campaign.
///
/// ## Features:
/// - Configurable validation patterns for username and URL
/// - Customizable labels, hints, and error messages
/// - Loading state management for form submission
/// - Responsive design that adapts to different screen sizes
///
/// ## Example:
///
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => AnnouncementParticipationFormDialog<bool>(
///     onSubmit: (formData) async {
///       // Process the form data (e.g., send to API)
///       final username = formData['tiktok_username'];
///       final postUrl = formData['post_url'];
///       return await participationService.submit(username, postUrl);
///     },
///     config: AnnouncementParticipationViewConfig(
///       dialogTitle: 'Join Our Campaign',
///       buttonText: 'Submit Entry',
///     ),
///   ),
/// );
/// ```
class AnnouncementParticipationFormDialog<T> extends StatefulWidget {
  /// Creates an announcement participation form dialog.
  ///
  /// The [onSubmit] callback is required and will be called when the user
  /// submits the form with valid data.
  ///
  /// The [onPop] callback is optional and can be used to handle custom
  /// navigation when the dialog is closed.
  ///
  /// The [config] parameter allows customization of the form appearance and
  /// behavior. If not provided, default values will be used.
  const AnnouncementParticipationFormDialog({
    super.key,
    required this.onSubmit,
    this.onPop,
    config,
    // Visual configuration parameters
    this.dialogPadding,
    this.closeIconSize,
    this.closeIconColor,
    this.gapSize,
    this.titleIconSize,
    this.titleFontSize,
    this.titleFontWeight = FontWeight.bold,
    this.formFieldSpacing,
    this.inputBorderRadius = 16.0,
    this.termsTextPadding,
    this.termsFontSize,
    this.termsFontWeight = FontWeight.w700,
    this.buttonWidth,
    this.buttonHeight,
    this.buttonFontSize,
    this.loadingIndicatorSize,
  }) : config = config ?? const AnnouncementParticipationViewConfig();

  /// Callback function that processes the form data when submitted.
  ///
  /// This function receives a map containing the form values and should return
  /// a Future of type T (the result of the submission).
  final Future<T> Function(Map<String, dynamic>) onSubmit;

  /// Optional callback to handle navigation when the dialog is closed.
  ///
  /// If provided, this function will be called instead of the default
  /// Navigator.pop() with the result parameter.
  final Function(dynamic result)? onPop;

  /// Configuration options for customizing the dialog appearance and behavior.
  final AnnouncementParticipationViewConfig config;

  // Visual property parameters
  final EdgeInsetsGeometry? dialogPadding;
  final double? closeIconSize;
  final Color? closeIconColor;
  final double? gapSize;
  final double? titleIconSize;
  final double? titleFontSize;
  final FontWeight titleFontWeight;
  final double? formFieldSpacing;
  final double inputBorderRadius;
  final EdgeInsetsGeometry? termsTextPadding;
  final double? termsFontSize;
  final FontWeight termsFontWeight;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? buttonFontSize;
  final double? loadingIndicatorSize;

  @override
  State<AnnouncementParticipationFormDialog<T>> createState() =>
      _ParticipationFormDialogState<T>();
}

/// State management class for the AnnouncementParticipationFormDialog.
///
/// Handles form creation, validation, submission, and UI state management.
class _ParticipationFormDialogState<T>
    extends State<AnnouncementParticipationFormDialog<T>> {
  /// Flag to track if the form is currently submitting data.
  bool _isLoading = false;

  /// Form group containing the input fields and their validation rules.
  late FormGroup form;

  @override
  void initState() {
    super.initState();

    final usernamePattern =
        widget.config.usernamePattern ?? r'^(?=.{2,24}$)[A-Za-z0-9_.]+(?<!\.)$';
    final urlPattern = widget.config.urlPattern ??
        r'^(?:https?:\/\/(?:[\w-]+\.)*tiktok\.com(?:\/(?:@[\w.-]+\/video\/\d+(?:\?.*)?|\w+\/?)))$';

    // Initialize the form with validation rules for both fields
    form = FormGroup({
      'tiktok_username': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern(usernamePattern),
        ],
      ),
      'post_url': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern(urlPattern),
        ],
      ),
    });
  }

  /// Handles closing the dialog with an optional result.
  ///
  /// Uses the custom onPop callback if provided, otherwise uses Navigator.pop().
  /// Default result is false if not specified.
  void _handlePop([dynamic result = false]) {
    try {
      if (widget.onPop != null) {
        widget.onPop!(result);
      } else {
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      StoyCoLogger.error('Error during navigation pop: $e');
      throw Exception(
        'Navigation pop failed. Please check your navigation implementation: $e',
      );
    }
  }

  //_handlePop without result
  /// Closes the dialog without passing any result.
  ///
  /// This is a convenience method for closing the dialog without
  /// returning any data.
  void _handlePopWithoutResult() {
    try {
      if (widget.onPop != null) {
        widget.onPop!(null);
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      StoyCoLogger.error('Error during navigation pop: $e');
      throw Exception(
        'Navigation pop failed. Please check your navigation implementation: $e',
      );
    }
  }

  /// Handles the form submission process.
  ///
  /// Validates the form, shows loading state, calls the onSubmit callback,
  /// and handles success or error states appropriately.
  Future<void> _handleSubmit() async {
    if (!form.valid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await widget.onSubmit(form.value);
      _handlePop(result);
    } catch (e) {
      StoyCoLogger.error('Error submitting: $e');
      _handlePop();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => DialogContainer(
        radius: StoycoScreenSize.radius(context, 5),
        padding: widget.dialogPadding ??
            StoycoScreenSize.all(
              context,
              43,
              phone: 20,
              tablet: 30,
            ),
        children: [
          if (!_isLoading)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => _handlePopWithoutResult(),
                    child: SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/simple_close_icon.svg',
                      width: widget.closeIconSize ??
                          StoycoScreenSize.width(context, 14),
                      height: widget.closeIconSize ??
                          StoycoScreenSize.height(context, 14),
                      color: widget.closeIconColor ?? const Color(0xFFFAFAFA),
                    ),
                  ),
                ),
              ],
            ),
          Gap(widget.gapSize ?? StoycoScreenSize.height(context, 20)),
          ReactiveForm(
            formGroup: form,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/sent_icon.svg',
                      width: widget.titleIconSize ??
                          StoycoScreenSize.width(
                            context,
                            20,
                            phone: 32,
                          ),
                      height: widget.titleIconSize ??
                          StoycoScreenSize.height(
                            context,
                            20,
                            phone: 32,
                          ),
                    ),
                    Gap(StoycoScreenSize.width(context, 20)),
                    Text(
                      widget.config.dialogTitle,
                      style: TextStyle(
                        fontSize: widget.titleFontSize ??
                            StoycoScreenSize.width(
                              context,
                              20,
                              phone: 20,
                            ),
                        fontWeight: widget.titleFontWeight,
                      ),
                    ),
                  ],
                ),
                Gap(
                  widget.formFieldSpacing ??
                      StoycoScreenSize.height(context, 20),
                ),
                Row(
                  children: [
                    CustomText(
                      widget.config.usernameLabel,
                    ),
                  ],
                ),
                StoyCoTextFormField(
                  formControlName: 'tiktok_username',
                  labelText: widget.config.usernameLabel,
                  hintText: widget.config.usernameHint,
                  validationMessages: {
                    ValidationMessage.required: (field) =>
                        widget.config.usernameRequiredMessage,
                    ValidationMessage.pattern: (field) =>
                        widget.config.usernamePatternMessage,
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixText: '@',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFFF8F9FA).withOpacity(0.5),
                      ),
                      borderRadius:
                          BorderRadius.circular(widget.inputBorderRadius),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFFF8F9FA).withOpacity(0.8),
                      ),
                      borderRadius:
                          BorderRadius.circular(widget.inputBorderRadius),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFF8F9FA),
                      ),
                      borderRadius:
                          BorderRadius.circular(widget.inputBorderRadius),
                    ),
                  ),
                ),
                Gap(
                  widget.formFieldSpacing ??
                      StoycoScreenSize.height(context, 20),
                ),
                Row(
                  children: [
                    CustomText(
                      widget.config.urlLabel,
                    ),
                  ],
                ),
                StoyCoTextFormField(
                  formControlName: 'post_url',
                  labelText: widget.config.urlLabel,
                  hintText: widget.config.urlHint,
                  validationMessages: {
                    ValidationMessage.required: (field) =>
                        widget.config.urlRequiredMessage,
                    ValidationMessage.pattern: (field) =>
                        widget.config.urlPatternMessage,
                  },
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: widget.config.urlHint,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFFF8F9FA).withOpacity(0.5),
                      ),
                      borderRadius:
                          BorderRadius.circular(widget.inputBorderRadius),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFFF8F9FA).withOpacity(0.8),
                      ),
                      borderRadius:
                          BorderRadius.circular(widget.inputBorderRadius),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFF8F9FA),
                      ),
                      borderRadius:
                          BorderRadius.circular(widget.inputBorderRadius),
                    ),
                  ),
                ),
                Gap(
                  widget.formFieldSpacing ??
                      StoycoScreenSize.height(context, 20),
                ),
                Text(
                  widget.config.termsText,
                  style: TextStyle(
                    fontSize: widget.termsFontSize ??
                        StoycoScreenSize.width(
                          context,
                          12,
                          phone: 10,
                        ),
                    fontWeight: widget.termsFontWeight,
                  ),
                ),
                Gap(
                  widget.formFieldSpacing ??
                      StoycoScreenSize.height(context, 20),
                ),
                ReactiveFormConsumer(
                  builder: (context, form, child) => TextButtonStoyco(
                    radius: StoycoScreenSize.radius(context, 100),
                    width: widget.buttonWidth ??
                        StoycoScreenSize.width(
                          context,
                          150,
                          phone: 125,
                          tablet: 140,
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
                    fontWeight: widget.config.buttonFontWeight,
                    text: widget.config.buttonText,
                    isLoading: _isLoading,
                    onTap: form.valid ? _handleSubmit : () {},
                    backgroundColor: form.valid && !_isLoading
                        ? const Color(0xFF6C61FF)
                        : const Color(0xFF92929D),
                    loadingIndicatorSize: widget.loadingIndicatorSize ??
                        StoycoScreenSize.width(
                          context,
                          24,
                          phone: 20,
                          tablet: 22,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
