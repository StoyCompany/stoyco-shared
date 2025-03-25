import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/announcement/models/announcement_form_config.dart';

import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/utils/dialog_container.dart';
import 'package:stoyco_shared/utils/logger.dart';
import 'package:stoyco_shared/utils/text_button.dart';

class AnnouncementBasicDialog<T> extends StatefulWidget {
  AnnouncementBasicDialog({
    super.key,
    this.onSubmit,
    AnnouncementInfoBasicDialog? config,
  }) : config = config ?? AnnouncementInfoBasicDialog();

  final Future<T> Function(Map<String, dynamic>)? onSubmit;
  final AnnouncementInfoBasicDialog config;

  @override
  State<AnnouncementBasicDialog<T>> createState() =>
      _ParticipationFormDialogState<T>();
}

class _ParticipationFormDialogState<T>
    extends State<AnnouncementBasicDialog<T>> {
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 5));

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

  @override
  Widget build(BuildContext context) => DialogContainer(
        padding: StoycoScreenSize.fromLTRB(
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
                    onTap: Navigator.of(context).pop,
                    child: SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/close_icon.svg',
                      width: StoycoScreenSize.width(
                        context,
                        14,
                        phone: 10,
                        tablet: 12,
                      ),
                      height: StoycoScreenSize.height(
                        context,
                        14,
                        phone: 10,
                        tablet: 12,
                      ),
                      color: const Color(0xFFFAFAFA),
                    ),
                  ),
                ),
              ],
            ),
          Gap(StoycoScreenSize.height(context, 40)),
          Text(
            widget.config.title,
            style: TextStyle(
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
            padding: StoycoScreenSize.symmetric(
              context,
              horizontal: 21.5,
              horizontalPhone: 10,
            ),
            child: Text(
              widget.config.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: StoycoScreenSize.width(
                  context,
                  14,
                ),
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Gap(StoycoScreenSize.height(context, 40)),
          TextButtonStoyco(
            width: StoycoScreenSize.width(
              context,
              200,
              phone: 150,
              tablet: 180,
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
            onTap: !_isLoading ? _handleSubmit : () {},
            backgroundColor: !_isLoading ? null : const Color(0xFF92929D),
            loadingIndicatorSize: StoycoScreenSize.width(
              context,
              24,
              phone: 20,
              tablet: 22,
            ),
          ),
        ],
      );
}
