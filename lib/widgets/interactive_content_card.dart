import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_interaction_content/stoyco_interaction_content.dart';
import 'package:stoyco_shared/announcement/widgets/cover_image_with_fade.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/design/skeleton_card.dart';
import 'package:stoyco_shared/stoyco_shared.dart';
import 'package:stoyco_shared/widgets/reactive_social_buttons.dart';

/// Enum representing different types of feed content.
///
/// Use [FeedType.fromString] to safely convert raw backend values to this enum.
enum FeedType {
  /// News content.
  news('news'),

  /// Announcement / convocatoria content.
  announcement('announcement'),

  /// Event content (mapped from backend value '1').
  events('3'),

  /// Unknown or unspecified content type.
  unknown('unknown');

  const FeedType(this.value);

  final String value;

  /// Creates a [FeedType] from a string value or returns [FeedType.unknown] if no match.
  static FeedType fromString(String? value) {
    if (value == null) return FeedType.unknown;
    return FeedType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => FeedType.unknown,
    );
  }
}

/// Abstract interface for content that can be displayed in [InteractiveContentCard].
abstract class InteractiveContent {
  String get id;
  String get title;
  String get mainImage;
  DateTime? get publishDate;
  DateTime? get endDate;
  Map<String, dynamic>? get customData;
  String? get state;
}

/// Adapter for [FeedContentItem] to [InteractiveContent].
class FeedContentAdapter implements InteractiveContent {
  const FeedContentAdapter(this.item);
  final FeedContentItem item;

  @override
  String get id => item.contentId;
  @override
  String get title => item.title;
  @override
  String get mainImage => item.mainImage;

  @override
  DateTime? get publishDate {
    try {
      return DateTime.parse(item.contentCreatedAt);
    } catch (_) {
      return null;
    }
  }

  @override
  DateTime? get endDate {
    try {
      return item.endDate != null ? DateTime.parse(item.endDate!) : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? get customData => item.customData;
  @override
  String? get state => item.state;

  /// Gets the feed type as an enum (e.g. [FeedType.news], [FeedType.announcement]).
  FeedType get feedType => FeedType.fromString(item.feedType);
}

/// Configuration values for the visual properties of [InteractiveContentCard].
class InteractiveCardConfig {
  const InteractiveCardConfig({
    this.height = 144.0,
    this.borderRadius = 5.0,
    this.spacing = 16.0,
    this.iconSize = 20.0,
    this.titleFontSize = 16.0,
    this.dateFontSize = 12.0,
    this.counterFontSize = 12.0,
    this.skeletonHeight = 16.0,
    this.titleMaxLines = 2,
    this.likedIconColor,
    this.unlikedIconColor,
    this.shareIconColor,
    this.textColor,
  });
  final double height;
  final double borderRadius;
  final double spacing;
  final double iconSize;
  final double titleFontSize;
  final double dateFontSize;
  final double counterFontSize;
  final double skeletonHeight;
  final int titleMaxLines;
  final Color? likedIconColor;
  final Color? unlikedIconColor;
  final Color? shareIconColor;
  final Color? textColor;

  /// Default configuration for news cards.
  static const news = InteractiveCardConfig(height: 144.0, titleMaxLines: 2);

  /// Default configuration for announcement cards.
  static const announcement = InteractiveCardConfig(height: 144.0, titleMaxLines: 2);
}

/// Callback definitions for interactions.
typedef OnLikeCallback = Future<void> Function(String contentId, bool isLiked);
typedef OnShareCallback = Future<void> Function({
  required String contentId,
  required String title,
  required String imageUrl,
});
typedef OnTapCallback = void Function(String contentId);
typedef OnLoadInteractionCountsCallback = Future<InteractionCounts> Function(String contentId);
typedef OnCheckIsLikedCallback = Future<bool> Function(String contentId);
typedef OnAuthenticationRequiredCallback = void Function();

/// Immutable view state for interaction-related values.
///
/// Using an immutable state object with [ValueNotifier] enables granular rebuilds via
/// [ValueListenableBuilder] instead of calling setState for every small change. This keeps
/// the widget lightweight and avoids introducing extra dependencies for simple local state.
class InteractionViewState {
  const InteractionViewState({
    this.isLiked = false,
    this.likeCount = 0,
    this.shareCount = 0,
    this.viewCount = 0,
    this.isLoadingCounts = false,
    this.processingLike = false,
    this.processingShare = false,
  });

  final bool isLiked;
  final int likeCount;
  final int shareCount;
  final int viewCount;
  final bool isLoadingCounts;
  final bool processingLike;
  final bool processingShare;

  InteractionViewState copyWith({
    bool? isLiked,
    int? likeCount,
    int? shareCount,
    int? viewCount,
    bool? isLoadingCounts,
    bool? processingLike,
    bool? processingShare,
  }) => InteractionViewState(
        isLiked: isLiked ?? this.isLiked,
        likeCount: likeCount ?? this.likeCount,
        shareCount: shareCount ?? this.shareCount,
        viewCount: viewCount ?? this.viewCount,
        isLoadingCounts: isLoadingCounts ?? this.isLoadingCounts,
        processingLike: processingLike ?? this.processingLike,
        processingShare: processingShare ?? this.processingShare,
      );
}

/// Controller to drive an [InteractiveContentCard] from outside.
///
/// Supply this to the widget to manually refresh interaction values (e.g. after an API call
/// higher in the tree). If omitted, the widget creates its own internal controller.
class InteractiveContentCardController {
  InteractiveContentCardController([InteractionViewState initial = const InteractionViewState()])
      : state = ValueNotifier<InteractionViewState>(initial);

  /// Internal notifier holding the current [InteractionViewState].
  final ValueNotifier<InteractionViewState> state;

  /// Internal callback assigned by the widget to trigger a data refresh.
  /// Do not set manually; use [reloadCounts].
  VoidCallback? _reloadCounts;

  /// Replaces the entire state.
  void update(InteractionViewState newState) => state.value = newState;

  /// Patches selected fields of the current state.
  void patch({
    bool? isLiked,
    int? likeCount,
    int? shareCount,
    int? viewCount,
    bool? isLoadingCounts,
    bool? processingLike,
    bool? processingShare,
  }) {
    state.value = state.value.copyWith(
      isLiked: isLiked,
      likeCount: likeCount,
      shareCount: shareCount,
      viewCount: viewCount,
      isLoadingCounts: isLoadingCounts,
      processingLike: processingLike,
      processingShare: processingShare,
    );
  }

  /// Requests the widget to reload interaction counts from its data source.
  /// Does nothing if the widget did not provide a loader callback.
  void reloadCounts() => _reloadCounts?.call();

  /// Disposes the underlying notifier. Only call if you own the controller.
  void dispose() {
    _reloadCounts = null;
    state.dispose();
  }
}

/// A reusable interactive content card widget with social features.
///
/// Features:
/// - Like & share actions with animated feedback.
/// - Optional participate button for events / announcements.
/// - External refresh via [InteractiveContentCardController].
/// - Lightweight state management using [ValueNotifier] instead of setState.
///
/// Example:
/// ```dart
/// final controller = InteractiveContentCardController();
/// InteractiveContentCard(
///   controller: controller,
///   data: FeedContentAdapter(item),
///   onLike: (id, liked) async { /* ... */ },
///   onLoadInteractionCounts: fetchCounts,
/// );
/// // Later refresh counts
/// controller.patch(likeCount: 42);
/// ```
class InteractiveContentCard extends StatefulWidget {
  const InteractiveContentCard({
    super.key,
    required this.data,
    this.config = const InteractiveCardConfig(),
    this.onTap,
    this.onLike,
    this.onShare,
    this.onAuthenticationRequired,
    this.onParticipate,
    this.onLoadInteractionCounts,
    this.onCheckIsLiked,
    this.isLoading = false,
    this.enableLike = true,
    this.enableShare = true,
    this.enableComments = false,
    this.customDateFormatter,
    this.controller,
  });

  /// Content data to display (use a concrete adapter implementation like [FeedContentAdapter]).
  final InteractiveContent data;

  /// Visual configuration.
  final InteractiveCardConfig config;

  /// Loading skeleton state.
  final bool isLoading;

  /// Tap callback for entire card.
  final VoidCallback? onTap;

  /// Callback when like is toggled.
  final OnLikeCallback? onLike;

  /// Callback when share is triggered.
  final OnShareCallback? onShare;

  /// Callback when authentication is required (user not logged in).
  /// Use this to redirect the user to login screen.
  final OnAuthenticationRequiredCallback? onAuthenticationRequired;

  /// Callback when participate button is pressed (for eligible content types).
  final VoidCallback? onParticipate;

  /// Loads initial interaction counts.
  final OnLoadInteractionCountsCallback? onLoadInteractionCounts;

  /// Checks initial liked status.
  final OnCheckIsLikedCallback? onCheckIsLiked;

  /// Feature toggles.
  final bool enableLike;
  final bool enableShare;
  final bool enableComments;


  /// Optional custom date formatter.
  final String Function(DateTime)? customDateFormatter;

  /// Optional external controller for manual refresh.
  final InteractiveContentCardController? controller;

  /// Static loading card for shimmer effect.
  static Widget loading({InteractiveCardConfig? config}) => _InteractiveContentCardLoading(
        config: config ?? const InteractiveCardConfig(),
      );

  @override
  State<InteractiveContentCard> createState() => _InteractiveContentCardState();
}

class _InteractiveContentCardState extends State<InteractiveContentCard>
    with TickerProviderStateMixin {
  late final InteractiveContentCardController _controller;
  late final bool _ownsController;
  late AnimationController _likeAnimController;
  late Animation<double> _likeScaleAnim;

  ValueNotifier<InteractionViewState> get _state => _controller.state;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? InteractiveContentCardController();
    // Expose internal reload to external controller.
    _controller._reloadCounts = _loadInteractionCounts;
    _setupAnimations();
    _loadInteractionCounts();
  }

  Future<void> _loadInteractionCounts() async {
    if (widget.onLoadInteractionCounts == null || !mounted) return;

    _state.value = _state.value.copyWith(isLoadingCounts: true);

    try {
      final results = await Future.wait([
        widget.onLoadInteractionCounts!(widget.data.id),
        if (widget.onCheckIsLiked != null)
          widget.onCheckIsLiked!(widget.data.id)
        else
          Future.value(false),
      ]);

      if (!mounted) return; // Widget pudo ser desmontado mientras se esperaba.

      final counts = results[0] as InteractionCounts;
      final isLiked = results[1] as bool;

      _state.value = _state.value.copyWith(
        likeCount: counts.likes,
        shareCount: counts.shares,
        viewCount: counts.views,
        isLiked: isLiked,
      );
    } catch (e) {
      if (mounted) {
        StoyCoLogger.error('Error loading interaction counts: $e');
      }
    } finally {
      if (mounted) {
        _state.value = _state.value.copyWith(isLoadingCounts: false);
      }
    }
  }

  void _setupAnimations() {
    _likeAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _likeScaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _likeAnimController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(InteractiveContentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.id != widget.data.id) {
      _loadInteractionCounts();
    }
  }

  @override
  void dispose() {
    _likeAnimController.dispose();
    if (_ownsController) {
      _controller.dispose();
    } else {
      // Ensure we clear the internal callback when not owning controller to avoid leaks.
      _controller._reloadCounts = null;
    }
    super.dispose();
  }

  String _formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    String timeString;
    if (diff.inMinutes < 1) {
      timeString = 'ahora';
    } else if (diff.inMinutes < 60) {
      timeString = '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      timeString = '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      timeString = '${diff.inDays}d';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      timeString = weeks == 1 ? '1 semana' : '$weeks semanas';
    } else {
      timeString = '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    }
    if (widget.data.state == 'closed') {
      return 'Terminado hace $timeString';
    }
    return timeString;
  }


  /// Calculates the number of lines the title will occupy at runtime.
  int _getTitleLineCount(BuildContext context) {
    final textSpan = TextSpan(
      text: widget.data.title,
      style: TextStyle(
        fontSize: StoycoScreenSize.fontSize(context, widget.config.titleFontSize),
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
    );
    final tp = TextPainter(
      text: textSpan,
      maxLines: widget.config.titleMaxLines,
      textDirection: TextDirection.ltr,
    );
    // Use screen width minus card image height, spacing, and padding
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = StoycoScreenSize.width(context, widget.config.height);
    final spacing = StoycoScreenSize.width(context, widget.config.spacing);
    final padding = StoycoScreenSize.width(context, 32); // Approximate padding
    final maxWidth = screenWidth - imageWidth - spacing - padding;
    tp.layout(maxWidth: maxWidth);
    return tp.computeLineMetrics().length;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return InteractiveContentCard.loading(config: widget.config);
    }
    final showParticipateButton = widget.data is FeedContentAdapter &&
        (widget.data as FeedContentAdapter).feedType == FeedType.events &&
        widget.data.state == 'CREATED' ||  widget.data.state == 'PUBLISHED';

    return SizedBox(
      height: StoycoScreenSize.height(context, widget.config.height),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap != null ? () => widget.onTap!() : null,
              borderRadius: BorderRadius.circular(
                StoycoScreenSize.radius(context, widget.config.borderRadius),
              ),
              splashColor: StoycoColors.blue.withValues(alpha: 0.1),
              highlightColor: Colors.transparent,
              child: _buildContent(context),
            ),
          ),
          if (showParticipateButton)
            Positioned(
              left: StoycoScreenSize.width(context, widget.config.height + widget.config.spacing),
              bottom: StoycoScreenSize.height(
                context,
                _getTitleLineCount(context) == 2 ? 45 : 60,
              ),
              child: _buildParticipateButton(context),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final imageSize = constraints.maxHeight;
          return Row(
            children: [
              _buildImage(context, imageSize),
              Gap(StoycoScreenSize.width(context, widget.config.spacing)),
              Expanded(child: _buildInfo(context)),
            ],
          );
        },
      );

  Widget _buildImage(BuildContext context, double size) => Hero(
        tag: 'content_image_${widget.data.id}',
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  StoycoScreenSize.radius(context, widget.config.borderRadius),
                ),
                child: CoverImageWithFade(
                  imageUrl: widget.data.mainImage,
                  width: size,
                  height: size,
                  borderRadius: widget.config.borderRadius,
                ),
              ),
              if (widget.data is FeedContentAdapter &&
                  (widget.data as FeedContentAdapter).feedType == FeedType.announcement)
                Positioned(
                  top: StoycoScreenSize.height(context, 5),
                  left: StoycoScreenSize.width(context, 5),
                  child: Container(
                    padding: StoycoScreenSize.symmetric(
                      context,
                      horizontal: 14,
                      vertical: 3,
                      horizontalPhone: 12,
                      horizontalTablet: 12,
                    ),
                    decoration: BoxDecoration(
                      color: (widget.data.customData?['isPublished'] as bool? ?? false)
                          ? StoycoColors.lightViolet
                          : StoycoColors.hint.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: StoycoColors.shadowColor.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/megaphone_icon.svg',
                      width: StoycoScreenSize.width(context, 12),
                      height: StoycoScreenSize.width(context, 12),
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildInfo(BuildContext context) {
    final textColor = widget.config.textColor ?? StoycoColors.white2;
    return Padding(
      padding: StoycoScreenSize.symmetric(context, vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.data.title,
            style: TextStyle(
              color: textColor,
              fontSize: StoycoScreenSize.fontSize(context, widget.config.titleFontSize),
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            maxLines: widget.config.titleMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
          Gap(StoycoScreenSize.height(context, 5)),
          if (widget.data.publishDate != null)
            Text(
              _formatRelativeTime(widget.data.publishDate!),
              style: TextStyle(
                color: textColor,
                fontSize: StoycoScreenSize.fontSize(context, widget.config.dateFontSize),
              ),
            ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ReactiveSocialButtons(
                contentId: widget.data.id,
                contentTitle: widget.data.title,
                contentImageUrl: widget.data.mainImage,
                config: SocialButtonsConfig(
                  iconSize: widget.config.iconSize,
                  counterFontSize: widget.config.counterFontSize,
                  spacing: 15.0,
                  likedIconColor: widget.config.likedIconColor,
                  unlikedIconColor: widget.config.unlikedIconColor,
                  shareIconColor: widget.config.shareIconColor,
                ),
                onLoadCounts: widget.onLoadInteractionCounts,
                onCheckIsLiked: widget.onCheckIsLiked,
                onLike: widget.onLike,
                onShare: widget.onShare,
                onAuthenticationRequired: widget.onAuthenticationRequired,
                enableLike: widget.enableLike,
                enableShare: widget.enableShare,
                enableComments: widget.enableComments,
                textColor: textColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParticipateButton(BuildContext context) => Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xff253341),
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: widget.onParticipate,
            borderRadius: BorderRadius.circular(20),
            splashColor: StoycoColors.whiteLavender.withValues(alpha: 0.1),
            highlightColor: StoycoColors.whiteLavender.withValues(alpha: 0.05),
            child: Container(
              padding: StoycoScreenSize.symmetric(
                context,
                horizontal: 10,
                vertical: 5,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Participar',
                    style: TextStyle(
                      color: StoycoColors.whiteLavender,
                      fontSize: StoycoScreenSize.fontSize(context, 12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(StoycoScreenSize.width(context, 6)),
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: StoycoScreenSize.width(context, 16),
                    color: StoycoColors.whiteLavender,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

}


// Loading state widget shown while data is fetched.
class _InteractiveContentCardLoading extends StatelessWidget {
  const _InteractiveContentCardLoading({required this.config});
  final InteractiveCardConfig config;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: StoycoScreenSize.height(context, config.height),
        child: Row(
          children: [
            SkeletonCard(
              width: StoycoScreenSize.height(context, config.height),
              height: StoycoScreenSize.height(context, config.height),
              borderRadius: BorderRadius.circular(
                StoycoScreenSize.radius(context, config.borderRadius),
              ),
            ),
            Gap(StoycoScreenSize.width(context, config.spacing)),
            Expanded(
              child: Padding(
                padding: StoycoScreenSize.symmetric(context, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonCard(
                      width: double.infinity,
                      height: StoycoScreenSize.height(context, 24),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    Gap(StoycoScreenSize.height(context, 8)),
                    Row(
                      children: [
                        SkeletonCard(
                          width: StoycoScreenSize.width(context, 60),
                          height: StoycoScreenSize.height(context, 20),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        Gap(StoycoScreenSize.width(context, 20)),
                        SkeletonCard(
                          width: StoycoScreenSize.width(context, 60),
                          height: StoycoScreenSize.height(context, 20),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SkeletonCard(
                      width: StoycoScreenSize.width(context, 80),
                      height: StoycoScreenSize.height(context, 16),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
