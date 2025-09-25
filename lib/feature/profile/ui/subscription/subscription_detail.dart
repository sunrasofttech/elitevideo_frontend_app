import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_auth_design.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class SubscriptionDetail extends StatefulWidget {
  const SubscriptionDetail({super.key});

  @override
  State<SubscriptionDetail> createState() => _SubscriptionDetailState();
}

class _SubscriptionDetailState extends State<SubscriptionDetail> with Utility {
  String? model, brand, device, manufacturer, androidVersion, sdk, board, androidId;

  Future<void> logDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

        model = androidInfo.model;
        brand = androidInfo.brand;
        device = androidInfo.device;
        manufacturer = androidInfo.manufacturer;
        androidVersion = androidInfo.version.release;
        sdk = androidInfo.version.sdkInt.toString();
        board = androidInfo.board;
        androidId = androidInfo.id;

        debugPrint('✅ Android Device Info Loaded');
        setState(() {});
      } else if (Platform.isIOS) {}
    } catch (e) {
      debugPrint('❌ Error getting device info: $e');
    }
  }

  @override
  void initState() {
    logDeviceInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomAuthDesignScreen(
          center: false,
          data: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        text: "Subscription Details".tr(),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  sb30h(),
                  TextWidget(
                    text: "Subscription Details".tr(),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                  sb20h(),
                  BlocBuilder<GetProfileCubit, GetProfileState>(
                    builder: (context, state) {
                      if (state is GetProfileLoadedState) {
                        final subscription = state.model.user?.subscription;
                        if (subscription == null) {
                          return TextWidget(
                            text: "No subscription available.".tr(),
                            color: AppColor.whiteColor,
                          );
                        }

                        // Table content
                        final List<List<String>> details = [
                          ["Plan Name", subscription.planName ?? ""],
                          ["All Content", subscription.allContent ?? false ? "Yes" : "No"],
                          ["Watch on TV/Laptop", subscription.watchonTvLaptop ?? false ? "Yes" : "No"],
                          ["Ad-Free Movies/Shows", subscription.addfreeMovieShows ?? false ? "Yes" : "No"],
                          ["Devices", subscription.numberOfDeviceThatLogged.toString()],
                          [
                            "Max Video Quality",
                            subscription.maxVideoQuality?.isNotEmpty == true ? subscription.maxVideoQuality! : "N/A"
                          ],
                          ["Amount", "₹${subscription.amount}/${subscription.timeDuration}"],
                        ];

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade700),
                          ),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(5),
                            },
                            border: TableBorder.symmetric(
                              inside: BorderSide(color: Colors.grey.shade800, width: 0.5),
                            ),
                            children: details.map((item) {
                              return TableRow(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                    child: TextWidget(
                                      text: item[0],
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                    child: TextWidget(
                                      text: item[1],
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      } else if (state is GetProfileLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetProfileErrorState) {
                        return TextWidget(
                          text: state.error,
                          color: Colors.red,
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                  sb30h(),
                  TextWidget(
                    text: "Device Details".tr(),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                  sb20h(),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade700),
                    ),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(5),
                      },
                      border: TableBorder.symmetric(
                        inside: BorderSide(color: Colors.grey.shade800, width: 0.5),
                      ),
                      children: [
                        _buildTableRow("Model", model ?? "-"),
                        _buildTableRow("Brand", brand ?? "-"),
                        _buildTableRow("Device", device ?? "-"),
                        _buildTableRow("Manufacturer", manufacturer ?? "-"),
                        _buildTableRow("Android Version", androidVersion ?? "-"),
                        _buildTableRow("SDK", sdk ?? "-"),
                        _buildTableRow("Board", board ?? "-"),
                        _buildTableRow("Android ID", androidId ?? "-"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String title, String value) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: TextWidget(
            text: title,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: TextWidget(
            text: value,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  String formatDate(String? isoDate) {
    if (isoDate == null) return "-";
    try {
      final dateTime = DateTime.parse(isoDate);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    } catch (e) {
      return isoDate;
    }
  }
}
