import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_auth_design.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class CustomHtmlScreen extends StatefulWidget {
  const CustomHtmlScreen({super.key, required this.title, required this.data});
  final String title;
  final String data;

  @override
  State<CustomHtmlScreen> createState() => _CustomHtmlScreenState();
}

class _CustomHtmlScreenState extends State<CustomHtmlScreen> with Utility {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomAuthDesignScreen(
          center: false,
          data: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppColor.backgroundGreyColor,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextWidget(
                      text: widget.title,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                sb30h(),
                Html(
                  data: widget.data,
                  style: {
                    "*": Style(
                      color: AppColor.whiteColor,
                    ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
