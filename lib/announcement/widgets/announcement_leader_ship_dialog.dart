import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/announcement/models/announcement_leaderboard_item.dart';
import 'package:stoyco_shared/announcement/utils/announcement_details_utils.dart';
import 'package:stoyco_shared/announcement/widgets/gradient_container.dart';

import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/utils/dialog_container.dart';

typedef LoadMoreCallback = Future<List<AnnouncementLeaderboardItem>> Function(
  int page,
);

class AnnouncementLeaderShipDialog extends StatefulWidget {
  const AnnouncementLeaderShipDialog({
    super.key,
    required this.updatedDate,
    required this.loadMoreCallback,
  });

  final String updatedDate;
  final LoadMoreCallback loadMoreCallback;

  @override
  State<AnnouncementLeaderShipDialog> createState() =>
      _AnnouncementLeaderShipDialogState();
}

class _AnnouncementLeaderShipDialogState
    extends State<AnnouncementLeaderShipDialog> {
  bool _isLoading = false;
  bool _isLoadingMore = false;
  List<AnnouncementLeaderboardItem> _leaderboardItems = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _hasMoreData = true;
  late final String endDateText;

  // Cache commonly used responsive values
  final _cachedValues = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    endDateText =
        'Ultima actualización: ${AnnouncementDetailsUtils.formatDate(widget.updatedDate)}';
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _cachedValues.clear();
    super.dispose();
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final threshold = _scrollController.position.maxScrollExtent * 0.8;
    if (_scrollController.position.pixels >= threshold &&
        !_isLoadingMore &&
        _hasMoreData) {
      unawaited(_loadMoreData());
    }
  }

  Future<void> _loadInitialData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final items = await widget.loadMoreCallback(1);

      if (mounted) {
        setState(() {
          _leaderboardItems = items;
          _currentPage = 1;
          _hasMoreData = items.isNotEmpty;
        });
      }
    } catch (e) {
      debugPrint('Error loading leaderboard data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final moreItems = await widget.loadMoreCallback(nextPage);

      if (mounted) {
        if (moreItems.isEmpty) {
          setState(() {
            _hasMoreData = false;
            _isLoadingMore = false;
          });
          return;
        }

        setState(() {
          _leaderboardItems.addAll(moreItems);
          _currentPage = nextPage;
        });
      }
    } catch (e) {
      debugPrint('Error loading more leaderboard data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  // Cache responsive values to reduce recalculation
  T _getCachedValue<T>(String key, T Function() calculator) {
    if (!_cachedValues.containsKey(key)) {
      _cachedValues[key] = calculator();
    }
    return _cachedValues[key] as T;
  }

  @override
  Widget build(BuildContext context) => DialogContainer(
        padding: StoycoScreenSize.all(
          context,
          43,
          phone: 20,
          tablet: 30,
        ),
        maxWidth: StoycoScreenSize.width(
          context,
          771,
          phone: 500,
          tablet: 600,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: StoycoScreenSize.width(context, 7),
            children: [
              SvgPicture.asset(
                'packages/stoyco_shared/lib/assets/icons/champion_icon.svg',
                width: StoycoScreenSize.width(
                  context,
                  21.32,
                  phone: 18,
                  tablet: 20,
                  desktopLarge: 24,
                ),
                height: StoycoScreenSize.height(
                  context,
                  21.32,
                  phone: 18,
                  tablet: 20,
                  desktopLarge: 24,
                ),
              ),
              Text(
                'Leadership Board',
                style: TextStyle(
                  fontSize: StoycoScreenSize.fontSize(
                    context,
                    22,
                    phone: 12,
                    tablet: 14,
                  ),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFAFAFA),
                ),
              ),
              const Spacer(),
              if (!_isLoading)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: Navigator.of(context).pop,
                    child: SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/simple_close_icon.svg',
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
          Gap(StoycoScreenSize.height(context, 32, phone: 20, tablet: 30)),
          Row(
            mainAxisAlignment: _getCachedValue<bool>(
              'isPhone',
              () => StoycoScreenSize.isPhone(context),
            )
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                text: endDateText,
                iconPath:
                    'packages/stoyco_shared/lib/assets/icons/calendar_icon.svg',
              ),
            ],
          ),
          Gap(StoycoScreenSize.height(context, 42, phone: 20, tablet: 30)),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            SizedBox(
              height: StoycoScreenSize.screenHeight(context) * 0.5,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _leaderboardItems.length + (_isLoadingMore ? 1 : 0),
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  if (index == _leaderboardItems.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final item = _leaderboardItems[index];
                  return _buildLeaderboardItem(item, index);
                },
              ),
            ),
        ],
      );

  Widget _buildLeaderboardItem(AnnouncementLeaderboardItem item, int index) {
    final isPhone = _getCachedValue<bool>(
      'isPhone',
      () => StoycoScreenSize.isPhone(context),
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: StoycoScreenSize.width(context, 16, phone: 8, tablet: 12),
        vertical: StoycoScreenSize.height(context, 8, phone: 6, tablet: 7),
      ),
      child: Row(
        spacing: StoycoScreenSize.width(context, 78, phone: 10, tablet: 20),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: _responsiveWidth(16, phone: 12, tablet: 14),
            children: [
              Text(
                '${item.position < 10 ? '0' : ''}${item.position}.',
                style: _getTextStyle(14, phone: 11, tablet: 12),
              ),
              CircleAvatar(
                radius: _responsiveWidth(16, phone: 12, tablet: 14),
                backgroundImage: CachedNetworkImageProvider(item.userImageUrl),
                backgroundColor: const Color.fromARGB(255, 11, 18, 44),
              ),
            ],
          ),
          Row(
            spacing: _responsiveWidth(16, phone: 12, tablet: 14),
            children: [
              SvgPicture.asset(
                'packages/stoyco_shared/lib/assets/icons/titok_circle_icon.svg',
                width: _responsiveWidth(32, phone: 24, tablet: 28),
                height: _responsiveWidth(32, phone: 24, tablet: 28),
              ),
              Text(
                '@${item.tiktokUserName}',
                overflow: TextOverflow.ellipsis,
                style: _getTextStyle(14, phone: 11, tablet: 12),
              ),
            ],
          ),
          if (!isPhone)
            SizedBox(
              width:
                  StoycoScreenSize.width(context, 100, phone: 70, tablet: 90),
              child: Text(
                '${item.totalPost} Posts',
                textAlign: TextAlign.center,
                style: _getTextStyle(14, phone: 11, tablet: 12),
              ),
            ),
          SizedBox(
            width: StoycoScreenSize.width(context, 100, phone: 70, tablet: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.totalLikes} Likes',
                  style: _getTextStyle(14, phone: 11, tablet: 12),
                ),
                if (isPhone)
                  Text(
                    '${item.totalPost} Posts',
                    style: _getTextStyle(
                      10,
                      color: StoycoColors.text.withOpacity(0.7),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required String iconPath,
    bool isPrimary = false,
    double maxWidth = 360,
  }) {
    final iconSize = _responsiveWidth(
      21.32,
      phone: isPrimary ? 18 : 16,
      tablet: isPrimary ? 20 : 18,
      desktopLarge: 24,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: _responsiveWidth(
          maxWidth,
          phone: maxWidth,
          tablet: maxWidth * 0.9,
          desktopLarge: maxWidth * 1.08,
        ),
      ),
      child: InteractiveGradientPanel(
        padding: StoycoScreenSize.symmetric(
          context,
          vertical: 8.84,
          horizontal: 28.34,
        ),
        borderRadiusValue:
            _responsiveRadius(100, phone: 80, tablet: 90, desktopLarge: 120),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              color: StoycoColors.text,
              width: iconSize,
              height: iconSize,
            ),
            Gap(_responsiveWidth(10, phone: 10, tablet: 9, desktopLarge: 12)),
            Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: _getTextStyle(
                14,
                phone: 10,
                tablet: 12,
                desktopLarge: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _responsiveWidth(
    double width, {
    double? phone,
    double? tablet,
    double? desktopLarge,
  }) {
    final key = 'width_$width${phone}_${tablet}_$desktopLarge';
    return _getCachedValue<double>(
      key,
      () => StoycoScreenSize.width(
        context,
        width,
        phone: phone,
        tablet: tablet,
        desktopLarge: desktopLarge,
      ),
    );
  }

  double _responsiveRadius(
    double radius, {
    double? phone,
    double? tablet,
    double? desktopLarge,
  }) {
    final key = 'radius_$radius${phone}_${tablet}_$desktopLarge';
    return _getCachedValue<double>(
      key,
      () => StoycoScreenSize.radius(
        context,
        radius,
        phone: phone ?? radius * 0.8,
        tablet: tablet ?? radius * 0.9,
        desktopLarge: desktopLarge ?? radius * 1.2,
      ),
    );
  }

  TextStyle _getTextStyle(
    double fontSize, {
    double? phone,
    double? tablet,
    double? desktopLarge,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
  }) {
    final key =
        'style_$fontSize${phone}_${tablet}_$desktopLarge${color?.value}_$fontWeight';
    return _getCachedValue<TextStyle>(
      key,
      () => TextStyle(
        color: color ?? StoycoColors.text,
        fontSize: StoycoScreenSize.fontSize(
          context,
          fontSize,
          phone: phone,
          tablet: tablet,
          desktopLarge: desktopLarge,
        ),
        fontWeight: fontWeight,
      ),
    );
  }
}
