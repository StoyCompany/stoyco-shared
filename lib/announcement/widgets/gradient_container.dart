import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class InteractiveGradientPanel extends StatefulWidget {
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
  });
  final Widget child;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final EdgeInsetsGeometry padding;
  final bool showBorder;
  final double? borderRadiusValue;
  final bool isButton;
  final VoidCallback? onTap;

  @override
  State<InteractiveGradientPanel> createState() =>
      _InteractiveGradientPanelState();
}

class _InteractiveGradientPanelState extends State<InteractiveGradientPanel>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _animationController;
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
                opacity: _isHovered ? 1.0 : 0.9,
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
                Color.fromRGBO(255, 255, 255, 0.35)
              else
                Color.fromRGBO(255, 255, 255, 0.25),
              Color.fromRGBO(0, 0, 0, 0.25),
              Color.fromRGBO(0, 0, 0, 0.25),
            ],
            stops: [0.0751, 0.5643, 0.6543],
            transform: GradientRotation(0.23),
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
                    stops: [0.0751, 0.5643, 0.6543],
                    transform: GradientRotation(0.23),
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
