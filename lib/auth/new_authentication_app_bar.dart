import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Custom AppBar for the new authentication screen in a non-mobile (larger screen) layout.
///
/// This class extends the default [AppBar] and provides customization specific to the authentication screen.
class NewAuthenticationAppBar extends AppBar {
  /// A callback function to be executed when the leading icon is tapped.
  final void Function()? leadingOnTap;

  /// Creates a [NewAuthenticationAppBar] with the specified [title] and optional [leadingOnTap] callback.
  ///
  /// The [title] is the text displayed in the app bar.
  ///
  /// The optional [leadingOnTap] callback is triggered when the leading icon is tapped.
  NewAuthenticationAppBar({
    Key? key,
    required String title,
    this.leadingOnTap,
  }) : super(
          key: key,
          title: Padding(
            padding: const EdgeInsets.only(top: 71, left: 131, right: 131),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                title,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Color(0xFFF2F2FA),
                  fontSize: 16,
                  fontFamily: 'Akkurat Pro',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.black,
          toolbarHeight: 100,
          leadingWidth: 133 + 64,
          leading: Container(
            margin: const EdgeInsets.only(top: 60.0, left: 76, right: 76),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: leadingOnTap,
              child: SvgPicture.asset(
                'packages/stoyco_shared/lib/assets/icons/arrow_back.svg',
                height: 24,
                width: 24,
              ),
            ),
          ),
        );

  // Additional customization or documentation can be added as needed.
}

/// Custom AppBar for the new authentication screen in a mobile (smaller screen) layout.
///
/// This class extends the default [AppBar] and provides customization specific to the authentication screen on mobile devices.
class NewAuthenticationAppBarMobile extends AppBar {
  /// A callback function to be executed when the leading icon is tapped.
  final void Function()? leadingOnTap;

  /// The size of the leading icon.
  final double? leadingIconSize;

  /// Creates a [NewAuthenticationAppBarMobile] with the specified [title], [leadingOnTap] callback, and optional [leadingIconSize].
  ///
  /// The [title] is the text displayed in the app bar.
  ///
  /// The optional [leadingOnTap] callback is triggered when the leading icon is tapped.
  ///
  /// The optional [leadingIconSize] parameter allows customizing the size of the leading icon.
  NewAuthenticationAppBarMobile({
    Key? key,
    required String title,
    this.leadingOnTap,
    this.leadingIconSize,
  }) : super(
          key: key,
          leadingWidth: leadingIconSize ?? 32,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: leadingOnTap,
            child: SvgPicture.asset(
              'packages/stoyco_shared/lib/assets/icons/arrow_back.svg',
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFF2F2FA),
              fontSize: 16,
              fontFamily: 'Akkurat Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
        );
}
