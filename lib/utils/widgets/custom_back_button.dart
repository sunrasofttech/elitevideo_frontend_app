import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color iconColor;

  const CustomBackButton({
    super.key,
    this.onTap,
    this.backgroundColor = const Color(0xFF2C2C2C),
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: iconColor,
          size: 18,
        ),
      ),
    );
  }
}