import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

/// A customizable interactive gradient container that can function as a panel or button.
///
/// This widget provides a visually appealing gradient container with hover and press
/// animations when used as a button. It can display an optional gradient border and
/// supports custom shadows, gradients, and padding.
///
/// ## Example usage as a panel:
/// ```dart
/// InteractiveGradientPanel(
///   showBorder: true,
///   borderRadiusValue: 12.0,
///   child: Text('Gradient Panel Content'),
/// )
/// ```
///
/// ## Example usage as a button:
/// ```dart
/// InteractiveGradientPanel(
///   isButton: true,
///   showBorder: true,
///   borderRadiusValue: 8.0,
///   onTap: () => print('Button pressed!'),
///   child: Text('Click Me'),
/// )
/// ```
class InteractiveGradientPanel extends StatefulWidget {
  /// Creates an interactive gradient panel.
  ///
  /// The [child] parameter is required and represents the content to be displayed
  /// inside the gradient container.
  const InteractiveGradientPanel({
    super.key,
    required this.child,
    this.boxShadow,
    this.gradient,
    this.padding =
        const EdgeInsets.symmetric(vertical: 8.84, horizontal: 28.34),
    this.showBorder = false,
    this.borderRadiusValue,
    this.isButton = false,
    this.onTap,
    this.disableOpacityAnimation = false,
  });

  /// The widget to be displayed inside the gradient container.
  final Widget child;

  /// Optional shadow effect for the container.
  ///
  /// If not provided, a default shadow will be applied when not in button mode.
  final List<BoxShadow>? boxShadow;

  /// Custom gradient to override the default background gradient.
  final Gradient? gradient;

  /// Padding applied to the container's content.
  ///
  /// Defaults to `EdgeInsets.symmetric(vertical: 8.84, horizontal: 28.34)`.
  final EdgeInsetsGeometry padding;

  /// Whether to show a gradient border around the container.
  ///
  /// When true, the container will have a gradient outline.
  final bool showBorder;

  /// The border radius value applied to the container.
  ///
  /// If null, no border radius will be applied (sharp corners).
  final double? borderRadiusValue;

  /// Whether the panel should behave like a button.
  ///
  /// When true, the panel will respond to hover and tap interactions with
  /// animations and cursor changes.
  final bool isButton;

  /// Callback function that is called when the button is tapped.
  ///
  /// Only used when [isButton] is true.
  final VoidCallback? onTap;

  /// Whether to disable the opacity animation.
  ///
  /// When true, the opacity will always be 1.0 regardless of hover state.
  final bool disableOpacityAnimation;

  @override
  State<InteractiveGradientPanel> createState() =>
      _InteractiveGradientPanelState();
}

/// The state for the [InteractiveGradientPanel] widget.
///
/// Manages hover and press states and animations for interactive effects.
class _InteractiveGradientPanelState extends State<InteractiveGradientPanel>
    with SingleTickerProviderStateMixin {
  /// Tracks whether the widget is currently being hovered.
  bool _isHovered = false;

  /// Tracks whether the widget is currently being pressed.
  bool _isPressed = false;

  /// Controller for the press animation.
  late AnimationController _animationController;

  /// Animation that scales the widget when pressed.
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget container = _buildBaseContainer();

    if (widget.isButton) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
            _isPressed = false;
          });
          _animationController.reverse();
        },
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) {
            setState(() {
              _isPressed = true;
            });
            _animationController.forward();
          },
          onTapUp: (_) {
            setState(() {
              _isPressed = false;
            });
            _animationController.reverse();
          },
          onTapCancel: () {
            setState(() {
              _isPressed = false;
            });
            _animationController.reverse();
          },
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: widget.disableOpacityAnimation
                    ? 1.0
                    : (_isHovered ? 1.0 : 0.9),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    boxShadow: _isPressed
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: _isHovered ? 8 : 4,
                              offset: _isHovered
                                  ? const Offset(0, 2)
                                  : const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: child,
                ),
              ),
            ),
            child: container,
          ),
        ),
      );
    }

    return container;
  }

  Widget _buildBaseContainer() => !widget.showBorder
      ? Container(
          decoration: BoxDecoration(
            gradient: widget.gradient ??
                const LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.05),
                    Color.fromRGBO(0, 0, 0, 0.15),
                    Color.fromRGBO(0, 0, 0, 0.25),
                  ],
                  stops: [0.0751, 0.5643, 0.6543],
                  transform: GradientRotation(0.23),
                ),
            borderRadius: BorderRadius.circular(widget.borderRadiusValue ?? 0),
            boxShadow: widget.isButton
                ? []
                : (widget.boxShadow ??
                    const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ]),
          ),
          padding: widget.padding,
          child: widget.child,
        )
      : OutlineGradientButton(
          gradient: LinearGradient(
            colors: [
              if (_isHovered)
                const Color.fromRGBO(255, 255, 255, 0.35)
              else
                const Color.fromRGBO(255, 255, 255, 0.25),
              const Color.fromRGBO(0, 0, 0, 0.25),
              const Color.fromRGBO(0, 0, 0, 0.25),
            ],
            stops: const [0.0751, 0.5643, 0.6543],
            transform: const GradientRotation(0.23),
          ),
          padding: EdgeInsets.zero,
          strokeWidth: _isHovered ? 1.5 : 1,
          radius: Radius.circular(widget.borderRadiusValue ?? 0),
          child: Container(
            decoration: BoxDecoration(
              gradient: widget.gradient ??
                  LinearGradient(
                    colors: _isHovered
                        ? const [
                            Color.fromRGBO(255, 255, 255, 0.1),
                            Color.fromRGBO(0, 0, 0, 0.2),
                            Color.fromRGBO(0, 0, 0, 0.3),
                          ]
                        : const [
                            Color.fromRGBO(255, 255, 255, 0.05),
                            Color.fromRGBO(0, 0, 0, 0.15),
                            Color.fromRGBO(0, 0, 0, 0.25),
                          ],
                    stops: const [0.0751, 0.5643, 0.6543],
                    transform: const GradientRotation(0.23),
                  ),
              borderRadius:
                  BorderRadius.circular(widget.borderRadiusValue ?? 0),
              boxShadow: widget.isButton
                  ? []
                  : (widget.boxShadow ??
                      const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ]),
            ),
            padding: widget.padding,
            child: widget.child,
          ),
        );
}
