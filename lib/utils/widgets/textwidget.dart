import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite/constant/app_colors.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    this.text,
    this.fontSize,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.letterSpacing,
    this.textOverflow,
    this.textDecoration,
    this.style,
    this.maxlines,
  });
  final String? text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final Color? color;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final TextOverflow? textOverflow;
  final TextStyle? style;
  final int? maxlines;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      text ?? "",
      overflow: textOverflow,
      maxLines: maxlines,
      style: style ??
          GoogleFonts.poppins(
            decoration: textDecoration,
            fontSize: fontSize ?? 12,
            fontWeight: fontWeight,
            color: color ?? AppColor.whiteColor,
            letterSpacing: letterSpacing,
          ),
    );
  }
}
