import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/utils/styles.dart';
import 'package:local_coin/data/controller/auth/two_factor_controller.dart';
import 'package:local_coin/view/components/rounded_button.dart';
import 'package:local_coin/view/components/rounded_loading_button.dart';
import 'package:local_coin/view/screens/bottom_nav_pages/trade/trade_details_screen/widget/acition_widget/show_divider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../../core/utils/dimensions.dart';
import '../../../../../../core/utils/my_color.dart';

import '../widget/enable_qr_code_widget.dart';

class TwoFactorEnableSection extends StatelessWidget {
  const TwoFactorEnableSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoFactorController>(builder: (twoFactorController) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space15),
                decoration: BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        MyStrings.addYourAccount.tr,
                        style: robotoBold,
                      ),
                    ),
                    const CustomDivider(),
                    Center(
                      child: Text(
                        MyStrings.useQRCODETips.tr,
                        style: robotoBold,
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.space12,
                    ),
                    if (twoFactorController.twoFactorCodeModel.data?.qrCodeUrl != null) ...[EnableQRCodeWidget(qrImage: twoFactorController.twoFactorCodeModel.data?.qrCodeUrl ?? '', secret: "${twoFactorController.twoFactorCodeModel.data?.secret}")]
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),

              // enable

              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space15),
                  decoration: BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.circular(10)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Center(
                      child: Text(
                        MyStrings.enable2Fa.tr,
                        style: robotoBold,
                      ),
                    ),
                    const CustomDivider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .07),
                      child: Text(MyStrings.twoFactorMsg.tr, maxLines: 3, textAlign: TextAlign.center, style: robotoRegular.copyWith(color: MyColor.getLabelTextColor())),
                    ),
                    const SizedBox(height: Dimensions.space50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30),
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: robotoRegular.copyWith(color: MyColor.textColor),
                        length: 6,
                        textStyle: robotoRegular.copyWith(color: MyColor.textColor),
                        obscureText: false,
                        obscuringCharacter: '*',
                        blinkWhenObscuring: false,
                        animationType: AnimationType.fade,
                        pinTheme:
                            PinTheme(shape: PinCodeFieldShape.box, borderWidth: 1, borderRadius: BorderRadius.circular(5), fieldHeight: 40, fieldWidth: 40, inactiveColor: MyColor.textFieldDisableBorderColor, inactiveFillColor: Colors.transparent, activeFillColor: Colors.transparent, activeColor: MyColor.primaryColor, selectedFillColor: Colors.transparent, selectedColor: MyColor.primaryColor),
                        cursorColor: MyColor.colorWhite,
                        animationDuration: const Duration(milliseconds: 100),
                        enableActiveFill: true,
                        keyboardType: TextInputType.number,
                        beforeTextPaste: (text) {
                          return true;
                        },
                        onChanged: (value) {
                          twoFactorController.currentText = value;
                          twoFactorController.update();
                        },
                      ),
                    ),
                    const SizedBox(height: Dimensions.space30),
                    twoFactorController.submitLoading
                        ? const RoundedLoadingBtn()
                        : RoundedButton(
                            press: () {
                              twoFactorController.enable2fa(twoFactorController.twoFactorCodeModel.data?.secret ?? '', twoFactorController.currentText);
                            },
                            text: MyStrings.submit.tr,
                          ),
                    const SizedBox(height: Dimensions.space30),
                  ])),
            ],
          ),
        ),
      );
    });
  }
}
