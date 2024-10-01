import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/utils/my_icons.dart';
import 'package:local_coin/core/utils/styles.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../core/route/route.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex; // The current index passed in
  const CustomBottomNav({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  final autoSizeGroup = AutoSizeGroup();
  late int bottomNavIndex;

  // List of icons
  final iconList = <String>[
    MyIcons.marketPlaceIcon,
    MyIcons.walletIcon,
    MyIcons.homeIcon,
    MyIcons.tradeIcon,
    MyIcons.menuIcon
  ];

  // List of text labels
  final textList = [
    MyStrings.market,
    MyStrings.wallet,
    MyStrings.home,
    MyStrings.trade,
    MyStrings.menu
  ];

  @override
  void initState() {
    // Set the initial active index to the one passed via widget.currentIndex
    bottomNavIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      elevation: 0,
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        // Check if the tab is active and apply styles accordingly
        final color =
            isActive ? MyColor.colorWhite : MyColor.colorWhite.withOpacity(0.5);
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconList[index],
              height: 20,
              width: 20,
              fit: BoxFit.cover,
              color: color, // Highlight icon color based on active state
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: AutoSizeText(
                textList[index].tr,
                maxLines: 1,
                style: robotoRegular.copyWith(
                    color: color), // Highlight text color based on active state
                group: autoSizeGroup,
              ),
            )
          ],
        );
      },
      backgroundColor: MyColor.primaryColor,
      borderColor: MyColor.primaryColor,
      splashColor: MyColor.colorWhite,
      splashSpeedInMilliseconds: 150,
      notchSmoothness: NotchSmoothness.defaultEdge,
      gapLocation: GapLocation.none,
      leftCornerRadius: 10,
      rightCornerRadius: 10,
      onTap: (index) {
        _onTap(index); // Handle tab taps
      },
      activeIndex: bottomNavIndex, // Set the active tab index
    );
  }

  // Handle the tapping of a navigation item
  void _onTap(int index) {
    if (index == bottomNavIndex) {
      return; // If the tab is already active, do nothing
    }

    // Update the active tab index
    setState(() {
      bottomNavIndex = index;
    });

    // Navigate to the corresponding screen based on the index
    switch (index) {
      case 0:
        Get.offNamed(RouteHelper.marketPlaceScreen); // Navigate to Marketplace
        break;
      case 1:
        Get.offNamed(RouteHelper.walletScreen); // Navigate to Wallet
        break;
      case 2:
        Get.offNamed(RouteHelper.homeScreen); // Navigate to Home
        break;
      case 3:
        Get.offNamed(RouteHelper.tradeScreen); // Navigate to Trade
        break;
      case 4:
        Get.offNamed(RouteHelper.menuScreen); // Navigate to Menu
        break;
      default:
        break;
    }
  }
}
