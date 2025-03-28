import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:stoyco_shared/design/screen_size.dart';

/// A customized segmented control widget that provides animated switching between options.
///
/// This widget displays a horizontal list of options (typically two) where users can
/// toggle between them. The selected option is highlighted with a purple gradient background.
/// The selection changes with a smooth animation.
///
/// Example:
/// ```dart
/// StoycoContentSwitch(
///   options: ['Option 1', 'Option 2'],
///   onIndexChanged: (index) => print('Selected index: $index'),
///   onItemChanged: (index, item) => print('Selected $item at index $index'),
/// )
/// ```
class StoycoContentSwitch extends StatefulWidget {
  /// Creates a StoycoContentSwitch.
  ///
  /// The [options] list must contain at least two items.
  ///
  /// The [initialIndex] determines which option is selected initially.
  /// It must be less than the length of [options].
  ///
  /// The [width] parameter sets the total width of the widget on desktop.
  /// For mobile and tablet, the width will be adjusted automatically.
  const StoycoContentSwitch({
    super.key,
    this.options = const ['Noticias', 'Convocatorias'],
    this.onIndexChanged,
    this.onItemChanged,
    this.initialIndex = 0,
    this.width = 528,
  }) : assert(options.length >= 2, 'Se requieren al menos dos opciones');

  /// The list of options to display.
  ///
  /// Each string in this list represents one selectable option.
  final List<String> options;

  /// Callback that is called when an option is selected.
  ///
  /// The callback is passed the index of the selected option.
  final void Function(int)? onIndexChanged;

  /// Callback that is called when an option is selected, providing both index and text.
  ///
  /// The callback is passed the index of the selected option and its text value.
  final void Function(int, String)? onItemChanged;

  /// The initial selected index.
  ///
  /// Defaults to 0, which selects the first option.
  final int initialIndex;

  /// The total width of the widget.
  ///
  /// Defaults to 528 pixels, but can be adjusted for different layouts.
  final double width;

  @override
  State<StoycoContentSwitch> createState() => _StoycoContentSwitchState();
}

class _StoycoContentSwitchState extends State<StoycoContentSwitch>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late int _previousIndex;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _previousIndex = widget.initialIndex;

    // Configurar el controlador de animación
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Constantes para reutilizar
  static const _purpleGradientColors = [Color(0xFF1C197F), Color(0xFF4639E7)];

  static const _containerGradientColors = [
    Color.fromRGBO(255, 255, 255, 0.25),
    Color.fromRGBO(0, 0, 0, 0.25),
    Color.fromRGBO(0, 0, 0, 0.25),
  ];

  static const _containerGradientStops = [0.07, 0.56, 0.65];

  static const _borderGradientColors = [
    Color.fromRGBO(255, 255, 255, 0.23),
    Color.fromRGBO(255, 255, 255, 0.07),
  ];

  static const _borderGradientStops = [0.0, 1.0];

  // Widget para crear una opción del switch
  Widget _buildSwitchOption(int index, String text) => Expanded(
        child: GestureDetector(
          onTap: () {
            if (_selectedIndex != index) {
              setState(() {
                _previousIndex = _selectedIndex;
                _selectedIndex = index;
              });
              _animationController.forward(from: 0.0);
              widget.onIndexChanged?.call(index);
              widget.onItemChanged?.call(index, widget.options[index]);
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              alignment: Alignment.center,
              child: _buildOptionText(text),
            ),
          ),
        ),
      );

  // Widget para el texto de las opciones
  Widget _buildOptionText(String text) => Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: StoycoScreenSize.fontSize(
            context,
            16,
            phone: 12,
            tablet: 14,
            desktopLarge: 16,
          ),
          shadows: const <Shadow>[
            Shadow(
              blurRadius: 3.0,
              color: Color(0xffF8F9FA),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    // Calculate responsive width based on screen size
    final responsiveWidth = StoycoScreenSize.width(
      context,
      widget.width,
      phone: widget.width * 0.5,
      tablet: widget.width * 0.8,
    );

    // Calculate responsive height based on screen size
    final responsiveHeight = StoycoScreenSize.height(
      context,
      41,
      phone: 30,
      tablet: 38,
    );

    // Calculate responsive stroke width
    final strokeWidth = StoycoScreenSize.width(
      context,
      1,
      phone: 0.5,
      tablet: 0.75,
    );

    return OutlineGradientButton(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: _borderGradientColors,
        stops: _borderGradientStops,
      ),
      radius: Radius.circular(StoycoScreenSize.radius(context, 100)),
      strokeWidth: strokeWidth,
      padding: EdgeInsets.all(strokeWidth),
      child: Container(
        height: responsiveHeight,
        width: responsiveWidth,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _containerGradientColors,
            stops: _containerGradientStops,
          ),
          borderRadius:
              BorderRadius.circular(StoycoScreenSize.radius(context, 100)),
        ),
        child: Stack(
          children: [
            // Animated sliding background
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                // Calculate the position of the slider
                final optionWidth = responsiveWidth / widget.options.length;
                final startPosition = _previousIndex * optionWidth;
                final endPosition = _selectedIndex * optionWidth;
                final currentPosition = startPosition +
                    (endPosition - startPosition) * _animation.value;

                return Positioned(
                  left: currentPosition,
                  top: 0,
                  bottom: 0,
                  width: optionWidth,
                  child: OutlineGradientButton(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _purpleGradientColors,
                      stops: _borderGradientStops,
                    ),
                    radius: Radius.circular(
                      StoycoScreenSize.radius(context, 100),
                    ),
                    strokeWidth: strokeWidth,
                    padding: EdgeInsets.all(strokeWidth),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: _purpleGradientColors,
                          stops: _borderGradientStops,
                        ),
                        borderRadius: BorderRadius.circular(
                          StoycoScreenSize.radius(context, 100),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Options row
            Row(
              children: List.generate(
                widget.options.length,
                (index) => _buildSwitchOption(index, widget.options[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
