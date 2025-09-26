import 'package:flutter/material.dart';

class CustomAuthDesignScreen extends StatelessWidget {
  const CustomAuthDesignScreen({
    super.key,
    required this.data,
    this.center = true,
  });
  final Widget data;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "asset/image/Bg.png",
            fit: BoxFit.cover,
          ),
        ),
        center
            ? Center(child: data)
            : Align(
                alignment: Alignment.topCenter,
                child: data,
              ),
      ],
    );
  }
}
