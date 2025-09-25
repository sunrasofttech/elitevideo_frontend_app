import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/feature/home_screen/bloc/get_live_tv/get_live_tv_model.dart';
import 'package:elite/feature/profile/ui/subscription/subscription_screen.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_video_player.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class LiveTvDesc extends StatefulWidget {
  const LiveTvDesc({super.key, required this.model, required this.isTrailer, this.lastPosition});
  final Channel? model;
  final bool isTrailer;
  final int? lastPosition;

  @override
  State<LiveTvDesc> createState() => _LiveTvDescState();
}

class _LiveTvDescState extends State<LiveTvDesc> with Utility {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
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
            child: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppColor.whiteColor,
            ),
          ),
          title: TextWidget(
            text: "${widget.model?.name}",
            fontSize: 15,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.model?.is_livetv_on_rent ?? true
                    ? Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              image: DecorationImage(
                                image: NetworkImage("${widget.model?.coverImg}"),
                              ),
                            ),
                          ),
                          sb15h(),
                          GradientButton(
                            height: 48,
                            text: 'Subscribe'.tr(),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SubscriptionScreen(),
                                  ));
                            },
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomVideoPlayer(
                          lastPosition: widget.lastPosition,
                          isLive: true,
                          // ads: widget.model?.channelAds ?? [],
                          audioUrl: widget.model?.androidChannelUrl ?? "",
                          handleOnChanged: (watchTime, {isWatched = false}) {},
                        ),
                      ),
                sb20h(),
                sb20h(),
                sb10h(),
                TextWidget(
                  text: "Description".tr(),
                ),
                sb10h(),
                Html(
                  data: widget.model?.description,
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
      ),
    );
  }
}
