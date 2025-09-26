import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/feature/dashboard/dashboard.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppWebViewScreenGateway extends StatefulWidget {
  const InAppWebViewScreenGateway({super.key, required this.url});
  final String url;
  @override
  State<InAppWebViewScreenGateway> createState() => _InAppWebViewState();
}

class _InAppWebViewState extends State<InAppWebViewScreenGateway> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (webViewController != null && await webViewController!.canGoBack()) {
          if (await webViewController!.getOriginalUrl().toString().contains(
                "https://api.abcgate.shop/payment-processed",
              )) {
            context.read<GetProfileCubit>().getProfile();
            context.read<GetSettingCubit>().getSetting();
            Navigator.pop(context);
            return true;
          }
          webViewController!.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () async {
              // final url = await webViewController?.getUrl();
              // if (url == "https://api.matkaguessing.co.in/app/deposit/sucesspage") {
              //   BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
              //   Navigator.pop(context);
              // }
              if (webViewController != null && await webViewController!.canGoBack()) {
                context.read<GetProfileCubit>().getProfile();
                context.read<GetSettingCubit>().getSetting();
                if (await webViewController!.getOriginalUrl().toString().contains(
                      "https://api.abcgate.shop/payment-processed",
                    )) {
                  Navigator.pop(context);
                }
                webViewController!.goBack();
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black38),
          ),
        ),
        body: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          onWebViewCreated: (controller) async {
            webViewController = controller;
          },
          onLoadStart: (controller, url) async {},
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            Uri uri = navigationAction.request.url!;
            debugPrint(" navigationAction.request.url ---> $uri, ${uri.path}, ${uri.data}");
            bool clickedPaytmUpi = uri.toString().contains("paytmmp://");
            bool clickedShareGooglePlay = uri.toString().contains("gpay://");
            bool clickedPhonePlay = uri.toString().contains("phonepe://");

            if (clickedPhonePlay || clickedShareGooglePlay || clickedPaytmUpi) {
              try {
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                  return NavigationActionPolicy.CANCEL;
                } else {
                  await controller.goBack();
                }
              } catch (err, stk) {
                if (controller.canGoBack() == true) await controller.goBack();
                AppToast.showError(context,"", "Can't open application right now");
                print("Catch ERROR ON :-----> $err, ----> $stk");
              }
              return NavigationActionPolicy.CANCEL;
            }
            if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
              // if (await canLaunchUrl(uri)) {
              //   // Launch the App
              //   await launchUrl(
              //     uri,
              //   );
              //   // and cancel the request
              //   return NavigationActionPolicy.CANCEL;
              // }
            }

            return NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) async {
            log("url url url ----------> $url ------ ${await webViewController!.getOriginalUrl()}");

            // Get the full body HTML content
            String? html = await controller.evaluateJavascript(source: "document.documentElement.innerHTML;");

            if (html != null) {
              log("🔍 Page HTML: \$ $html");
            } else {
              debugPrint("❌ Failed to retrieve page HTML");
            }
            // Hide the element with class "credits"
            await controller.evaluateJavascript(
              source: """
                try {
                  var el = document.querySelector('.credits');
                  var clippedCardEle = document.querySelector('.clippedCard');
                  if (el) {
                    el.style.display = 'none';
                  }
                  
                  if (clippedCardEle) {
                    clippedCardEle.style.display = 'none';
                  }
                } catch (e) {
                  console.log("JS Error: ", e);
                }
              """,
            );

            await Future.delayed(const Duration(milliseconds: 500));
            String js = """
              document.querySelectorAll('.payment-mode__card').forEach(function(card) {
                const titleElement = card.querySelector('.flex-center .mode .title');
                if (titleElement && (titleElement.textContent.trim() === 'Pay through UPI apps' || titleElement.textContent.trim() === 'Pay through UPI QR Codes')) {
                  card.style.display = 'flex';
                } else {
                  card.style.display = 'none';
                }
              });
            """;
            await controller.evaluateJavascript(source: js);
            // Future.delayed(Duration(milliseconds: 30), () async {

            // });

            ///https://payqr.in/payment7/instant-pay/60399f635c35c165816ca4d352208bd2ebc7234c99455ffdb5a4d031151a70ca#
            bool clickedPaytmUpi = url.toString().contains("paytmmp://");
            bool clickedShareGooglePlay = url.toString().contains("gpay://");
            bool clickedPhonePlay = url.toString().contains("phonepe://");

            if (clickedPaytmUpi || clickedShareGooglePlay || clickedPhonePlay) {
              try {
                if (await canLaunchUrl(url!)) {
                  await launchUrl(url);
                  await controller.goBack();
                } else {
                  await controller.goBack();
                }
              } catch (err, stk) {
                if (controller.canGoBack() == true) await controller.goBack();
                AppToast.showError(context,"", "Can't open application right now");
                print("Catch ERROR ON :-----> $err, ----> $stk");
              }
            } else if (url.toString().contains("https://api.abcgate.shop/payment-processed")) {
              AppToast.showError(context,"", "Navigating to home screen, Please Wait");
              await Future.delayed(const Duration(seconds: 3));
              context.read<GetProfileCubit>().getProfile();
              context.read<GetSettingCubit>().getSetting();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
                (route) => false,
              );
            }
          },
          onProgressChanged: (controller, progress) {},
          onUpdateVisitedHistory: (controller, url, isReload) {},
          onConsoleMessage: (controller, consoleMessage) {
            print('Console message:-- ' + consoleMessage.toString());
          },
        ),
      ),
    );
  }
}
