import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/home_screen/bloc/post_watchlist/post_watchlist_cubit.dart';
import 'package:elite/feature/profile/bloc/get_watchlist/get_watchlist_cubit.dart';
import 'package:elite/model/short_film.dart' as models;
import 'package:lottie/lottie.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_image.dart';
import 'package:elite/constant/app_string.dart';
import 'package:elite/custom_model/short_film_model.dart';
import 'package:elite/feature/home_screen/bloc/check_rental/check_rental_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_like/get_like_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_short_film_castcrew/get_short_film_castcrew_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_shortfilm_id/get_shortfilm_by_id_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_continue_watching/post_continue_watching_cubit.dart';
import 'package:elite/model/genre.dart' as genre;
import 'package:elite/feature/home_screen/bloc/post_rent/post_rent_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_report/post_report_cubit.dart';
import 'package:elite/feature/home_screen/bloc/shortfilm-rating/get_short_film_rating_by_id/get_short_film_rating_by_id_cubit.dart';
import 'package:elite/feature/home_screen/bloc/shortfilm-rating/short_film_rate/short_film_rate_cubit.dart';
import 'package:elite/feature/home_screen/ui/short_film/video_descrption.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_cubit.dart';
import 'package:elite/feature/profile/ui/subscription/subscription_screen.dart';
import 'package:elite/main.dart';
import 'package:elite/payment/cashfree_screen.dart';
import 'package:elite/payment/razorpay_payment.dart';
import 'package:elite/payment/upi_payment.dart';
import 'package:elite/utils/storage/hive_db.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_back_button.dart';
import 'package:elite/utils/widgets/custom_video_player.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// ignore: must_be_immutable
class ShortFilmDetailScreen extends StatefulWidget {
  ShortFilmDetailScreen({super.key, required this.id, this.isFromRental = false, this.lastPosition});
  final String id;
  int? lastPosition;
  bool isFromRental;

  @override
  State<ShortFilmDetailScreen> createState() => _ShortFilmDetailScreenState();
}

class _ShortFilmDetailScreenState extends State<ShortFilmDetailScreen> with Utility {
  double rating = 3;
  String? selectedReason;
  bool isLiked = false;
  bool isDisliked = false;

  @override
  void initState() {
    context.read<GetShortFilmCastcrewCubit>().getCastCrew(movieId: widget.id);
    context.read<GetShortFilmRatingByIdCubit>().getShortFilmRating(widget.id);
    context.read<GetShortfilmByIdCubit>().getShortFilm(widget.id);
    context.read<CheckRentalCubit>().checkRental(type: ContentType.shortfilm, typeId: widget.id);
    _checkIfDownloaded();
    super.initState();
  }

  bool shouldShowDownload = false;

  double _downloadProgress = 0.0;
  bool _isDownloading = false;
  bool _isDownloaded = false;
  PostContinueWatchingCubit? _watchingCubit;
  Future<void> _downloadVideo({required models.ShortFilm movie}) async {
    try {
      setState(() {
        _isDownloading = true;
      });
      final dir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().microsecondsSinceEpoch}.mp4';
      final imageFileName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
      final videoFilePath = '${dir.path}/$fileName';
      final imageFilePath = '${dir.path}/$imageFileName';

      await Dio().download(
        movie.shortVideo?.contains("https") ?? false
            ? "${AppUrls.baseUrl}/${movie.shortVideo}"
            : "${AppUrls.baseUrl}/${movie.shortVideo}",
        videoFilePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      await Dio().download(
        "${movie.posterImg}",
        imageFilePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      movie.localVideoPath = videoFilePath;
      movie.localImagePath = imageFilePath;
      await HiveDb.saveShortFilVideo(movie);
      setState(() {
        _isDownloading = false;
        _isDownloaded = true;
      });
      AppToast.showSuccess(context, "Download", "Download Successfully".tr());
    } catch (e) {
      AppToast.showError(context, "Download", "Download Failed $e");
    }
  }

  @override
  void dispose() {
    // context.read<GetContinueWatchingCubit>().getContinueWatching();
    FlutterWindowManagerPlus.clearFlags(FlutterWindowManagerPlus.FLAG_SECURE);
    super.dispose();
  }

  void _checkIfDownloaded() {
    final id = widget.id;
    _isDownloaded = HiveDb.isShortFilmDownloaded(id);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _watchingCubit = context.read<PostContinueWatchingCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(63, 173, 213, 1).withOpacity(0.3),
      body: BlocListener<CheckRentalCubit, CheckRentalState>(
        listener: (context, state) {
          if (state is CheckRentalLoadedState) {
            widget.isFromRental = true;
            setState(() {});
          }
        },
        child: BlocConsumer<GetShortfilmByIdCubit, GetShortfilmByIdState>(
          listener: (context, state) {
            if (state is GetShortfilmByIdLoadedState) {
              shouldShowDownload =
                  widget.isFromRental == true ||
                  (state.model.data?.isMovieOnRent == false &&
                      (!isUserSubscribed && state.model.data?.showSubscription == true) == false);
              setState(() {});
              context.read<GetLikeCubit>().getLike(typeId: widget.id, type: ContentType.shortfilm);

              // if (state.model.data?.isMovieOnRent == false) {
              //   if (!isUserSubscribed && state.model.data?.showSubscription == true) {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const SubscriptionScreen(),
              //       ),
              //     );
              //     return;
              //   }
              // }

              // if ((state.model.data?.videoLink == null || state.model.data!.videoLink!.isEmpty) &&
              //     (state.model.data?.shortVideo == null || state.model.data!.shortVideo!.isEmpty)) {
              //   AppToast.showError(msg: "No Short Film Uploaded");
              //   return;
              // }
            }
          },
          builder: (context, state) {
            if (state is GetShortfilmByIdLoadingState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(child: Lottie.asset(AppImages.loadingLottie, height: 100, width: 100)),
              );
            }
            if (state is GetShortfilmByIdLoadedState) {
              var model = state.model.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    sb10h(),
                    (model?.isMovieOnRent == true && !widget.isFromRental)
                        ? Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * 0.5,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  image: DecorationImage(image: NetworkImage("${AppUrls.baseUrl}/${model?.coverImg}")),
                                ),
                              ),
                              BlocListener<PostRentCubit, PostRentState>(
                                listener: (context, state) {
                                  if (state is PostRentErrorState) {
                                    AppToast.showError(context, "Rent", state.error);
                                    return;
                                  }

                                  if (state is PostRentLoadedState) {
                                    AppToast.showSuccess(
                                      context,
                                      "Rent",
                                      "Rented Sucessfully ✅ Check Profile Section to Watch",
                                    );
                                  }
                                },
                                child: BlocBuilder<GetSettingCubit, GetSettingState>(
                                  builder: (context, settingState) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GradientButton(
                                        height: 48,
                                        text: widget.isFromRental
                                            ? 'Watch Now'.tr()
                                            : (model?.isMovieOnRent == true
                                                  ? 'Rent \u{20B9}${model?.movieRentPrice}'.tr()
                                                  : 'Watch Now !'.tr()),
                                        onTap: () {
                                          if (widget.isFromRental) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ShortFlimDescrptionScreen(model: model ?? ShortFilm()),
                                              ),
                                            );
                                            return;
                                          }
                                          if (model?.isMovieOnRent == true) {
                                            String? validityDate;
                                            var day = model?.rentedTimeDays;
                                            if (day != null) {
                                              final now = DateTime.now();
                                              final validTill = now.add(
                                                Duration(days: int.tryParse(day.toString()) ?? 0),
                                              );
                                              validityDate = DateFormat('yyyy-MM-dd').format(validTill);
                                            }

                                            log("Validate Date : $validityDate");

                                            if (settingState is GetSettingLoadedState) {
                                              log("settingState ${settingState.model.setting?.paymentType}");
                                              if (settingState.model.setting?.paymentType == "Free") {
                                                AppToast.showSuccess(context, "Rent", "Totally App is Free");
                                                return;
                                              } else if (settingState.model.setting?.paymentType == "RazorPay") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => RazorpayScreen(
                                                      amount: int.parse(state.model.data?.movieRentPrice ?? ""),
                                                      subscriptionId: "",
                                                      razorPayKey: settingState.model.setting?.razorpayKey ?? "",
                                                      isSubscription: false,
                                                      contectNo: "",
                                                      shortFilmId: widget.id,
                                                      formattedDate: validityDate.toString(),
                                                    ),
                                                  ),
                                                );
                                              } else if (settingState.model.setting?.paymentType == "Cashfree") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CashFreeScreen(
                                                      amount: int.tryParse(state.model.data?.movieRentPrice ?? "") ?? 0,
                                                      subscriptionId: "",
                                                      shortFilmId: widget.id,
                                                      isSubscription: false,
                                                      appId: settingState.model.setting?.cashfreeClientId,
                                                      secrectId: settingState.model.setting?.cashfreeClientSecretKey,
                                                      formattedDate: validityDate.toString(),
                                                    ),
                                                  ),
                                                );
                                              } else if (settingState.model.setting?.paymentType == "UPI") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => UPIIntentScreen(
                                                      amount: state.model.data?.movieRentPrice ?? "",
                                                      subscriptionId: "",
                                                      isSubscription: false,
                                                      upiId: settingState.model.setting?.adminUpi ?? "",
                                                      shortFilmId: widget.id,
                                                      upiName: settingState.model.setting?.authorName ?? "",
                                                      formattedDate: validityDate.toString(),
                                                    ),
                                                  ),
                                                );
                                              } else if (settingState.model.setting?.paymentType == "PhonePe") {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //       builder: (context) => UPIIntentScreen(
                                                //         amount: seletedPrice ?? "",
                                                //         subscriptionId: selectedId ?? "",
                                                //         isSubscription: true,
                                                //         upiId: settingState.model.setting?.adminUpi ?? "",
                                                //         upiName: settingState.model.setting?.authorName ?? "",
                                                //         formattedDate: endDate.toString(),
                                                //       ),
                                                //     ));
                                              }
                                            }

                                            // context.read<PostRentCubit>().postRent(
                                            //       cost: model?.movieRentPrice,
                                            //       shortFilmId: model?.id,
                                            //       userId: userId,
                                            //       validityDate: validityDate,
                                            //     );
                                            return;
                                          }

                                          if ((model?.videoLink == null || model!.videoLink!.isEmpty) &&
                                              (model?.shortVideo == null || model!.shortVideo!.isEmpty)) {
                                            AppToast.showError(context, "!", "No Short Film Uploaded");
                                            return;
                                          }

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ShortFlimDescrptionScreen(model: model),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : (!isUserSubscribed && state.model.data?.showSubscription == true)
                        ? Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage("${AppUrls.baseUrl}/${model?.coverImg}"),
                                      ),
                                    ),
                                  ),
                                  const Positioned(top: 10, left: 10, child: CustomBackButton()),
                                ],
                              ),
                              sb15h(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GradientButton(
                                  height: 48,
                                  text: 'Subscribe'.tr(),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Colors.black,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: CustomVideoPlayer(
                                lastPosition: widget.lastPosition,
                                ads: model?.shortfilmAds,
                                audioUrl: model?.shortVideo?.contains("https") ?? false
                                    ? "${AppUrls.baseUrl}/${model?.shortVideo}"
                                    : "${AppUrls.baseUrl}/${model?.shortVideo}",
                                handleOnChanged: (int watchTime, {bool isWatched = false}) {
                                  final videoUrl = (model?.shortVideo?.isNotEmpty == true
                                      ? "${AppUrls.baseUrl}/${model?.shortVideo}"
                                      : model?.videoLink ?? "");
                                  log("videoUrl=====> $videoUrl");
                                  if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
                                    return;
                                  }
                                  _watchingCubit?.postContinueWatching(
                                    contentType: ContentType.shortfilm,
                                    typeId: widget.id,
                                    currentTime: watchTime,
                                    isWatched: isWatched,
                                  );
                                },
                              ),
                            ),
                          ),
                    // Container(
                    //   height: MediaQuery.of(context).size.height * 0.5,
                    //   decoration: BoxDecoration(
                    //     borderRadius: const BorderRadius.only(
                    //       bottomLeft: Radius.circular(12),
                    //       bottomRight: Radius.circular(12),
                    //     ),
                    //     image: DecorationImage(
                    //       fit: BoxFit.contain,
                    //       image: NetworkImage(
                    //         "${model?.coverImg}",
                    //       ),
                    //     ),
                    //   ),
                    //   child: BlocListener<GetLikeCubit, GetLikeState>(
                    //     listener: (context, state) {
                    //       if (state is GetLikeLoadedState) {
                    //         isLiked = state.model.data?.liked == true;
                    //         isDisliked = state.model.data?.disliked == true;
                    //         setState(() {});
                    //       }
                    //     },
                    //     child: Stack(
                    //       children: [
                    //         Positioned(
                    //           top: MediaQuery.of(context).padding.top + 8,
                    //           left: 12,
                    //           child: const CustomBackButton(),
                    //         ),
                    //         Positioned(
                    //           bottom: 0,
                    //           left: 0,
                    //           right: 0,
                    //           height: MediaQuery.of(context).size.height * 0.30,
                    //           child: Container(
                    //             decoration: const BoxDecoration(
                    //               gradient: LinearGradient(
                    //                 begin: Alignment.topCenter,
                    //                 end: Alignment.bottomCenter,
                    //                 colors: [
                    //                   Colors.transparent,
                    //                   Color.fromRGBO(24, 27, 35, 0.7),
                    //                   Color.fromRGBO(24, 27, 35, 0.9),
                    //                   Color.fromRGBO(24, 27, 35, 1.0),
                    //                 ],
                    //                 stops: [0.0, 0.4, 0.75, 1.0],
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         Positioned(
                    //           bottom: 14,
                    //           left: 12,
                    //           right: 12,
                    //           child: Row(
                    //             children: [
                    //               BlocListener<PostRentCubit, PostRentState>(
                    //                 listener: (context, state) {
                    //                   if (state is PostRentErrorState) {
                    //                     AppToast.showError(msg: state.error);
                    //                     return;
                    //                   }

                    //                   if (state is PostRentLoadedState) {
                    //                     AppToast.showError(
                    //                         msg: "Rented Sucessfully ✅ Check Profile Section to Watch");
                    //                   }
                    //                 },
                    //                 child: Expanded(
                    //                   child: BlocBuilder<GetSettingCubit, GetSettingState>(
                    //                     builder: (context, settingState) {
                    //                       return GradientButton(
                    //                         height: 48,
                    //                         text: widget.isFromRental
                    //                             ? 'Watch Now'.tr()
                    //                             : (model?.isMovieOnRent == true
                    //                                 ? 'Rent \u{20B9}${model?.movieRentPrice}'.tr()
                    //                                 : 'Watch Now !'.tr()),
                    //                         onTap: () {
                    //                           if (widget.isFromRental) {
                    //                             Navigator.push(
                    //                               context,
                    //                               MaterialPageRoute(
                    //                                 builder: (context) => ShortFlimDescrptionScreen(
                    //                                   model: model ?? ShortFilm(),
                    //                                 ),
                    //                               ),
                    //                             );
                    //                             return;
                    //                           }
                    //                           if (model?.isMovieOnRent == true) {
                    //                             String? validityDate;
                    //                             var day = model?.rentedTimeDays;
                    //                             if (day != null) {
                    //                               final now = DateTime.now();
                    //                               final validTill =
                    //                                   now.add(Duration(days: int.tryParse(day.toString()) ?? 0));
                    //                               validityDate = DateFormat('yyyy-MM-dd').format(validTill);
                    //                             }

                    //                             log("Validate Date : $validityDate");

                    //                             if (settingState is GetSettingLoadedState) {
                    //                               if (settingState.model.setting?.paymentType == "Free") {
                    //                                 AppToast.showError(msg: "Totally App is Free");
                    //                                 return;
                    //                               } else if (settingState.model.setting?.paymentType == "RazorPay") {
                    //                                 Navigator.push(
                    //                                   context,
                    //                                   MaterialPageRoute(
                    //                                     builder: (context) => RazorpayScreen(
                    //                                       amount: int.parse(
                    //                                         state.model.data?.movieRentPrice ?? "",
                    //                                       ),
                    //                                       subscriptionId: "",
                    //                                       razorPayKey: settingState.model.setting?.razorpayKey ?? "",
                    //                                       isSubscription: false,
                    //                                       contectNo: "",
                    //                                       shortFilmId: widget.id,
                    //                                       formattedDate: validityDate.toString(),
                    //                                     ),
                    //                                   ),
                    //                                 );
                    //                               } else if (settingState.model.setting?.paymentType == "Cashfree") {
                    //                                 Navigator.push(
                    //                                     context,
                    //                                     MaterialPageRoute(
                    //                                       builder: (context) => CashFreeScreen(
                    //                                         amount: int.tryParse(
                    //                                               state.model.data?.movieRentPrice ?? "",
                    //                                             ) ??
                    //                                             0,
                    //                                         subscriptionId: "",
                    //                                         shortFilmId: widget.id,
                    //                                         isSubscription: false,
                    //                                         appId: settingState.model.setting?.cashfreeClientId,
                    //                                         secrectId:
                    //                                             settingState.model.setting?.cashfreeClientSecretKey,
                    //                                         formattedDate: validityDate.toString(),
                    //                                       ),
                    //                                     ));
                    //                               } else if (settingState.model.setting?.paymentType == "UPI") {
                    //                                 Navigator.push(
                    //                                     context,
                    //                                     MaterialPageRoute(
                    //                                       builder: (context) => UPIIntentScreen(
                    //                                         amount: state.model.data?.movieRentPrice ?? "",
                    //                                         subscriptionId: "",
                    //                                         isSubscription: false,
                    //                                         upiId: settingState.model.setting?.adminUpi ?? "",
                    //                                         shortFilmId: widget.id,
                    //                                         upiName: settingState.model.setting?.authorName ?? "",
                    //                                         formattedDate: validityDate.toString(),
                    //                                       ),
                    //                                     ));
                    //                               } else if (settingState.model.setting?.paymentType == "PhonePe") {
                    //                                 // Navigator.push(
                    //                                 //     context,
                    //                                 //     MaterialPageRoute(
                    //                                 //       builder: (context) => UPIIntentScreen(
                    //                                 //         amount: seletedPrice ?? "",
                    //                                 //         subscriptionId: selectedId ?? "",
                    //                                 //         isSubscription: true,
                    //                                 //         upiId: settingState.model.setting?.adminUpi ?? "",
                    //                                 //         upiName: settingState.model.setting?.authorName ?? "",
                    //                                 //         formattedDate: endDate.toString(),
                    //                                 //       ),
                    //                                 //     ));
                    //                               }
                    //                             }

                    //                             // context.read<PostRentCubit>().postRent(
                    //                             //       cost: model?.movieRentPrice,
                    //                             //       shortFilmId: model?.id,
                    //                             //       userId: userId,
                    //                             //       validityDate: validityDate,
                    //                             //     );
                    //                             return;
                    //                           }

                    //                           if (!isUserSubscribed && model?.showSubscription == true) {
                    //                             Navigator.push(
                    //                               context,
                    //                               MaterialPageRoute(
                    //                                 builder: (context) => const SubscriptionScreen(),
                    //                               ),
                    //                             );
                    //                             return;
                    //                           }

                    //                           if ((model?.videoLink == null || model!.videoLink!.isEmpty) &&
                    //                               (model?.shortVideo == null || model!.shortVideo!.isEmpty)) {
                    //                             AppToast.showError(msg: "No Short Film Uploaded");
                    //                             return;
                    //                           }

                    //                           Navigator.push(
                    //                             context,
                    //                             MaterialPageRoute(
                    //                               builder: (context) => ShortFlimDescrptionScreen(
                    //                                 model: model,
                    //                               ),
                    //                             ),
                    //                           );
                    //                         },
                    //                       );
                    //                     },
                    //                   ),
                    //                 ),
                    //               ),
                    //               sb10w(),
                    //               sb10w(),
                    //               BlocListener<PostLikeCubit, PostLikeState>(
                    //                 listener: (context, state) {
                    //                   if (state is PostLikeLoadedState) {
                    //                     context.read<GetLikeCubit>().getLike(
                    //                           typeId: widget.id,
                    //                           type: ContentType.shortfilm,
                    //                         );
                    //                   }
                    //                 },
                    //                 child: GestureDetector(
                    //                   onTap: () {
                    //                     setState(() {
                    //                       isLiked = !isLiked;
                    //                       if (isLiked) isDisliked = false;
                    //                       context.read<PostLikeCubit>().postLike(
                    //                           shortfilmId: widget.id, type: ContentType.shortfilm, isLiked: isLiked);
                    //                     });
                    //                   },
                    //                   child: SvgPicture.asset(
                    //                     "asset/svg/like.svg",
                    //                     height: 30,
                    //                     width: 30,
                    //                     colorFilter: ColorFilter.mode(
                    //                       isLiked ? Colors.red : Colors.grey,
                    //                       BlendMode.srcIn,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //               sb5w(),
                    //               GestureDetector(
                    //                 onTap: () {
                    //                   setState(() {
                    //                     isDisliked = !isDisliked;
                    //                     if (isDisliked) isLiked = false;
                    //                   });
                    //                   context.read<PostLikeCubit>().postLike(
                    //                         disLiked: isDisliked,
                    //                         shortfilmId: widget.id,
                    //                         type: ContentType.shortfilm,
                    //                       );
                    //                 },
                    //                 child: SvgPicture.asset(
                    //                   "asset/svg/dislike.svg",
                    //                   height: 30,
                    //                   width: 30,
                    //                   colorFilter: ColorFilter.mode(
                    //                     isDisliked ? Colors.red : Colors.grey,
                    //                     BlendMode.srcIn,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    sb15h(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BlocListener<PostWatchlistCubit, PostWatchlistState>(
                          listener: (context, state) {
                            if (state is PostWatchlistErrorState) {
                              AppToast.showError(context, "WatchList", state.error);
                              return;
                            }

                            if (state is PostWatchlistLoadedState) {
                              AppToast.showError(context, "WatchList", "Added to watch List".tr());
                              context.read<GetWatchlistCubit>().getWatchList();
                            }
                          },
                          child: GestureDetector(
                            onTap: () {
                              context.read<PostWatchlistCubit>().postWatchList(
                                shortfilmId: widget.id,
                                type: ContentType.shortfilm,
                              );
                            },
                            child: Column(
                              children: [
                                IconButton(
                                  color: AppColor.whiteColor,
                                  onPressed: () {
                                    context.read<PostWatchlistCubit>().postWatchList(
                                      shortfilmId: widget.id,
                                      type: ContentType.shortfilm,
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                                TextWidget(text: "Add To WatchList".tr()),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              color: AppColor.whiteColor,
                              onPressed: () {
                                final movieId = widget.id;
                                final link = "https://bigcinema.com?type=${ContentType.shortfilm}&id=$movieId";
                                Share.share("Watch this Short Film on ${AppString.appName} 🎬\n$link");
                              },
                              icon: const Icon(Icons.share, size: 20),
                            ),
                            TextWidget(text: "Share".tr()),
                          ],
                        ),
                        Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: _isDownloading ? _downloadProgress : 1,
                                  strokeWidth: 3,
                                  backgroundColor: Colors.grey,
                                  color: _isDownloaded ? Colors.green : AppColor.whiteColor,
                                ),
                                IconButton(
                                  color: AppColor.whiteColor,
                                  onPressed: () {
                                    if (!_isDownloading && !_isDownloaded) {
                                      _downloadVideo(
                                        movie: models.ShortFilm(
                                          category: genre.Genre(
                                            coverImg: model?.category?.coverImg,
                                            createdAt: model?.category?.createdAt,
                                            id: model?.category?.id,
                                            name: model?.category?.name,
                                            status: model?.category?.status,
                                            updatedAt: model?.category?.updatedAt,
                                          ),
                                          coverImg: model?.coverImg,
                                          createdAt: model?.createdAt,
                                          description: model?.description,
                                          genre: genre.Genre(
                                            coverImg: model?.genre?.coverImg,
                                            createdAt: model?.genre?.createdAt,
                                            id: model?.genre?.id,
                                            name: model?.genre?.name,
                                            status: model?.genre?.status,
                                            updatedAt: model?.genre?.updatedAt,
                                          ),
                                          genreId: model?.genreId,
                                          id: model?.id,
                                          isHighlighted: model?.isHighlighted,
                                          isMovieOnRent: model?.isMovieOnRent,
                                          isWatchlist: model?.isWatchlist,
                                          language: genre.Genre(
                                            coverImg: model?.language?.coverImg,
                                            createdAt: model?.language?.createdAt,
                                            id: model?.id,
                                            name: model?.language?.name,
                                            status: model?.language?.status,
                                            updatedAt: model?.language?.updatedAt,
                                          ),
                                          movieCategory: model?.movieCategory,
                                          movieLanguage: model?.movieLanguage,
                                          shortFilmTitle: model?.shortFilmTitle,
                                          movieRentPrice: model?.movieRentPrice,
                                          movieTime: model?.movieTime,
                                          shortVideo: model?.shortVideo,
                                          posterImg: model?.posterImg,
                                          quality: model?.quality,
                                          releasedBy: model?.releasedBy,
                                          releasedDate: model?.releasedDate,
                                          status: model?.status,
                                          subtitle: model?.subtitle,
                                          updatedAt: model?.updatedAt,
                                          videoLink: model?.videoLink,
                                          averageRating: model?.averageRating,
                                          totalRatings: model?.totalRatings,
                                          showSubscription: model?.showSubscription,
                                          viewCount: model?.viewCount,
                                          rentedTimeDays: model?.rentedTimeDays.toString(),
                                        ),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    _isDownloaded ? Icons.check : Icons.download,
                                    color: _isDownloaded ? Colors.green : AppColor.whiteColor,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            TextWidget(text: _isDownloading ? "Dowloading" : "Download".tr()),
                          ],
                        ),
                      ],
                    ),

                    sb15h(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: model?.shortFilmTitle ?? "",
                                    fontSize: 23,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  TextWidget(
                                    text: model?.category?.name ?? "",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: AppColor.greyColor,
                                  ),
                                  TextWidget(
                                    text: model?.language?.name ?? "",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: AppColor.greyColor,
                                  ),
                                ],
                              ),
                              BlocListener<ShortFilmRateCubit, ShortFilmRateState>(
                                listener: (context, state) {
                                  if (state is ShortFilmRateErrorState) {
                                    AppToast.showError(context, "Rate", state.error);
                                    return;
                                  }
                                  if (state is ShortFilmRateLoadedState) {
                                    context.read<GetShortFilmRatingByIdCubit>().getShortFilmRating(model?.id ?? "");
                                    AppToast.showSuccess(context, "Rated ✅", "Rated");
                                  }
                                },
                                child: BlocConsumer<GetShortFilmRatingByIdCubit, GetShortFilmRatingByIdState>(
                                  listener: (context, state) {
                                    if (state is GetShortFilmRatingByIdLoadedState) {
                                      try {
                                        rating = double.tryParse(state.model.averageRating ?? "") ?? 0.0;
                                        setState(() {});
                                      } catch (e) {
                                        log("====================>=>=> $e");
                                      }
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is GetShortFilmRatingByIdLoadedState ||
                                        state is GetShortFilmRatingByIdErrorState) {
                                      final int userCount = state is GetShortFilmRatingByIdLoadedState
                                          ? (state.model.ratings?.length ?? 0)
                                          : 0;
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              RatingBar.builder(
                                                itemBuilder: (context, index) {
                                                  bool isSelected = index < rating;
                                                  return Icon(
                                                    index < rating ? Icons.star : Icons.star_border,
                                                    color: isSelected ? Colors.orange : AppColor.whiteColor,
                                                    size: 30,
                                                  );
                                                },
                                                onRatingUpdate: (ratingvalue) {
                                                  setState(() {
                                                    rating = ratingvalue;
                                                  });
                                                  context.read<ShortFilmRateCubit>().postShortFilmRate(
                                                    movieId: model?.id ?? "",
                                                    rating: ratingvalue.toString(),
                                                  );
                                                },
                                                initialRating: rating,
                                                allowHalfRating: true,
                                                minRating: 0.5,
                                                unratedColor: AppColor.whiteColor,
                                                itemCount: 5,
                                                itemSize: 25,
                                                updateOnDrag: true,
                                              ),
                                              sb5w(),
                                              TextWidget(text: "(${rating.toString()})"),
                                            ],
                                          ),
                                          sb5h(),
                                          TextWidget(text: "From $userCount users", color: AppColor.textGreyColor),
                                        ],
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ],
                          ),
                          sb30h(),
                          ExpandableDescription(description: state.model.data?.description ?? ""),
                          sb15h(),
                          sb20h(),
                          BlocBuilder<GetShortFilmCastcrewCubit, GetShortFilmCastcrewState>(
                            builder: (context, state) {
                              if (state is GetShortFilmCastcrewLoadingState) {
                                return const Center(child: CustomCircularProgressIndicator());
                              }

                              if (state is GetShortFilmCastcrewLoadedState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(text: "Cast".tr()),
                                    sb10h(),
                                    state.model.data?.isEmpty ?? true
                                        ? TextWidget(text: "No Cast Crew Avaliable".tr())
                                        : GridView.builder(
                                            padding: const EdgeInsets.all(8),
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 3.5,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                            ),
                                            itemCount: state.model.data?.length,
                                            itemBuilder: (context, index) {
                                              var data = state.model.data?[index];
                                              return Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromRGBO(233, 233, 233, 1),
                                                      Color.fromRGBO(0, 0, 0, 0),
                                                      Color.fromRGBO(0, 0, 0, 0),
                                                      Color.fromRGBO(0, 0, 0, 0),
                                                    ],
                                                  ),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(2),
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient: LinearGradient(
                                                          colors: AppColor.gradientColorList,
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                        ),
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor: Colors.white,
                                                        child: ClipOval(
                                                          child: Image.network(
                                                            "${AppUrls.baseUrl}/${data?.profileImg ?? ''}",
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context, error, stackTrace) {
                                                              return Image.asset(
                                                                'asset/test/default.png',
                                                                width: 50,
                                                                height: 50,
                                                                fit: BoxFit.cover,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          TextWidget(
                                                            text: data?.name ?? "",
                                                            maxlines: 1,
                                                            textOverflow: TextOverflow.ellipsis,
                                                          ),
                                                          TextWidget(
                                                            text: data?.role ?? "",
                                                            color: AppColor.greyColor,
                                                            maxlines: 1,
                                                            textOverflow: TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                  ],
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                          sb10h(),
                          // model?.recommendedMovies?.isNotEmpty ?? false
                          //     ? Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const TextWidget(
                          //             text: 'Recommended Movies',
                          //             fontSize: 16,
                          //           ),
                          //           sb10h(),
                          //           SizedBox(
                          //             height: 190,
                          //             child: ListView.builder(
                          //               shrinkWrap: true,
                          //               scrollDirection: Axis.horizontal,
                          //               itemCount: model?.recommendedMovies?.length,
                          //               itemBuilder: (context, index) {
                          //                 var data = model?.recommendedMovies?[index];
                          //                 return GestureDetector(
                          //                   onTap: () {
                          //                     Navigator.push(
                          //                       context,
                          //                       MaterialPageRoute(
                          //                         builder: (context) => MovieDetailScreen(
                          //                           id: data?.id ?? "",
                          //                         ),
                          //                       ),
                          //                     );
                          //                   },
                          //                   child: Column(
                          //                     crossAxisAlignment: CrossAxisAlignment.start,
                          //                     children: [
                          //                       Container(
                          //                         width: 250,
                          //                         height: 160,
                          //                         margin: const EdgeInsets.only(right: 12),
                          //                         child: ClipRRect(
                          //                           borderRadius: BorderRadius.circular(12),
                          //                           child: CustomCachedCard(
                          //                             imageUrl: "${AppUrls.baseUrl}/${data?.posterImg}",
                          //                             width: 250,
                          //                             height: 160,
                          //                           ),
                          //                         ),
                          //                       ),
                          //                       sb5h(),
                          //                       SizedBox(
                          //                         width: 200,
                          //                         child: TextWidget(
                          //                           text: '${data?.movieName}',
                          //                           fontSize: 15,
                          //                           fontWeight: FontWeight.w700,
                          //                           maxlines: 1,
                          //                           textOverflow: TextOverflow.ellipsis,
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 );
                          //               },
                          //             ),
                          //           ),
                          //         ],
                          //       )
                          //     : const SizedBox(),
                          // sb10h(),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColor.redColor),
                              child: TextWidget(text: 'Report'.tr()),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BlocListener<PostReportCubit, PostReportState>(
                                      listener: (context, state) {
                                        if (state is PostReportErrorState) {
                                          AppToast.showError(context, "Report", state.error);
                                          return;
                                        }
                                        if (state is PostReportLoadedState) {
                                          Navigator.pop(context);
                                          AppToast.showSuccess(context, "Report", "Report Sucessfully ✅");
                                        }
                                      },
                                      child: Dialog(
                                        backgroundColor: AppColor.blackColor,
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: StatefulBuilder(
                                              builder: (context, setState) {
                                                return Column(
                                                  children: [
                                                    sb10h(),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        sb20w(),
                                                        TextWidget(text: "Report".tr(), fontSize: 15),
                                                        IconButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          icon: const Icon(Icons.close, color: AppColor.whiteColor),
                                                        ),
                                                      ],
                                                    ),
                                                    sb10h(),
                                                    Wrap(
                                                      spacing: 10,
                                                      children: reportReasons.map((reason) {
                                                        return ChoiceChip(
                                                          label: Text(reason),
                                                          selected: selectedReason == reason,
                                                          onSelected: (selected) {
                                                            setState(() {
                                                              selectedReason = selected ? reason : null;
                                                            });
                                                          },
                                                          selectedColor: AppColor.redColor,
                                                          backgroundColor: Colors.grey.shade800,
                                                          iconTheme: const IconThemeData(color: AppColor.whiteColor),
                                                          labelStyle: const TextStyle(color: AppColor.whiteColor),
                                                        );
                                                      }).toList(),
                                                    ),
                                                    sb20h(),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                      onPressed: () {
                                                        if (selectedReason == null) {
                                                          AppToast.showError(context, "Reason", "Select reason");
                                                          return;
                                                        }
                                                        context.read<PostReportCubit>().report(
                                                          contentId: model?.id ?? "",
                                                          contentType: ContentType.shortfilm,
                                                          reason: selectedReason,
                                                        );
                                                      },
                                                      child: TextWidget(text: "Report".tr()),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          sb10h(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class ExpandableDescription extends StatefulWidget {
  final String description;

  const ExpandableDescription({super.key, required this.description});

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Html(
          data: widget.description,
          style: {
            "body": Style(
              fontSize: FontSize(14.0),
              color: AppColor.whiteColor,
              maxLines: isExpanded ? null : 4,
              textOverflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          },
        ),
        if (_isTextLong(widget.description))
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? "Less" : "More",
              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  bool _isTextLong(String text) {
    return text.length > 150;
  }
}
