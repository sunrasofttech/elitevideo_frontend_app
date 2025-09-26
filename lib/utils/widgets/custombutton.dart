import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:elite/constant/app_colors.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool inProgress;
  final bool showAnimation;

  const GradientButton({
    super.key,
    required this.text,
    this.onTap,
    this.height,
    this.showAnimation = true,
    this.inProgress = false,
    this.width,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    if (widget.showAnimation) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      )..repeat(reverse: true);

      _animation = CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showAnimation && _animation != null) {
      // With animation
      return GestureDetector(
        onTap: widget.inProgress ? null : widget.onTap,
        child: AnimatedBuilder(
          animation: _animation!,
          builder: (context, child) {
            return _buildButton(_animation!.value);
          },
        ),
      );
    } else {
      // Without animation
      return GestureDetector(
        onTap: widget.inProgress ? null : widget.onTap,
        child: _buildButton(1), // fixed value
      );
    }
  }

  Widget _buildButton(double animValue) {
    return Container(
      width: widget.width,
      height: widget.height ?? 52,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.5 + animValue * 0.5),
            Colors.purple.withOpacity(0.5 + animValue * 0.5),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 20 * animValue,
            spreadRadius: 3 * animValue,
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 15 + animValue * 5,
                sigmaY: 15 + animValue * 5,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Center(
              child: widget.inProgress
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.whiteColor,
                      ),
                    )
                  : Text(
                      widget.text,
                      style: const TextStyle(
                        color: AppColor.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}