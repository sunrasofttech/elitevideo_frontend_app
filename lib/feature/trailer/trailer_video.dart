import 'package:easy_localization/easy_localization.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/trailer/get_all_trailer/get_all_trailer_model.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_video_player.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';

class TrailerVideoDesc extends StatefulWidget {
  const TrailerVideoDesc({super.key, required this.model});
  final Trailor model;

  @override
  State<TrailerVideoDesc> createState() => _TrailerVideoDescState();
}

class _TrailerVideoDescState extends State<TrailerVideoDesc> with Utility {
  @override
  void initState() {
    FlutterWindowManagerPlus.addFlags(FlutterWindowManagerPlus.FLAG_SECURE);
    super.initState();
  }

  @override
  void dispose() {
    FlutterWindowManagerPlus.clearFlags(FlutterWindowManagerPlus.FLAG_SECURE);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined, color: AppColor.whiteColor),
          ),
          title: TextWidget(text: "${widget.model.movieName}", fontSize: 15),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    child: CustomVideoPlayer(
                      audioUrl: "${AppUrls.baseUrl}/${widget.model.trailorVideo ?? ""}",
                      handleOnChanged: (int watchTime, {bool isWatched = false}) {},
                    ),
                  ),
                ),
                sb20h(),
                sb10h(),
                TextWidget(text: "Description".tr()),
                sb10h(),
                Html(
                  data: widget.model.description ?? "",
                  style: {"body": Style(fontSize: FontSize(14.0), color: AppColor.whiteColor)},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
