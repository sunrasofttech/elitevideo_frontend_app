import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_local_player.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class LocalPlayer extends StatefulWidget {
  const LocalPlayer({
    super.key,
    required this.movieName,
    required this.localVideoPath,
    required this.description,
  });
  final String movieName;
  final String localVideoPath;
  final String description;

  @override
  State<LocalPlayer> createState() => _LocalPlayerState();
}

class _LocalPlayerState extends State<LocalPlayer> with Utility {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColor.whiteColor,
          ),
        ),
        title: TextWidget(
          text: widget.movieName,
          fontSize: 15,
        ),
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
                  child: CustomLocalPlayer(
                    audioUrl: widget.localVideoPath,
                  ),
                ),
              ),
              sb15h(),
              Html(
                data: widget.description,
                style: {
                  "body": Style(
                    fontSize: FontSize(14.0),
                    color: AppColor.whiteColor,
                  ),
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
