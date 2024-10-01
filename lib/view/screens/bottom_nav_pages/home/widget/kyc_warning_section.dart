import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/utils/styles.dart';

import '../../../../../../core/route/route.dart';
import '../../../../../../core/utils/dimensions.dart';
import '../../../../../../core/utils/my_color.dart';

import '../../../../../../data/controller/home/home_controller.dart';

class KYCWarningSection extends StatelessWidget {
  final HomeController controller;
  const KYCWarningSection({
    super.key,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !controller.isKycVerified && !controller.isLoading,
      child: Container(
        padding: const EdgeInsetsDirectional.only(top: Dimensions.space15, bottom: Dimensions.space15 - 5),
        margin: const EdgeInsets.only(
          left: Dimensions.space15,
          right: Dimensions.space15,
        ),
        child: InkWell(
          onTap: () {
            Get.toNamed(RouteHelper.kycScreen);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: controller.isKycPending ? MyColor.warningColor.withOpacity(.1) : MyColor.redCancelTextColor.withOpacity(.1),
              border: Border.all(color: MyColor.redCancelTextColor, width: .5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.isKycPending ? MyStrings.kycUnderReviewMsg.tr : MyStrings.kycVerificationRequired.tr,
                  style: robotoBold.copyWith(color: controller.isKycPending ? MyColor.warningColor : MyColor.red),
                ),
                const SizedBox(width: 10),
                Text(
                  controller.isKycPending ? MyStrings.kycPendingMsg.tr : MyStrings.kycVerificationMsg.tr,
                  style: robotoRegular.copyWith(color: MyColor.textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
