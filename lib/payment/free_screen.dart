import 'package:flutter/material.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_string.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class FreeScreen extends StatefulWidget {
  const FreeScreen({super.key});

  @override
  State<FreeScreen> createState() => _FreeScreenState();
}

class _FreeScreenState extends State<FreeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: AppColor.whiteColor,
        ),
        automaticallyImplyLeading: true,
        title: const TextWidget(
          text: "Free Features",
          color: AppColor.whiteColor,
          fontSize: 14,
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Title
              Text(
                "${AppString.appName} App is Totally Free",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Subtitle
              const Text(
                "Enjoy unlimited access to all features without paying a single cent. "
                "No hidden fees, no subscriptions, just pure value for you.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Feature Cards
              const FeatureCard(
                icon: Icons.lock_open,
                title: "Unlimited Access",
                description: "Get access to all features without any limits.",
              ),
              const FeatureCard(
                icon: Icons.attach_money,
                title: "No Hidden Charges",
                description: "Absolutely free – no subscriptions or fees.",
              ),
              // FeatureCard(
              //   icon: Icons.star,
              //   title: "Premium Quality",
              //   description: "Enjoy a premium user experience at zero cost.",
              // ),
              const SizedBox(height: 30),
              GradientButton(
                onTap: () {
                  Navigator.pop(context);
                },
                text: 'Go Back',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: AppColor.whiteColor,
      color: AppColor.whiteColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.green[700],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
