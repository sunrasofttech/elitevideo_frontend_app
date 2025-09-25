import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/feature/profile/bloc/abc_gateway/abc_gateway_cubit.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_cubit.dart';
import 'package:elite/feature/profile/bloc/get_subscription/get_subscription_cubit.dart';
import 'package:elite/feature/profile/bloc/get_subscription/get_subscription_model.dart';
import 'package:elite/feature/profile/bloc/update_profile/update_profile_cubit.dart';
import 'package:elite/payment/cashfree_screen.dart';
import 'package:elite/payment/razorpay_payment.dart';
import 'package:elite/payment/upi_payment.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_svg.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> with Utility {
  int? selectedIndex;
  String? selectedId;
  String? seletedPrice;
  String? selectedDuration;

  @override
  void initState() {
    super.initState();
    context.read<GetSettingCubit>().getSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          text: "Subscription".tr(),
          color: AppColor.whiteColor,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<GetSubscriptionCubit, GetSubscriptionState>(
        builder: (context, state) {
          if (state is GetSubscriptionLoadedState) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildComparisonTable(state.model.data),
                sb20h(),
                ...List.generate(state.model.data?.length ?? 0, (index) => _buildPlanTile(state.model.data, index)),
                sb20h(),
                BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
                  listener: (context, state) {
                    if (state is UpdateProfileErrorState) {
                      AppToast.showError(context, state.error, "");
                      return;
                    }
                    if (state is UpdateProfileLoadedState) {
                      AppToast.showSuccess(context, "Subscription Buy Successfully".tr(), "");
                      Navigator.pop(context);
                      context.read<GetProfileCubit>().getProfile();
                    }
                  },
                  builder: (context, state) {
                    return BlocBuilder<GetSettingCubit, GetSettingState>(
                      builder: (context, settingState) {
                        return GradientButton(
                          inProgress: (state is UpdateProfilLoadingState),
                          text: 'Subscribe'.tr(),
                          onTap: () {
                            if (selectedId == null) {
                              AppToast.showError(context, "Subscription", "Select Subscription");
                              return;
                            }
                            DateTime now = DateTime.now();
                            DateTime endDate;

                            if (selectedDuration == "month") {
                              endDate = DateTime(now.year, now.month + 1, now.day);
                            } else if (selectedDuration == "year") {
                              endDate = DateTime(now.year + 1, now.month, now.day);
                            } else if (selectedDuration == "week") {
                              endDate = now.add(const Duration(days: 7));
                            } else {
                              endDate = now;
                            }

                            if (settingState is GetSettingLoadedState) {
                              if (settingState.model.setting?.paymentType == "Free") {
                                AppToast.showSuccess(context, "", "Totally App is Free");
                                return;
                              } else if (settingState.model.setting?.paymentType == "ABC") {
                                context.read<AbcGatewayCubit>().abcGateway();
                              } else if (settingState.model.setting?.paymentType == "RazorPay") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RazorpayScreen(
                                      amount: int.parse(
                                        seletedPrice.toString(),
                                      ),
                                      subscriptionId: selectedId ?? "",
                                      razorPayKey: settingState.model.setting?.razorpayKey ?? "",
                                      isSubscription: true,
                                      contectNo: "",
                                      formattedDate: endDate.toString(),
                                    ),
                                  ),
                                );
                              } else if (settingState.model.setting?.paymentType == "Cashfree") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CashFreeScreen(
                                        amount: int.tryParse(seletedPrice ?? "") ?? 0,
                                        subscriptionId: selectedId ?? "",
                                        isSubscription: true,
                                        appId: settingState.model.setting?.cashfreeClientId,
                                        secrectId: settingState.model.setting?.cashfreeClientSecretKey,
                                        formattedDate: endDate.toString(),
                                      ),
                                    ));
                              } else if (settingState.model.setting?.paymentType == "UPI") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UPIIntentScreen(
                                        amount: seletedPrice ?? "",
                                        subscriptionId: selectedId ?? "",
                                        isSubscription: true,
                                        upiId: settingState.model.setting?.adminUpi ?? "",
                                        upiName: settingState.model.setting?.authorName ?? "",
                                        formattedDate: endDate.toString(),
                                      ),
                                    ));
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

                            // String formattedDate =
                            //     "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

                            // context.read<UpdateProfileCubit>().updateProfile(
                            //       isSubscription: true,
                            //       subscriptionEndDate: formattedDate,
                            //       subscriptionId: selectedId,
                            //     );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildComparisonTable(List<SubscriptionPlan>? plans) {
    List<String> features = [
      "All Content",
      "Watch on TV or Laptop",
      "Add Free Movies and Shows",
      "Devices",
      "Max Video Quality",
      "Amount"
    ];

    List<List<Widget>> values = [];

    for (var feature in features) {
      List<Widget> row = [
        Text(
          feature,
          style: const TextStyle(color: Colors.white),
        )
      ];

      for (var plan in plans!) {
        Widget cell;

        switch (feature) {
          case "All Content":
            cell = CustomSvgImage(
              imageUrl: plan.allContent == true ? "asset/svg/tick-circle.svg" : "asset/svg/close-circle.svg",
              height: 20,
              width: 20,
            );
            break;

          case "Watch on TV or Laptop":
            cell = CustomSvgImage(
              imageUrl: plan.watchonTvLaptop == true ? "asset/svg/tick-circle.svg" : "asset/svg/close-circle.svg",
              height: 20,
              width: 20,
            );
            break;

          case "Add Free Movies and Shows":
            cell = CustomSvgImage(
              imageUrl: plan.addfreeMovieShows == true ? "asset/svg/tick-circle.svg" : "asset/svg/close-circle.svg",
              height: 20,
              width: 20,
            );
            break;

          case "Devices":
            cell = Text(
              plan.numberOfDeviceThatLogged?.toString() ?? "-",
              style: const TextStyle(color: Colors.white),
            );
            break;

          case "Max Video Quality":
            cell = Text(
              plan.maxVideoQuality?.isNotEmpty == true ? plan.maxVideoQuality! : "N/A",
              style: const TextStyle(color: Colors.white),
            );
            break;

          case "Amount":
            cell = Text(
              "₹${plan.amount ?? "0"}/${plan.timeDuration ?? ""}",
              style: const TextStyle(color: Colors.white),
            );
            break;

          default:
            cell = const SizedBox();
        }

        row.add(cell);
      }

      values.add(row);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          _buildTableRow([
            const TextWidget(text: ""),
            ...plans!.map(
              (p) => Center(
                child: Text(
                  p.planName ?? "Plan",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ], isHeader: true),
          ...values.map((row) => _buildTableRow(row)),
        ],
      ),
    );
  }

  TableRow _buildTableRow(List<Widget> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((widget) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: widget,
        );
      }).toList(),
    );
  }

  Widget _buildPlanTile(List<SubscriptionPlan>? plans, int index) {
    final plan = plans?[index];
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          selectedId = plan?.id ?? "";
          seletedPrice = plan?.amount ?? "";
          selectedDuration = plan?.timeDuration ?? "";
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromRGBO(77, 197, 253, 1) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "\u20B9${plan?.amount ?? ""}/",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      plan?.timeDuration ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  plan?.planName ?? "",
                  style: TextStyle(
                    color: isSelected ? AppColor.whiteColor : AppColor.navColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: isSelected ? AppColor.whiteColor : Colors.transparent,
                  )),
              child: Icon(
                isSelected ? Icons.check : Icons.radio_button_off,
                color: isSelected ? AppColor.whiteColor : const Color.fromRGBO(77, 197, 253, 1),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GradientButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.height / 2),
    ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomSubscribeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomSubscribeButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: GradientButtonClipper(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purpleAccent,
              Colors.blueAccent,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.85),
            borderRadius: BorderRadius.circular(50),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
