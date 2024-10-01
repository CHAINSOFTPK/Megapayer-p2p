import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/my_strings.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_icons.dart';
import '../../../../core/utils/styles.dart';
import '../../../../data/controller/wallet/wallet_address_controller/wallet_address_controller.dart';
import '../../../components/buttons/circle_button_with_icon.dart';
import '../../../components/rounded_button.dart';
import '../../../components/rounded_loading_button.dart';

void showAlertDialog(BuildContext context) async {
  Get.defaultDialog(
    title: '',
    backgroundColor: MyColor.applightColor,
    contentPadding: const EdgeInsets.all(0),
    titlePadding: const EdgeInsets.all(0),
    titleStyle: const TextStyle(color: Colors.white),
    middleTextStyle: const TextStyle(color: Colors.white),
    content: Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: MyColor.applightColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          // Add the close button (cross icon) at the top-right corner
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close, color: MyColor.primaryColor),
              onPressed: () {
                Get.back(); // Close the dialog
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: CircleButtonWithIcon(
              press: () {},
              isIcon: true,
              isSvg: true,
              imagePath: MyIcons.questionIcon,
              bg: MyColor.bgColor1,
              circleSize: 38,
              padding: 8,
              iconSize: 35,
              iconColor: MyColor.primaryColor,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: Text(
              MyStrings.dialogMsg.tr,
              style: mulishBold.copyWith(fontSize: Dimensions.fontLarge),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const Divider(
            color: MyColor.primaryColor,
            height: 1,
          ),
          const SizedBox(
            height: 25,
          ),
          GetBuilder<WalletAddressController>(
            builder: (controller) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: RoundedButton(
                      textColor: MyColor.colorBlack,
                      horizontalPadding: 12,
                      verticalPadding: 12,
                      press: () {
                        Get.back();
                      },
                      text: MyStrings.no,
                      color: MyColor.colorWhite,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: controller.generateAddressLoading
                        ? const RoundedLoadingBtn(
                            horizontalPadding: 12,
                            verticalPadding: 14,
                            color: MyColor.primaryColor,
                          )
                        : RoundedButton(
                            horizontalPadding: 12,
                            verticalPadding: 12,
                            press: () {
                              controller.generateNewAddress();
                            },
                            text: MyStrings.yes,
                            color: MyColor.primaryColor,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
