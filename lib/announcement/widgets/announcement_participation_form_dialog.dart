import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import 'package:reactive_forms/reactive_forms.dart';

import 'package:stoyco_shared/announcement/models/announcement_form_config.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/form/fields/text_field.dart';
import 'package:stoyco_shared/utils/dialog_container.dart';
import 'package:stoyco_shared/utils/logger.dart';
import 'package:stoyco_shared/utils/text_button.dart';

class AnnouncementParticipationFormDialog<T> extends StatefulWidget {
  AnnouncementParticipationFormDialog({
    super.key,
    required this.onSubmit,
    AnnouncementParticipationViewConfig? config,
  }) : config = config ?? AnnouncementParticipationViewConfig();

  final Future<T> Function(Map<String, dynamic>) onSubmit;
  final AnnouncementParticipationViewConfig config;

  @override
  State<AnnouncementParticipationFormDialog<T>> createState() =>
      _ParticipationFormDialogState<T>();
}

class _ParticipationFormDialogState<T>
    extends State<AnnouncementParticipationFormDialog<T>> {
  bool _isLoading = false;
  late FormGroup form;

  @override
  void initState() {
    super.initState();

    final usernamePattern =
        widget.config.usernamePattern ?? r'^(?=.{2,24}$)[A-Za-z0-9_.]+(?<!\.)$';
    final urlPattern = widget.config.urlPattern ??
        r'^(?:https?:\/\/(?:[\w-]+\.)*tiktok\.com(?:\/(?:@[\w.-]+\/video\/\d+(?:\?.*)?|\w+\/?)))$';

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

  Future<void> _handleSubmit() async {
    if (!form.valid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Navigator.of(context).pop([
        await widget.onSubmit(form.value),
      ]);
      //Get.back(result: await widget.onSubmit(form.value), closeOverlays: true);
    } catch (e) {
      StoyCoLogger.error('Error submitting: $e');
      Navigator.of(context).pop(false);
      //Get.back(result: false, closeOverlays: true);
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
        padding: StoycoScreenSize.all(
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
                    onTap: Navigator.of(context).pop,
                    child: SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/close_icon.svg',
                      width: StoycoScreenSize.width(context, 14),
                      height: StoycoScreenSize.height(context, 14),
                      color: const Color(0xFFFAFAFA),
                    ),
                  ),
                ),
              ],
            ),
          Gap(StoycoScreenSize.height(context, 40)),
          ReactiveForm(
            formGroup: form,
            child: Column(
              spacing: StoycoScreenSize.height(context, 16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: StoycoScreenSize.width(context, 8),
                  children: [
                    SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/sent_icon.svg',
                      width: StoycoScreenSize.width(
                        context,
                        20,
                        phone: 14,
                      ),
                      height: StoycoScreenSize.height(
                        context,
                        20,
                        phone: 14,
                      ),
                    ),
                    Text(
                      widget.config.dialogTitle,
                      style: TextStyle(
                        fontSize: StoycoScreenSize.width(
                          context,
                          20,
                          phone: 14,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
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
                    labelText: widget.config.usernameLabel,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFF8F9FA).withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFF8F9FA).withOpacity(0.8),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFF8F9FA),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
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
                    labelText: widget.config.urlLabel,
                    hintText: widget.config.urlHint,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFF8F9FA).withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFF8F9FA).withOpacity(0.8),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFF8F9FA),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Padding(
                  padding: StoycoScreenSize.symmetric(
                    context,
                    horizontal: 31,
                    vertical: 24,
                  ),
                  child: Text(
                    widget.config.termsText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: StoycoScreenSize.width(
                        context,
                        12,
                        phone: 10,
                      ),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ReactiveFormConsumer(
                  builder: (context, form, child) => TextButtonStoyco(
                    width: StoycoScreenSize.width(
                      context,
                      150,
                      phone: 125,
                      tablet: 140,
                    ),
                    height: StoycoScreenSize.height(
                      context,
                      46,
                      phone: 36,
                      tablet: 42,
                    ),
                    fontSize: StoycoScreenSize.fontSize(
                      context,
                      15,
                      phone: 11,
                      tablet: 13,
                      desktopLarge: 16,
                    ),
                    text: widget.config.buttonText,
                    isLoading: _isLoading,
                    onTap: form.valid ? _handleSubmit : () {},
                    backgroundColor: form.valid && !_isLoading
                        ? null
                        : const Color(0xFF92929D),
                    loadingIndicatorSize: StoycoScreenSize.width(
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
