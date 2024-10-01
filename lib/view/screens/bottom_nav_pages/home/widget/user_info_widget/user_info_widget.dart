import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/core/route/route.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/my_color.dart';
import 'package:local_coin/core/utils/my_images.dart';
import 'package:local_coin/data/controller/home/home_controller.dart';
import 'package:local_coin/view/components/buttons/circle_button_with_icon.dart';

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({Key? key}) : super(key: key);

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => Column(
        children: [
          Stack(
            children: [
              Container(
                height: 150, // Adjust the height as needed
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(36, 84, 84, 1),
                      MyColor.primaryColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 60),
                child: Row(
                  children: [
                    CircleButtonWithIcon(
                      bg: MyColor.customColor,
                      isIcon: false,
                      isAsset: true,
                      imagePath: 'assets/images/profile.png',
                      circleSize: 30,
                      imageSize: 30,
                      padding: 2,
                      press: () {
                        Get.toNamed(RouteHelper.profileScreen);
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.user?.username ?? '',
                            style: TextStyle(
                              color: MyColor.colorWhite,
                              fontSize: Dimensions.fontLarge,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            controller.user?.address ?? "", // Removed 'country' reference
                            style: TextStyle(
                              color: MyColor.colorWhite,
                              fontSize: Dimensions.fontSmall,
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(RouteHelper.notificationScreen)?.then((value) {
                          controller.changeNewNotification(false);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: MyColor.customColor,
                        ),
                        child: Image.asset(
                          controller.hasNewNotification
                              ? MyImages.menuInactiveNotification
                              : MyImages.menuNotification,
                          height: 25,
                          width: 23,
                        ),
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
          // Other content of the page if any can go here
        ],
      ),
    );
  }
}
