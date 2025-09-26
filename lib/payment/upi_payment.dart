import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_upi_india/flutter_upi_india.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/feature/dashboard/dashboard.dart';
import 'package:elite/feature/home_screen/bloc/post_rent/post_rent_cubit.dart';
import 'package:elite/feature/profile/bloc/update_profile/update_profile_cubit.dart';
import 'package:elite/main.dart';
import 'package:elite/payment/payment_success_screen.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class UPIIntentScreen extends StatefulWidget {
  const UPIIntentScreen({
    super.key,
    required this.amount,
    required this.upiId,
    required this.upiName,
    required this.subscriptionId,
    this.movieId,
    this.formattedDate,
    this.seriesId,
    this.shortFilmId,
    required this.isSubscription,
  });

  final String amount;
  final String upiId;
  final String upiName;
  final String? formattedDate;
  final String subscriptionId;
  final bool isSubscription;
  final String? movieId;
  final String? seriesId;
  final String? shortFilmId;

  @override
  State<UPIIntentScreen> createState() => _UPIIntentScreenState();
}

class _UPIIntentScreenState extends State<UPIIntentScreen> with Utility {
  String? _upiAddrError;

  List<ApplicationMeta>? _apps;

  @override
  void initState() {
    super.initState();
    debugPrint("-----> upiName: ${widget.upiName}");
    debugPrint("-----> upiId: ${widget.upiId}");
    Future.delayed(const Duration(milliseconds: 0), () async {
      _apps = await UpiPay.getInstalledUpiApplications(statusType: UpiApplicationDiscoveryAppStatusType.all);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  ValueNotifier<double> discountedAmount = ValueNotifier<double>(0.0);

  // void _applyCoupon() {
  //   if (_couponController.text.isEmpty) {
  //     showMessage(context, "Coupon Code cannot be empty");
  //     return;
  //   }

  //   final couponCode = _couponController.text.trim();
  //   context.read<CheckCuponCodeCubit>().getCuponCode(couponCode);
  // }

  Future<void> _onTap(ApplicationMeta app) async {
    setState(() {
      _upiAddrError = null;
    });

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    if (kDebugMode) {
      print("Starting transaction with id $transactionRef");
    }

    String totalAmount = (discountedAmount.value != 0.0 ? discountedAmount.value : widget.amount).toString();
    UpiTransactionResponse a = await UpiPay.initiateTransaction(
      amount: totalAmount,
      app: app.upiApplication,
      receiverName: widget.upiName,
      receiverUpiAddress: widget.upiId,
      transactionRef: transactionRef,
      transactionNote: 'UPI Payment',
    );

    print("This is UPI PAY MENT :-$a, ---------> Status ${a.status.toString()}");
    if (a.status == UpiTransactionStatus.success) {
      if (widget.isSubscription) {
        context.read<UpdateProfileCubit>().updateProfile(
              isSubscription: true,
              subscriptionEndDate: widget.formattedDate,
              subscriptionId: widget.subscriptionId,
            );
      } else {
        context.read<PostRentCubit>().postRent(
              cost: widget.amount.toString(),
              movieId: widget.movieId,
              seriesId: widget.seriesId,
              shortFilmId: widget.shortFilmId,
              userId: userId,
              validityDate: widget.formattedDate,
            );
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentSuccessScreen(),
        ),
        (route) => false,
      );

      // showDialog(
      //   barrierDismissible: false,
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: const Text("Payment Success"),
      //       content: const SizedBox(
      //         height: 500,
      //         child: Column(
      //           children: [
      //             Text("⌚", style: TextStyle(fontSize: 30)),
      //           ],
      //         ),
      //       ),
      //       actions: [
      //         TextButton(
      //           onPressed: () {
      //             Navigator.pushAndRemoveUntil(
      //               context,
      //               MaterialPageRoute(builder: (context) => const DashboardScreen()),
      //               (route) => false,
      //             );
      //           },
      //           child: const Text("Ok"),
      //         ),
      //       ],
      //     );
      //   },
      // );
    } else if (a.status == UpiTransactionStatus.failure) {
      // context.read<PaymentFailedCubit>().paymentFailed(widget.amount.toString(), "Unknown reason", "Skill Pay");
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: const Text("Payment Failed"),
      //       actions: [
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: const Text("Ok"),
      //         ),
      //       ],
      //     );
      //   },
      // );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Something Went Wrong"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.whiteColor,
        ),
        title: const TextWidget(
          text: "Confirm Payment",
          color: AppColor.whiteColor,
        ),
      ),
      body: BlocListener<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileLoadedState) {
            Future.delayed(
              const Duration(seconds: 3),
              () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardScreen(
                      key: dashboardGlobalKey,
                    ),
                  ),
                  (route) => false,
                );
              },
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: <Widget>[
              sb10h(),
              TextWidget(
                text: "Original Amount: ₹${widget.amount}",
                color: AppColor.whiteColor,
              ),

              if (_upiAddrError != null) _vpaError(),
              // Container(
              //   margin: const EdgeInsets.only(top: 20),
              //   child: Center(
              //     child: Text("Rs.${widget.amount}"),
              //   ),
              // ),
              if (Platform.isIOS) _submitButton(),
              Platform.isAndroid ? _androidApps() : _iosApps(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vpaError() {
    return Container(
      margin: const EdgeInsets.only(top: 4, left: 12),
      child: Text(
        _upiAddrError!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      child: Row(
        children: <Widget>[
          Expanded(
            child: MaterialButton(
              onPressed: () async => await _onTap(_apps![0]),
              color: Theme.of(context).colorScheme.secondary,
              height: 48,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              child: Text('Initiate Transaction',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _androidApps() {
    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Pay Using',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          if (_apps != null) _appsGrid(_apps!.map((e) => e).toList()),
        ],
      ),
    );
  }

  Widget _iosApps() {
    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Text(
              'One of these will be invoked automatically by your phone to '
              'make a payment',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Detected Installed Apps',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          if (_apps != null) _discoverableAppsGrid(),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 12),
            child: Text(
              'Other Supported Apps (Cannot detect)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          if (_apps != null) _nonDiscoverableAppsGrid(),
        ],
      ),
    );
  }

  Widget _discoverableAppsGrid() {
    List<ApplicationMeta> metaList = [];
    for (var e in _apps!) {
      if (e.upiApplication.discoveryCustomScheme != null) {
        metaList.add(e);
      }
    }
    return _appsGrid(metaList);
  }

  Widget _nonDiscoverableAppsGrid() {
    List<ApplicationMeta> metaList = [];
    for (var e in _apps!) {
      if (e.upiApplication.discoveryCustomScheme == null) {
        metaList.add(e);
      }
    }
    return _appsGrid(metaList);
  }

  Widget _appsGrid(List<ApplicationMeta> apps) {
    if (apps.isEmpty) {
      return const Center(child: Text("No UPI APPLICATION FOUND"));
    }
    apps.sort(
        (a, b) => a.upiApplication.getAppName().toLowerCase().compareTo(b.upiApplication.getAppName().toLowerCase()));
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      // childAspectRatio: 1.6,
      physics: const NeverScrollableScrollPhysics(),
      children: apps
          .map(
            (it) => Material(
              key: ObjectKey(it.upiApplication),
              // color: Colors.grey[200],
              child: GestureDetector(
                onTap: Platform.isAndroid ? () async => await _onTap(it) : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    it.iconImage(48),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      alignment: Alignment.center,
                      child: Text(
                        it.upiApplication.getAppName(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

String? _validateUpiAddress(String value) {
  if (value.isEmpty) {
    return 'UPI VPA is required.';
  }
  if (value.split('@').length != 2) {
    return 'Invalid UPI VPA';
  }
  return null;
}
