import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class CustomCachedCard extends StatelessWidget {
  final double height;
  final double width;
  final String imageUrl;

  const CustomCachedCard({
    super.key,
    required this.height,
    required this.width,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: height,
          width: width,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: CustomCircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Center(
            child: TextWidget(
              text: "No Img Found 😒",
              color: AppColor.redColor,
            ),
          ),
        ),
      ),
    );
  }
}
