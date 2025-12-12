import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_interaction_content/stoyco_interaction_content.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/services/social_interaction_service.dart';
import 'package:stoyco_shared/stoyco_shared.dart';

/// Callback definitions for social button interactions.
typedef OnSocialLikeCallback = Future<void> Function(String contentId, bool isLiked);
typedef OnSocialShareCallback = Future<void> Function({
  required String contentId,
  required String title,
  required String imageUrl,
});
typedef OnLoadSocialCountsCallback = Future<InteractionCounts> Function(String contentId);
typedef OnCheckSocialIsLikedCallback = Future<bool> Function(String contentId);
typedef OnAuthenticationRequiredCallback = void Function();
typedef  OnTapCallback = void Function(String contentId);

/// Configuration for social buttons appearance.
class SocialButtonsConfig {
  const SocialButtonsConfig({
    this.iconSize = 20.0,
    this.counterFontSize = 12.0,
    this.spacing = 15.0,
    this.likedIconColor,
    this.unlikedIconColor,
    this.shareIconColor,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final double iconSize;
  final double counterFontSize;
  final double spacing;
  final Color? likedIconColor;
  final Color? unlikedIconColor;
  final Color? shareIconColor;
  final Duration animationDuration;
}

/// Immutable state for social interactions.
class SocialInteractionState {
  const SocialInteractionState({
    this.isLiked = false,
    this.likeCount = 0,
    this.shareCount = 0,
    this.commentCount = 0,
    this.viewCount = 0,
    this.isLoading = false,
    this.processingLike = false,
    this.processingShare = false,
  });

  final bool isLiked;
  final int likeCount;
  final int shareCount;
  final int commentCount;
  final int viewCount;
  final bool isLoading;
  final bool processingLike;
  final bool processingShare;

  SocialInteractionState copyWith({
    bool? isLiked,
    int? likeCount,
    int? shareCount,
    int? commentCount,
    int? viewCount,
    bool? isLoading,
    bool? processingLike,
    bool? processingShare,
  }) =>
      SocialInteractionState(
        isLiked: isLiked ?? this.isLiked,
        likeCount: likeCount ?? this.likeCount,
        shareCount: shareCount ?? this.shareCount,
        commentCount: commentCount ?? this.commentCount,
        viewCount: viewCount ?? this.viewCount,
        isLoading: isLoading ?? this.isLoading,
        processingLike: processingLike ?? this.processingLike,
        processingShare: processingShare ?? this.processingShare,
      );
}

/// Controller for managing social button state externally.
///
/// This allows parent widgets to control and react to state changes.
class SocialButtonsController extends ChangeNotifier {
  SocialButtonsController([SocialInteractionState initial = const SocialInteractionState()])
      : _state = initial;

  SocialInteractionState _state;
  SocialInteractionState get state => _state;

  /// Updates the entire state and notifies listeners.
  void updateState(SocialInteractionState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  /// Patches specific fields of the current state.
  void patch({
    bool? isLiked,
    int? likeCount,
    int? shareCount,
    int? commentCount,
    int? viewCount,
    bool? isLoading,
    bool? processingLike,
    bool? processingShare,
  }) {
    updateState(
      _state.copyWith(
        isLiked: isLiked,
        likeCount: likeCount,
        shareCount: shareCount,
        commentCount: commentCount,
        viewCount: viewCount,
        isLoading: isLoading,
        processingLike: processingLike,
        processingShare: processingShare,
      ),
    );
  }

  /// Resets the state to initial values.
  void reset() {
    updateState(const SocialInteractionState());
  }
}

/// A reactive social buttons widget that independently manages its interaction state.
///
/// This widget can be used standalone and will automatically update when:
/// - User authentication state changes
/// - Interaction counts are updated
/// - Like/share actions are performed
///
/// Example:
/// ```dart
/// ReactiveSocialButtons(
///   contentId: 'content_123',
///   contentTitle: 'My Content',
///   contentImageUrl: 'https://...',
///   onLoadCounts: (id) async => await fetchCounts(id),
///   onCheckIsLiked: (id) async => await checkLiked(id),
///   onLike: (id, isLiked) async => await handleLike(id, isLiked),
///   onShare: ({contentId, title, imageUrl}) async => await share(contentId),
/// )
/// ```
class ReactiveSocialButtons extends StatefulWidget {
  const ReactiveSocialButtons({
    super.key,
    required this.contentId,
    required this.contentTitle,
    required this.contentImageUrl,
    this.config = const SocialButtonsConfig(),
    this.onLoadCounts,
    this.onCheckIsLiked,
    this.onLike,
    this.onShare,
    this.onCommentTap,
    this.onAuthenticationRequired,
    this.controller,
    this.enableLike = true,
    this.enableShare = true,
    this.enableComments =false,
    this.textColor,
    this.autoLoadOnInit = true,
  });

  /// Unique identifier for the content.
  final String contentId;

  /// Title of the content (for sharing).
  final String contentTitle;

  /// Image URL of the content (for sharing).
  final String contentImageUrl;

  /// Visual configuration.
  final SocialButtonsConfig config;

  /// Callback to load interaction counts.
  final OnLoadSocialCountsCallback? onLoadCounts;

  /// Callback to check if user has liked the content.
  final OnCheckSocialIsLikedCallback? onCheckIsLiked;

  /// Callback when like button is pressed.
  final OnSocialLikeCallback? onLike;

  /// Callback when share button is pressed.
  final OnSocialShareCallback? onShare;

  /// Callback when comment button is pressed.
  final OnTapCallback? onCommentTap;

  /// Callback when authentication is required (user not logged in).
  /// Use this to redirect the user to login screen.
  final OnAuthenticationRequiredCallback? onAuthenticationRequired;

  /// Optional external controller for state management.
  final SocialButtonsController? controller;

  /// Feature toggles.
  final bool enableLike;
  final bool enableShare;
  final bool enableComments;
  /// Text color for buttons.

  /// Base text color for buttons.
  final Color? textColor;

  /// Whether to automatically load counts on initialization.
  final bool autoLoadOnInit;

  @override
  State<ReactiveSocialButtons> createState() => _ReactiveSocialButtonsState();
}

class _ReactiveSocialButtonsState extends State<ReactiveSocialButtons>
    with SingleTickerProviderStateMixin {
  late final SocialButtonsController _controller;
  late final bool _ownsController;
  late AnimationController _likeAnimController;
  late Animation<double> _likeScaleAnim;
  VoidCallback? _removeAuthListener;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? SocialButtonsController();
    _setupAnimations();
    _setupAuthListener();

    if (widget.autoLoadOnInit) {
      _loadInteractionData();
    }
  }

  void _setupAuthListener() {
    // Listen to authentication changes and reload data automatically
    _removeAuthListener = SocialInteractionService.instance.addAuthListener(() {
      if (mounted) {
        _loadInteractionData();
      }
    });
  }

  void _setupAnimations() {
    _likeAnimController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );
    _likeScaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _likeAnimController, curve: Curves.elasticOut),
    );
  }

  /// Public method to reload interaction data.
  /// Can be called by parent widgets or when authentication state changes.
  Future<void> reload() async {
    await _loadInteractionData();
  }

  Future<void> _loadInteractionData() async {
    if (!mounted) return;

    _controller.patch(isLoading: true);

    try {
      final results = await Future.wait([
        if (widget.onLoadCounts != null)
          widget.onLoadCounts!(widget.contentId)
        else
          Future.value(const InteractionCounts(likes: 0, shares: 0, views: 0)),
        if (widget.onCheckIsLiked != null)
          widget.onCheckIsLiked!(widget.contentId)
        else
          Future.value(false),
      ]);

      if (!mounted) return;

      final counts = results[0] as InteractionCounts;
      final isLiked = results[1] as bool;

      _controller.updateState(
        SocialInteractionState(
          likeCount: counts.likes,
          shareCount: counts.shares,
          viewCount: counts.views,
          commentCount: counts.comments,
          isLiked: isLiked,
          isLoading: false,
        ),
      );
    } catch (e) {
      if (mounted) {
        StoyCoLogger.error('Error loading social interaction data: $e');
        _controller.patch(isLoading: false);
      }
    }
  }

  Future<void> _handleLike() async {
    if (!mounted || !widget.enableLike || _controller.state.processingLike) {
      return;
    }

    // Check authentication before processing
    if (!SocialInteractionService.instance.isAuthenticated) {
      StoyCoLogger.info('User not authenticated, triggering authentication required callback');
      widget.onAuthenticationRequired?.call();
      return;
    }

    _controller.patch(processingLike: true);
    final newLikedState = !_controller.state.isLiked;

    try {
      await widget.onLike?.call(widget.contentId, newLikedState);

      if (!mounted) return;

      final updatedLikeCount = _controller.state.likeCount + (newLikedState ? 1 : -1);
      _controller.patch(
        isLiked: newLikedState,
        likeCount: updatedLikeCount < 0 ? 0 : updatedLikeCount,
        processingLike: false,
      );

      if (newLikedState && mounted) {
        await _likeAnimController.forward();
        if (mounted) await _likeAnimController.reverse();
      }
    } catch (e) {
      if (mounted) {
        StoyCoLogger.error('Error handling like: $e');
        _controller.patch(processingLike: false);
      }
    }
  }

  Future<void> _handleShare() async {
    if (!mounted || !widget.enableShare || _controller.state.processingShare) {
      return;
    }

    // Check authentication before processing
    if (!SocialInteractionService.instance.isAuthenticated) {
      StoyCoLogger.info('User not authenticated, triggering authentication required callback');
      widget.onAuthenticationRequired?.call();
      return;
    }

    _controller.patch(processingShare: true);

    try {
      await widget.onShare?.call(
        contentId: widget.contentId,
        title: widget.contentTitle,
        imageUrl: widget.contentImageUrl,
      );

      if (!mounted) return;

      _controller.patch(
        shareCount: _controller.state.shareCount + 1,
        processingShare: false,
      );
    } catch (e) {
      if (mounted) {
        StoyCoLogger.error('Error sharing: $e');
        _controller.patch(processingShare: false);
      }
    }
  }

  void _handleCommentTap() {
    if (!mounted) {
      return;
    }
    // Check authentication before processing
    if (!SocialInteractionService.instance.isAuthenticated) {
      StoyCoLogger.info('User not authenticated, triggering authentication required callback');
      widget.onAuthenticationRequired?.call();
      return;
    }

    widget.onCommentTap?.call(widget.contentId);
  }

  @override
  void didUpdateWidget(ReactiveSocialButtons oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reload if content ID changes
    if (oldWidget.contentId != widget.contentId) {
      _loadInteractionData();
    }
  }

  @override
  void dispose() {
    _removeAuthListener?.call();
    _likeAnimController.dispose();
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final state = _controller.state;
        final baseColor = widget.textColor ?? StoycoColors.white;

        if (state.isLoading) {
          return _buildLoadingState(context);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.enableLike)
              _SocialActionButton(
                icon: state.isLiked ? Icons.favorite : Icons.favorite_border,
                count: state.likeCount,
                color: state.isLiked
                    ? (widget.config.likedIconColor ?? StoycoColors.white)
                    : (widget.config.unlikedIconColor ?? baseColor),
                onPressed: _handleLike,
                isProcessing: state.processingLike,
                animation: state.isLiked ? _likeScaleAnim : null,
                config: widget.config,
              ),
            if (widget.enableComments) ...[
              Gap(StoycoScreenSize.width(context, widget.config.spacing)),
              _SocialActionButton(
                svgAsset: 'packages/stoyco_shared/lib/assets/icons/bubble-chat.svg',
                count: state.commentCount,
                color: baseColor,
                onPressed: _handleCommentTap,
                isProcessing: false,
                config: widget.config,
              ),
            ],
            if (widget.enableLike && widget.enableShare)
              Gap(StoycoScreenSize.width(context, widget.config.spacing)),
            if (widget.enableShare)
              _SocialActionButton(
                svgAsset: 'packages/stoyco_shared/lib/assets/icons/share_outlined_icon.svg',
                count: state.shareCount,
                color: widget.config.shareIconColor ?? baseColor,
                onPressed: _handleShare,
                isProcessing: state.processingShare,
                config: widget.config,
              ),
          ],
        );
      },
    );

  Widget _buildLoadingState(BuildContext context) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.enableLike)
          SizedBox(
            width: 60,
            height: 24,
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: widget.textColor ?? StoycoColors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        if (widget.enableLike && widget.enableShare)
          Gap(StoycoScreenSize.width(context, widget.config.spacing)),
        if (widget.enableShare)
          SizedBox(
            width: 60,
            height: 24,
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: widget.textColor ?? StoycoColors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
      ],
    );
}

/// Internal widget for individual social action buttons.
class _SocialActionButton extends StatelessWidget {
  const _SocialActionButton({
    this.icon,
    this.svgAsset,
    required this.count,
    required this.color,
    required this.onPressed,
    required this.isProcessing,
    required this.config,
    this.animation,
  }) : assert(icon != null || svgAsset != null, 'Either icon or svgAsset must be provided');

  final IconData? icon;
  final String? svgAsset;
  final int count;
  final Color color;
  final VoidCallback onPressed;
  final bool isProcessing;
  final Animation<double>? animation;
  final SocialButtonsConfig config;

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;

    if (svgAsset != null) {
      iconWidget = SvgPicture.asset(
        svgAsset!,
        width: StoycoScreenSize.width(context, config.iconSize),
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else {
      iconWidget = Icon(
        icon!,
        size: StoycoScreenSize.width(context, config.iconSize),
        color: color,
      );
    }

    if (animation != null) {
      iconWidget = AnimatedBuilder(
        animation: animation!,
        builder: (_, child) => Transform.scale(
          scale: animation!.value,
          child: child,
        ),
        child: iconWidget,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isProcessing ? null : onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              Gap(StoycoScreenSize.width(context, 8)),
              Text(
                _formatCount(count),
                style: TextStyle(
                  color: color,
                  fontSize: StoycoScreenSize.fontSize(context, config.counterFontSize),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
