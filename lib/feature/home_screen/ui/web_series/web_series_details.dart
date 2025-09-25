import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:elite/constant/app_string.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/home_screen/bloc/check_rental/check_rental_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_series_cast_crew/get_series_castcrew_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_webseries_by_id/get_webseries_by_id_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_rent/post_rent_cubit.dart';
import 'package:elite/feature/home_screen/bloc/service_rating/get_series_rating/get_series_rating_cubit.dart';
import 'package:elite/feature/home_screen/bloc/service_rating/post_series_rating/post_series_rating_cubit.dart';
import 'package:elite/feature/home_screen/ui/web_series/episode_detail_screen.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_cubit.dart';
import 'package:elite/feature/profile/ui/subscription/subscription_screen.dart';
import 'package:elite/main.dart';
import 'package:elite/payment/cashfree_screen.dart';
import 'package:elite/payment/razorpay_payment.dart';
import 'package:elite/payment/upi_payment.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_back_button.dart';
import 'package:elite/utils/widgets/custom_error.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import '../../../../constant/app_colors.dart';
import '../../bloc/post_report/post_report_cubit.dart';

// ignore: must_be_immutable
class WebSeriesDetails extends StatefulWidget {
  WebSeriesDetails({super.key, required this.id, this.isFromRental = false, required this.type});
  final String id;
  bool isFromRental;
  ContentType type;

  @override
  State<WebSeriesDetails> createState() => _WebSeriesDetailsState();
}

class _WebSeriesDetailsState extends State<WebSeriesDetails> with Utility {
  double rating = 0.0;
  TextEditingController reportController = TextEditingController();
  String? selectedReason;
  bool _hasRentalAccess = false;

  @override
  void initState() {
    context.read<GetSeriesCastcrewCubit>().getCastCrew(movieId: widget.id);
    context.read<GetSeriesRatingCubit>().getShortFilmRating(widget.id);
    context.read<CheckRentalCubit>().checkRental(type: widget.type, typeId: widget.id);
    context.read<GetWebseriesByIdCubit>().getWebseriesById(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(63, 173, 213, 1).withOpacity(0.3),
      body: BlocListener<CheckRentalCubit, CheckRentalState>(
        listener: (context, state) {
          if (state is CheckRentalLoadedState) {
            setState(() {
              _hasRentalAccess = true;
            });
          }
        },
        child: BlocBuilder<GetWebseriesByIdCubit, GetWebseriesByIdState>(
          builder: (context, state) {
            if (state is GetWebseriesByIdLoadingState) {
              return const Center(child: CustomCircularProgressIndicator());
            }
            if (state is GetWebseriesByIdErrorState) {
              return const Center(child: CustomErrorWidget());
            }
            if (state is GetWebseriesByIdLoadedState) {
              var model = state.model.data;
              return ListView(
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
                      const Positioned(top: 30, left: 16, child: CustomBackButton()),
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
                                TextWidget(text: model?.seriesName ?? "", fontSize: 19, fontWeight: FontWeight.w800),
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
                            BlocListener<PostSeriesRatingCubit, PostSeriesRatingState>(
                              listener: (context, state) {
                                if (state is PostSeriesRatingErrorState) {
                                  AppToast.showError(context, state.error, "");
                                  return;
                                }
                                if (state is PostSeriesRatingLoadedState) {
                                  AppToast.showSuccess(context, "Rated ✅", "");
                                }
                              },
                              child: BlocConsumer<GetSeriesRatingCubit, GetSeriesRatingState>(
                                listener: (context, state) {
                                  if (state is GetSeriesRatingLoadedState) {
                                    try {
                                      rating = double.tryParse(state.model.averageRating ?? "") ?? 0.0;
                                      setState(() {});
                                      // ignore: empty_catches
                                    } catch (e) {
                                      log("====================>=>=> $e");
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  if (state is GetSeriesRatingLoadedState) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                                context.read<PostSeriesRatingCubit>().postSeriesRate(
                                                  movieId: model?.id ?? "",
                                                  rating: ratingvalue.toString(),
                                                  type: widget.type,
                                                );
                                              },
                                              initialRating: rating,
                                              allowHalfRating: false,
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
                                        TextWidget(
                                          text: "From ${state.model.ratings?.length} users",
                                          color: AppColor.textGreyColor,
                                        ),
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
                        (model?.isSeriesOnRent ?? false) && !_hasRentalAccess
                            ? BlocListener<PostRentCubit, PostRentState>(
                                listener: (context, state) {
                                  if (state is PostRentErrorState) {
                                    AppToast.showError(context, state.error, "");
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BlocBuilder<GetSettingCubit, GetSettingState>(
                                      builder: (context, settingState) {
                                        return GradientButton(
                                          text: 'Rent \u{20B9}${model?.seriesRentPrice}'.tr(),
                                          onTap: () {
                                            var day = model?.rentedTimeDays;
                                            String? validityDate;
                                            if (day != null) {
                                              final now = DateTime.now();
                                              final validTill = now.add(
                                                Duration(days: int.tryParse(day.toString()) ?? 0),
                                              );
                                              validityDate = DateFormat('yyyy-MM-dd').format(validTill);
                                            }

                                            if (settingState is GetSettingLoadedState) {
                                              if (settingState.model.setting?.paymentType == "Free") {
                                                AppToast.showError(context, "Totally App is Free", "");
                                                return;
                                              } else if (settingState.model.setting?.paymentType == "RazorPay") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => RazorpayScreen(
                                                      amount: int.parse(model?.seriesRentPrice ?? ""),
                                                      subscriptionId: "",
                                                      razorPayKey: settingState.model.setting?.razorpayKey ?? "",
                                                      isSubscription: false,
                                                      contectNo: "",
                                                      seriesId: model?.id,
                                                      formattedDate: validityDate.toString(),
                                                    ),
                                                  ),
                                                );
                                              } else if (settingState.model.setting?.paymentType == "Cashfree") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CashFreeScreen(
                                                      amount: int.tryParse(model?.seriesRentPrice ?? "") ?? 0,
                                                      subscriptionId: "",
                                                      seriesId: model?.id,
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
                                                      amount: model?.seriesRentPrice ?? "",
                                                      subscriptionId: "",
                                                      isSubscription: false,
                                                      upiId: settingState.model.setting?.adminUpi ?? "",
                                                      seriesId: model?.id,
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
                                            log("Validate Date : $validityDate");
                                            // context.read<PostRentCubit>().postRent(
                                            //       cost: model?.seriesRentPrice,
                                            //       seriesId: model?.id,
                                            //       userId: userId,
                                            //       validityDate: validityDate,
                                            //     );
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              )
                            : (widget.isFromRental || (model!.showSubscription == true && isUserSubscribed))
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(text: "Seasons".tr()),
                                  sb10h(),
                                  ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: model?.season?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final season = model?.season![index];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            if (!isUserSubscribed && model?.showSubscription == true) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
                                              );
                                              return;
                                            }

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EpisodeDetailScreen(seasonId: season?.id ?? ""),
                                              ),
                                            );
                                          },
                                          contentPadding: const EdgeInsets.all(16),
                                          leading: const Icon(Icons.movie_creation_outlined),
                                          title: TextWidget(
                                            text: season?.seasonName ?? 'N/A',
                                            fontSize: 18,
                                            color: AppColor.whiteColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          subtitle: TextWidget(
                                            text: "Released: ${_formatDate(season?.releasedDate.toString())}",
                                            style: const TextStyle(color: Colors.grey),
                                          ),
                                          trailing: IconButton(
                                            iconSize: 35,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EpisodeDetailScreen(seasonId: season?.id ?? ""),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.play_arrow),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  sb30h(),
                                ],
                              )
                            : GradientButton(
                                text: 'Subscribe'.tr(),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
                                  );
                                },
                              ),
                        sb10h(),
                        ExpandableDescription(description: state.model.data?.description ?? ""),
                        sb15h(),
                        sb20h(),
                        BlocBuilder<GetSeriesCastcrewCubit, GetSeriesCastcrewState>(
                          builder: (context, state) {
                            if (state is GetSeriesCastcrewLoadingState) {
                              return const Center(child: CustomCircularProgressIndicator());
                            }

                            if (state is GetSeriesCastcrewLoadedState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(text: "Cast".tr()),
                                  sb10h(),
                                  state.model.data?.isEmpty ?? true
                                      ? TextWidget(text: "No Cast Crew Available".tr())
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
                                        AppToast.showError(context, state.error, "");
                                        return;
                                      }
                                      if (state is PostReportLoadedState) {
                                        Navigator.pop(context);
                                        AppToast.showError(context, "Report Sucessfully ✅", "");
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
                                                        contentType: ContentType.series,
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
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return 'Unknown';
    try {
      final parsedDate = DateTime.parse(date);
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    } catch (e) {
      return 'Invalid date';
    }
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
