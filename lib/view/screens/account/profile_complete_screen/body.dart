import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/my_images.dart';
import 'package:local_coin/core/utils/styles.dart';
import 'package:local_coin/core/utils/url_container.dart';
import 'package:local_coin/data/controller/auth/profile_complete_controller.dart';
import 'package:local_coin/view/components/image/my_image_widget.dart';
import 'package:local_coin/view/components/rounded_loading_button.dart';
import 'package:local_coin/view/screens/account/profile/body/profile_shimmer.dart';
import 'package:local_coin/view/screens/auth/registration/widget/country_bottom_sheet.dart';

import '../../../../../../../../core/utils/my_color.dart';
import '../../../../../constants/my_strings.dart';
import '../../../components/custom_text_field.dart';
import '../../../components/rounded_button.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileCompleteController>(
        builder: (controller) => Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MyColor.bgColor1,
              ),
              child: controller.isLoading
                  ? const ProfileShimmer()
                  : SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            // ProfileWidget(isEdit: false, imagePath: MyImages.profile, onClicked: () async {}),
                            Align(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(MyImages.profile, height: 70, width: 70),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const SizedBox(height: 2),
                            CustomTextField(
                              hideLabel: false,
                              labelText: MyStrings.username,
                              hintText: '',
                              isShowBorder: true,
                              isPassword: false,
                              isShowSuffixIcon: false,
                              isRequired: true,
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              focusNode: controller.userNameFocusNode,
                              controller: controller.usernameController,
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return MyStrings.kFirstNameNullError.tr;
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                return;
                              },
                              nextFocus: controller.emailFocusNode,
                            ),
                            const SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                CountryBottomSheet.profileCompleteCountryBottomSheet(context, controller);
                              },
                              child: Container(
                                width: context.width,
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                  border: Border.all(color: MyColor.borderColor, width: 1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        if (controller.countryCode != null) ...[
                                          MyImageWidget(
                                            imageUrl: UrlContainer.countryFlagImageLink.replaceAll('{countryCode}', controller.countryCode.toString().toLowerCase()),
                                            height: Dimensions.space25,
                                            width: Dimensions.space40 + 2,
                                            radius: 2,
                                          ),
                                          const SizedBox(width: Dimensions.space10),
                                          Text(controller.countryName ?? '', style: robotoRegular.copyWith()),
                                        ] else ...[
                                          Text(MyStrings.selectACountry, style: robotoRegular.copyWith()),
                                        ],
                                      ],
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: MyColor.colorGrey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              hideLabel: false,
                              labelText: MyStrings.mobileNumber,
                              hintText: '',
                              isShowBorder: true,
                              isPassword: false,
                              isShowSuffixIcon: false,
                              isRequired: true,
                              inputType: TextInputType.number,
                              inputAction: TextInputAction.next,
                              focusNode: controller.mobileNoFocusNode,
                              controller: controller.mobileNoController,
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return MyStrings.kLastNameNullError.tr;
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                return;
                              },
                              nextFocus: controller.addressFocusNode,
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              hideLabel: false,
                              labelText: MyStrings.address,
                              hintText: '',
                              isShowBorder: true,
                              isPassword: false,
                              isShowSuffixIcon: false,
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              focusNode: controller.addressFocusNode,
                              controller: controller.addressController,
                              onSuffixTap: () {},
                              onChanged: (value) {
                                return;
                              },
                              nextFocus: controller.stateFocusNode,
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              hideLabel: false,
                              labelText: MyStrings.state,
                              hintText: '',
                              isShowBorder: true,
                              isPassword: false,
                              isShowSuffixIcon: false,
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              focusNode: controller.stateFocusNode,
                              controller: controller.stateController,
                              onSuffixTap: () {},
                              onChanged: (value) {
                                return;
                              },
                              nextFocus: controller.zipCodeFocusNode,
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              hideLabel: false,
                              labelText: MyStrings.zipCode,
                              hintText: '',
                              isShowBorder: true,
                              isPassword: false,
                              isShowSuffixIcon: false,
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              focusNode: controller.zipCodeFocusNode,
                              controller: controller.zipCodeController,
                              onSuffixTap: () {},
                              onChanged: (value) {
                                return;
                              },
                              nextFocus: controller.cityFocusNode,
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              hideLabel: false,
                              labelText: MyStrings.city,
                              hintText: '',
                              isShowBorder: true,
                              isPassword: false,
                              isShowSuffixIcon: false,
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.done,
                              focusNode: controller.cityFocusNode,
                              controller: controller.cityController,
                              onSuffixTap: () {},
                              onChanged: (value) {
                                return;
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            controller.submitLoading
                                ? const RoundedLoadingBtn()
                                : RoundedButton(
                                    text: MyStrings.completeProfile,
                                    press: () {
                                      if (formKey.currentState!.validate()) {
                                        controller.updateProfile();
                                      }
                                    }),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
            ));
  }
}
