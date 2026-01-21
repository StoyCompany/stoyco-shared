import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/announcement/models/announcement_leaderboard_item.dart';
import 'package:stoyco_shared/announcement/utils/announcement_details_utils.dart';
import 'package:stoyco_shared/announcement/widgets/gradient_container.dart';
import 'package:stoyco_shared/stoyco_shared.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/utils/dialog_container.dart';

/// A callback function for loading paginated leaderboard data.
///
/// This function is called when additional leaderboard data needs to be loaded.
/// It returns a Future of a [PageResult] containing a list of [AnnouncementLeaderboardItem] objects.
///
/// * [page] - The page number to be loaded, starting from 1.
///
/// Example:
/// ```dart
/// Future<PageResult<AnnouncementLeaderboardItem>> loadLeaderboardData(int page) async {
///   final response = await apiClient.getLeaderboard(
///     campaignId: 'campaign-123',
///     page: page,
///     limit: 20,
///   );
///   return PageResult<AnnouncementLeaderboardItem>(
///     pageNumber: response.page,
///     pageSize: response.limit,
///     totalItems: response.total,
///     totalPages: response.totalPages,
///     updatedAt: response.updatedAt,
///     items: response.items.map((item) => AnnouncementLeaderboardItem.fromJson(item)).toList(),
///   );
/// }
/// ```
typedef LoadMoreCallback = Future<PageResult<AnnouncementLeaderboardItem>>
    Function(
  int page,
);

/// A dialog widget that displays a leaderboard of TikTok users.
///
/// This dialog shows a paginated list of TikTok users ranked by their performance
/// in a campaign (based on likes and posts count). The leaderboard supports
/// infinite scrolling with lazy loading of additional pages.
///
/// ## Features:
/// * Responsive layout for different screen sizes
/// * Pagination with infinite scrolling
/// * Display of user avatar, TikTok username, posts count, and likes count
/// * Last updated date display (uses the `updatedAt` field from the first page result)
///
/// Example:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => AnnouncementLeaderShipDialog(
///     loadMoreCallback: (page) => apiService.fetchLeaderboardData(
///       campaignId: 'abc123',
///       page: page,
///     ),
///   ),
/// );
/// ```
class AnnouncementLeaderShipDialog extends StatefulWidget {
  /// Creates an AnnouncementLeaderShipDialog.
  ///
  /// The [loadMoreCallback] is used to fetch paginated leaderboard data.
  ///
  /// Visual properties can be customized through various parameters like
  /// [titleFontSize], [contentFontSize], [dialogPadding], etc.
  const AnnouncementLeaderShipDialog({
    super.key,
    required this.loadMoreCallback,
    // Dialog customization
    this.dialogPadding,
    this.dialogMaxWidth,
    this.dialogHeight,
    // Title customization
    this.titleFontSize,
    this.titleFontWeight = FontWeight.w700,
    this.titleColor = const Color(0xFFFAFAFA),
    this.titleIconSize,
    this.closeIconSize,
    // Date display customization
    this.dateButtonPadding,
    this.dateButtonBorderRadius,
    this.dateIconSize,
    this.dateFontSize,
    this.dateFontWeight = FontWeight.w400,
    this.dateTextColor,
    // List customization
    this.listVerticalSpacing,
    this.itemPadding,
    this.positionFontSize,
    this.positionFontWeight = FontWeight.w400,
    this.usernameFontSize,
    this.usernameFontWeight = FontWeight.w400,
    this.countersFontSize,
    this.countersFontWeight = FontWeight.w400,
    this.avatarRadius,
    this.loadingIndicatorSize = 24.0,
    this.itemSpacing,
  });

  /// Callback function to load paginated leaderboard data.
  /// The function receives a page number and should return a list of [AnnouncementLeaderboardItem].
  final LoadMoreCallback loadMoreCallback;

  // Dialog customization
  final EdgeInsetsGeometry? dialogPadding;
  final double? dialogMaxWidth;
  final double? dialogHeight;

  // Title customization
  final double? titleFontSize;
  final FontWeight titleFontWeight;
  final Color titleColor;
  final double? titleIconSize;
  final double? closeIconSize;

  // Date display customization
  final EdgeInsetsGeometry? dateButtonPadding;
  final double? dateButtonBorderRadius;
  final double? dateIconSize;
  final double? dateFontSize;
  final FontWeight dateFontWeight;
  final Color? dateTextColor;

  // List customization
  final double? listVerticalSpacing;
  final EdgeInsetsGeometry? itemPadding;
  final double? positionFontSize;
  final FontWeight positionFontWeight;
  final double? usernameFontSize;
  final FontWeight usernameFontWeight;
  final double? countersFontSize;
  final FontWeight countersFontWeight;
  final double? avatarRadius;
  final double loadingIndicatorSize;
  final double? itemSpacing;

  @override
  State<AnnouncementLeaderShipDialog> createState() =>
      _AnnouncementLeaderShipDialogState();
}

class _AnnouncementLeaderShipDialogState
    extends State<AnnouncementLeaderShipDialog> {
  /// Indicates if the initial data is being loaded.
  bool _isLoading = false;

  /// Indicates if more data is being loaded during pagination.
  bool _isLoadingMore = false;

  /// The paginated leaderboard data.
  PageResult<AnnouncementLeaderboardItem>? _leaderboardPage;

  /// Stores the updated date from the first loadMoreCallback call.
  DateTime? _updatedAt;

  /// Controller for the scrollable list view to detect scroll position.
  final ScrollController _scrollController = ScrollController();

  /// Current page number for pagination, starting from 1.
  int _currentPage = 1;

  /// Indicates if there is more data to be loaded.
  bool _hasMoreData = true;

  /// Formatted text showing the last update date.
  String get endDateText {
    final dateToFormat =
        _updatedAt ?? DateTime.now(); // Use current date if null.
    return 'Actualizada:  ${AnnouncementDetailsUtils.formatDate(dateToFormat.toIso8601String(), showTime: false)}';
  }

  /// Cache to store commonly used responsive values to optimize performance.
  final _cachedValues = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
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
      final pageResult = await widget.loadMoreCallback(1);

      if (mounted) {
        setState(() {
          _leaderboardPage = pageResult;
          _updatedAt =
              pageResult.updatedAt; // Set updatedAt from the first call.
          _currentPage = pageResult.pageNumber ?? 1;
          _hasMoreData = (pageResult.items?.isNotEmpty ?? false) &&
              (_currentPage < (pageResult.totalPages ?? 1));
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
      final pageResult = await widget.loadMoreCallback(nextPage);

      if (mounted) {
        if (pageResult.items?.isEmpty ?? true) {
          setState(() {
            _hasMoreData = false;
            _isLoadingMore = false;
          });
          return;
        }

        setState(() {
          _leaderboardPage = _leaderboardPage?.copyWith(
            items: [
              ...?_leaderboardPage?.items,
              ...?pageResult.items,
            ],
          );
          _currentPage = pageResult.pageNumber ?? nextPage;
          _hasMoreData = _currentPage < (pageResult.totalPages ?? 1);
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
        radius: StoycoScreenSize.radius(context, 5),
        padding: widget.dialogPadding ??
            StoycoScreenSize.all(
              context,
              43,
              phone: 20,
              tablet: 30,
            ),
        maxWidth: widget.dialogMaxWidth ??
            StoycoScreenSize.width(
              context,
              771,
              phone: 500,
              tablet: 600,
            ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/champion_icon.svg',
                      width: widget.titleIconSize ??
                          StoycoScreenSize.width(
                            context,
                            21.32,
                            phone: 18,
                            tablet: 20,
                            desktopLarge: 24,
                          ),
                      height: widget.titleIconSize ??
                          StoycoScreenSize.height(
                            context,
                            21.32,
                            phone: 18,
                            tablet: 20,
                            desktopLarge: 24,
                          ),
                    ),
                    Gap(StoycoScreenSize.width(context, 7)),
                    Text(
                      'Leadership Board',
                      style: TextStyle(
                        fontSize: widget.titleFontSize ??
                            StoycoScreenSize.fontSize(
                              context,
                              22,
                              phone: 12,
                              tablet: 14,
                            ),
                        fontWeight: widget.titleFontWeight,
                        color: widget.titleColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (!_isLoading)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: Navigator.of(context).pop,
                    child: SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/simple_close_icon.svg',
                      width: widget.closeIconSize ??
                          StoycoScreenSize.width(
                            context,
                            14,
                          ),
                      height: widget.closeIconSize ??
                          StoycoScreenSize.height(
                            context,
                            14,
                          ),
                      color: const Color(0xFFFAFAFA),
                    ),
                  ),
                ),
            ],
          ),
          Gap(
            widget.listVerticalSpacing ??
                StoycoScreenSize.height(context, 32, phone: 20, tablet: 30),
          ),
          Row(
            mainAxisAlignment: _getCachedValue<bool>(
              'isPhone',
              () => StoycoScreenSize.isPhone(context),
            )
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildActionButton(
                  text: endDateText,
                  iconPath:
                      'packages/stoyco_shared/lib/assets/icons/rounded_calendar_icon.svg',
                ),
              ),
            ],
          ),
          Gap(
            widget.listVerticalSpacing ??
                StoycoScreenSize.height(context, 42, phone: 20, tablet: 30),
          ),
          if (_isLoading)
            Center(
              child: SizedBox(
                width: widget.loadingIndicatorSize,
                height: widget.loadingIndicatorSize,
                child: const CircularProgressIndicator(),
              ),
            )
          else
            SizedBox(
              height: widget.dialogHeight ??
                  StoycoScreenSize.screenHeight(context) * 0.5,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: (_leaderboardPage?.items?.length ?? 0) +
                    (_isLoadingMore ? 1 : 0),
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  if (index == _leaderboardPage?.items?.length) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: widget.loadingIndicatorSize,
                          height: widget.loadingIndicatorSize,
                          child: const CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }

                  final item = _leaderboardPage?.items?[index];
                  if (item == null) {
                    return const SizedBox.shrink();
                  }

                  return _buildLeaderboardItem(item, index + 1);
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
      padding: widget.itemPadding ??
          EdgeInsets.symmetric(
            horizontal:
                StoycoScreenSize.width(context, 16, phone: 8, tablet: 12),
            vertical: StoycoScreenSize.height(context, 8, phone: 6, tablet: 7),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                ' ${index < 10 ? '0' : ''}$index.',
                style: TextStyle(
                  fontSize: widget.positionFontSize ??
                      _getCachedValue<double>(
                        'position_font_size',
                        () => StoycoScreenSize.fontSize(
                          context,
                          14,
                          phone: 11,
                          tablet: 12,
                        ),
                      ),
                  fontWeight: widget.positionFontWeight,
                  color: widget.dateTextColor ?? StoycoColors.text,
                ),
              ),
              Gap(
                _responsiveWidth(16, phone: 12, tablet: 14),
              ),
              CircleAvatar(
                radius: widget.avatarRadius ??
                    _responsiveWidth(16, phone: 12, tablet: 14),
                backgroundImage: CachedNetworkImageProvider(item.userImageUrl),
                backgroundColor: const Color.fromARGB(255, 11, 18, 44),
              ),
            ],
          ),
          Gap(widget.itemSpacing ?? _responsiveWidth(12)),
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  try {
                    final url = Uri.parse(item.urlPlatform);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  } catch (e) {
                    StoyCoLogger.error(
                      'Error launching URL: ${item.urlPlatform}',
                      error: e,
                    );
                  }
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/titok_circle_icon.svg',
                      width: widget.dateIconSize ??
                          _responsiveWidth(32, phone: 18.5, tablet: 28),
                      height: widget.dateIconSize ??
                          _responsiveWidth(32, phone: 18.5, tablet: 28),
                    ),
                    Gap(
                      widget.itemSpacing ??
                          _responsiveWidth(16, phone: 12, tablet: 14),
                    ),
                    Expanded(
                      child: Text(
                        '@${item.tiktokUserName}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: widget.usernameFontSize ??
                              _getCachedValue<double>(
                                'username_font_size',
                                () => StoycoScreenSize.fontSize(
                                  context,
                                  14,
                                  phone: 11,
                                  tablet: 12,
                                ),
                              ),
                          fontWeight: widget.usernameFontWeight,
                          color: widget.dateTextColor ?? StoycoColors.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Gap(_responsiveWidth(12)),
          if (!isPhone)
            SizedBox(
              width:
                  StoycoScreenSize.width(context, 100, phone: 70, tablet: 90),
              child: Text(
                '${item.totalPost} Posts',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: widget.countersFontSize ??
                      _getCachedValue<double>(
                        'counters_font_size',
                        () => StoycoScreenSize.fontSize(
                          context,
                          14,
                          phone: 11,
                          tablet: 12,
                        ),
                      ),
                  fontWeight: widget.countersFontWeight,
                  color: widget.dateTextColor ?? StoycoColors.text,
                ),
              ),
            ),
          Gap(_responsiveWidth(12)),
          Text(
            '${item.totalPost} Posts',
            style: TextStyle(
              fontSize: widget.countersFontSize ??
                  _getCachedValue<double>(
                    'small_counters_font_size',
                    () => StoycoScreenSize.fontSize(context, 11),
                  ),
              fontWeight: widget.countersFontWeight,
              color: widget.dateTextColor ?? StoycoColors.text,
            ),
          ),
          Gap(_responsiveWidth(12)),
          Text(
            '${item.totalLikes} Likes',
            style: TextStyle(
              fontSize: widget.countersFontSize ??
                  _getCachedValue<double>(
                    'counters_font_size',
                    () => StoycoScreenSize.fontSize(
                      context,
                      14,
                      phone: 11,
                      tablet: 12,
                    ),
                  ),
              fontWeight: widget.countersFontWeight,
              color: widget.dateTextColor ?? StoycoColors.text,
            ),
          ),
          /*Flexible(
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item.totalLikes} Likes',
                    style: TextStyle(
                      fontSize: widget.countersFontSize ??
                          _getCachedValue<double>(
                            'counters_font_size',
                            () => StoycoScreenSize.fontSize(
                              context,
                              14,
                              phone: 11,
                              tablet: 12,
                            ),
                          ),
                      fontWeight: widget.countersFontWeight,
                      color: widget.dateTextColor ?? StoycoColors.text,
                    ),
                  ),
                  if (isPhone)
                    Text(
                      '${item.totalPost} Posts',
                      style: TextStyle(
                        fontSize: widget.countersFontSize != null
                            ? widget.countersFontSize! * 0.8
                            : _getCachedValue<double>(
                                'small_counters_font_size',
                                () => StoycoScreenSize.fontSize(context, 10),
                              ),
                        fontWeight: widget.countersFontWeight,
                        color: (widget.dateTextColor ?? StoycoColors.text)
                            .withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required String iconPath,
    bool isPrimary = false,
  }) {
    final iconSize = widget.dateIconSize ??
        _responsiveWidth(
          21.32,
          phone: isPrimary ? 18 : 16,
          tablet: isPrimary ? 20 : 18,
          desktopLarge: 24,
        );

    return InteractiveGradientPanel(
      viewShadow: false,
      gradient: LinearGradient(
        colors: [
          Color(0xFF253341),
          Color(0xFF253341),
        ],
      ),
      padding: widget.dateButtonPadding ??
          StoycoScreenSize.symmetric(
            context,
            vertical: 8.84,
            horizontal: 28.34,
          ),
      borderRadiusValue: widget.dateButtonBorderRadius ??
          _responsiveRadius(100, phone: 80, tablet: 90, desktopLarge: 120),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            color: widget.dateTextColor ?? StoycoColors.text,
            width: iconSize,
            height: iconSize,
          ),
          Gap(_responsiveWidth(10, phone: 10, tablet: 9, desktopLarge: 12)),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: widget.dateFontSize ??
                  _getCachedValue<double>(
                    'date_font_size',
                    () => StoycoScreenSize.fontSize(
                      context,
                      14,
                      phone: 10,
                      tablet: 12,
                      desktopLarge: 16,
                    ),
                  ),
              fontWeight: widget.dateFontWeight,
              color: widget.dateTextColor ?? StoycoColors.text,
            ),
          ),
        ],
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
