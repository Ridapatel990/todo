import 'package:flutter/material.dart';

/// A custom button widget.
class AppButton extends StatefulWidget {
  /// Constructor for [AppButton].
  const AppButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.color,
    this.textColor,
    this.width,
    this.borderColor,
    this.heroTag,
    this.borderRadius,
  });

  /// The child widget to be displayed inside the button.
  final Widget child;

  /// The hero tag for the button.
  final String? heroTag;

  /// The width of the button.
  final double? width;

  /// The function to be called when the button is pressed.
  final void Function() onPressed;

  /// The color of the button.
  final Color? color;

  /// The color of the text inside the button.
  final Color? textColor;

  /// The color of the border of the button.
  final Color? borderColor;

  /// Border Radius of the button
  final BorderRadius? borderRadius;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> _size;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    _size = Tween<double>(
      begin: widget.width ?? mediaQuery.size.width * 0.8,
      end:
          (widget.width ?? mediaQuery.size.width * 0.8) -
          ((widget.width ?? mediaQuery.size.width * 0.8) * 0.05),
    ).animate(_controller);
    return Hero(
      tag: widget.heroTag ?? UniqueKey(),
      child: Material(
        type: MaterialType.transparency,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale:
                  _size.value / (widget.width ?? (mediaQuery.size.width * 0.8)),
              child: InkWell(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                onTapDown: (d) {
                  _controller.forward();
                },
                onTapUp: (d) {
                  _controller.reverse();
                },
                onTapCancel: () {
                  _controller.reverse();
                },
                onTap: widget.onPressed,
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: widget.textColor ?? theme.colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  child: Container(
                    height: 60,
                    width: widget.width ?? (mediaQuery.size.width * 0.8),
                    decoration: BoxDecoration(
                      color: widget.color ?? theme.primaryColor,
                      borderRadius:
                          widget.borderRadius ?? BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.borderColor ?? Colors.transparent,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: widget.child,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
