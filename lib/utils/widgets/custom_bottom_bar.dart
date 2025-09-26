import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:elite/constant/app_image.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  double _glowOpacity = 0.0;

  @override
  void didUpdateWidget(CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _animateGlow();
    }
  }

  void _animateGlow() async {
    setState(() => _glowOpacity = 0.3);
    await Future.delayed(const Duration(milliseconds: 120));
    setState(() => _glowOpacity = 0.6);
    await Future.delayed(const Duration(milliseconds: 120));
    setState(() => _glowOpacity = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {"icon": AppImages.homeSvg, "label": "Home".tr()},
      {"icon": AppImages.trailerSvg, "label": "Trailer".tr()},
      {"icon": AppImages.musicSvg, "label": "Music".tr()},
      {"icon": AppImages.searchSvg, "label": "Search".tr()},
      {"icon": AppImages.downloadSvg, "label": "Downloads".tr()},
      {"icon": AppImages.profileSvg, "label": "Profile".tr()},
    ];

    return Theme(
      data: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          currentIndex: widget.currentIndex,
          onTap: widget.onTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          items: items.map((item) {
            int index = items.indexOf(item);
            bool isSelected = index == widget.currentIndex;

            return BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: isSelected
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(63, 173, 213, 1).withOpacity(_glowOpacity),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      )
                    : null,
                child: AnimatedScale(
                  scale: isSelected ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: SvgPicture.asset(
                    item['icon'],
                    color: isSelected ? Colors.white : Colors.grey,
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
              label: item['label'],
            );
          }).toList(),
        ),
      ),
    );
  }
}
