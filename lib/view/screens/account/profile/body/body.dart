import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/styles.dart';
import 'package:local_coin/core/utils/url_container.dart';
import 'package:local_coin/view/components/rounded_button.dart';
import 'package:local_coin/view/screens/account/profile/body/profile_shimmer.dart';

import '../../../../../../../../../core/utils/my_color.dart';
import '../../../../../../data/controller/account/profile_controller.dart';
import '../../../../components/custom_text_field.dart';
import 'profile_image.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyColor.bgColor,
        ),
        child: controller.isLoading
            ? const ProfileShimmer()
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ProfileWidget(
                        isEdit: true,
                        imagePath: '${UrlContainer.profileImagePath}${controller.imageUrl}',
                        onClicked: () async {
                          print(controller.imageUrl);
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Text(
                      controller.model.data?.user?.username ?? '',
                      style: mulishSemiBold.copyWith(fontSize: Dimensions.fontExtraLarge),
                    )),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: MyColor.primaryColor,
                        ),
                        // SvgPicture.asset(MyIcons.transferNewIcon,height: 20,width: 20,),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          controller.model.data?.user?.countryName ?? '---',
                          style: mulishRegular,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    CustomTextField(
                      labelText: MyStrings.firstName,
                      hintText: '',
                      isShowBorder: true,
                      isPassword: false,
                      isShowSuffixIcon: false,
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      focusNode: controller.firstNameFocusNode,
                      controller: controller.firstNameController,
                      onChanged: (value) {
                        return;
                      },
                      nextFocus: controller.lastNameFocusNode,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      labelText: MyStrings.lastName,
                      hintText: '',
                      isShowBorder: true,
                      isPassword: false,
                      isShowSuffixIcon: false,
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      focusNode: controller.lastNameFocusNode,
                      controller: controller.lastNameController,
                      onChanged: (value) {
                        return;
                      },
                      nextFocus: controller.addressFocusNode,
                    ),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          labelText: MyStrings.emailAddress,
                          hintText: '',
                          isShowBorder: true,
                          isPassword: false,
                          fillColor: MyColor.primaryColor900,
                          isShowSuffixIcon: false,
                          isEnabled: false,
                          controller: controller.emailController,
                          onChanged: (value) {
                            return;
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: MyStrings.mobileNumber,
                          hintText: '',
                          isShowBorder: true,
                          isPassword: false,
                          fillColor: MyColor.primaryColor900,
                          isEnabled: false,
                          isShowSuffixIcon: false,
                          controller: controller.mobileNoController,
                          onSuffixTap: () {},
                          onChanged: (value) {
                            return;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                    CustomTextField(
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
                    Center(
                      child: RoundedButton(
                        text: MyStrings.updateProfile,
                        press: () {
                          controller.updateProfile();
                        },
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
