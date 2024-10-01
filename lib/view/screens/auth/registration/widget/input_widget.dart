import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/core/helper/string_format_helper.dart';
import 'package:local_coin/core/utils/my_color.dart';
import 'package:local_coin/view/components/rounded_loading_button.dart';
import 'package:local_coin/view/components/validation_widget/validation_widget.dart';

import '../../../../../constants/my_strings.dart';
import '../../../../../core/route/route.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../data/controller/auth/auth/registration_controller.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../components/rounded_button.dart';
import 'strong_pass_list_item.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({Key? key}) : super(key: key);

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  double space = 18;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
        builder: (controller) => Center(
              child: Container(
                padding: EdgeInsets.all(16.0), // Padding inside the box
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Margin around the box
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for the box
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 66, 105, 87).withOpacity(0.6), // Fully colored and darker shadow
                      spreadRadius: 5, // Increases the shadow area
                      blurRadius: 20, // Higher blur to spread the shadow smoothly
                      offset: Offset(0, 10), // Shadow position (higher y-offset)
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: space),
                      CustomTextFormField(
                        isUnderline: true,
                        label: MyStrings.firstName,
                        fillColor: MyColor.bgColor1,
                        controller: controller.fNameController,
                        focusNode: controller.firstNameFocusNode,
                        inputType: TextInputType.text,
                        nextFocus: controller.lastNameFocusNode,
                        hintText: MyStrings.enterYourUserName,
                        maxLines: 1,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return MyStrings.kFirstNameNullError.tr;
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          return;
                        },
                      ),
                      SizedBox(height: space),
                      CustomTextFormField(
                        isUnderline: true,
                        label: MyStrings.lastName,
                        fillColor: MyColor.bgColor1,
                        controller: controller.lNameController,
                        focusNode: controller.lastNameFocusNode,
                        inputType: TextInputType.text,
                        nextFocus: controller.emailFocusNode,
                        hintText: MyStrings.lastName,
                        maxLines: 1,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return MyStrings.kLastNameNullError.tr;
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          return;
                        },
                      ),
                      SizedBox(height: space),
                      CustomTextFormField(
                          isUnderline: true,
                          label: MyStrings.email,
                          fillColor: MyColor.bgColor1,
                          controller: controller.emailController,
                          focusNode: controller.emailFocusNode,
                          hintText: MyStrings.enterYourEmail,
                          nextFocus: controller.passwordFocusNode,
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return MyStrings.kEmailNullError.tr;
                            } else if (!MyStrings.emailValidatorRegExp.hasMatch(value ?? '')) {
                              return MyStrings.kInvalidEmailError.tr;
                            } else {
                              return null;
                            }
                          },
                          inputType: TextInputType.emailAddress,
                          inputAction: TextInputAction.next,
                          onChanged: (value) {
                            return;
                          }),
                      SizedBox(height: space),
                      Visibility(
                          visible: controller.hasPasswordFocus && controller.checkPasswordStrength,
                          child: ValidationWidget(
                            list: controller.passwordValidationRulse,
                          )),
                      Focus(
                        onFocusChange: (hasFocus) {
                          controller.changePasswordFocus(hasFocus);
                        },
                        child: CustomTextFormField(
                            isUnderline: true,
                            label: MyStrings.password,
                            controller: controller.passwordController,
                            focusNode: controller.passwordFocusNode,
                            nextFocus: controller.confirmPasswordFocusNode,
                            hintText: MyStrings.enterYourPassword_,
                            isShowSuffixIcon: true,
                            fillColor: MyColor.bgColor1,
                            isPassword: true,
                            inputType: TextInputType.text,
                            validator: (String? value) {
                              return controller.validatPassword(value ?? '');
                            },
                            onChanged: (value) {
                              if (controller.checkPasswordStrength) {
                                controller.updateValidationList(value);
                              }
                            }),
                      ),
                      SizedBox(height: space),
                      CustomTextFormField(
                          isUnderline: true,
                          label: MyStrings.confirmPassword,
                          controller: controller.cPasswordController,
                          focusNode: controller.confirmPasswordFocusNode,
                          inputAction: TextInputAction.done,
                          isPassword: true,
                          fillColor: MyColor.bgColor1,
                          hintText: MyStrings.confirmYourPassword,
                          isShowSuffixIcon: true,
                          validator: (String? value) {
                            if (controller.passwordController.text.toLowerCase() !=
                                controller.cPasswordController.text.toLowerCase()) {
                              return MyStrings.kMatchPassError.tr;
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            return;
                          }),
                      SizedBox(height: space),
                      CustomTextFormField(
                          isUnderline: true,
                          label: MyStrings.referral,
                          fillColor: MyColor.bgColor1,
                          controller: controller.referNameController,
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          onChanged: (value) {
                            return;
                          }),
                      SizedBox(height: space),
                      controller.needAgree
                          ? Row(
                              children: [
                                SizedBox(
                                  child: Checkbox(
                                      side: WidgetStateBorderSide.resolveWith(
                                          (states) => BorderSide(width: 2, color: controller.agreeTC ? Colors.transparent : Colors.black)),
                                      activeColor: MyColor.primaryColor,
                                      value: controller.agreeTC,
                                      onChanged: (value) {
                                        controller.updateAgreeTC();
                                      }),
                                ),
                                Flexible(
                                    child: Text.rich(TextSpan(text: '${MyStrings.iAgreeWith.tr} ', style: mulishRegular, children: [
                                  TextSpan(
                                      text: MyStrings.privacyAndPolicy.tr.toLowerCase(),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.toNamed(RouteHelper.privacyScreen);
                                        },
                                      style: mulishBold.copyWith(color: Colors.red, decoration: TextDecoration.underline)),
                                ])))
                              ],
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 30,
                      ),
                      controller.submitLoading
                          ? const RoundedLoadingBtn()
                          : RoundedButton(
                              text: MyStrings.submit,
                              press: () {
                                if (_formKey.currentState!.validate()) {
                                  controller.signUpUser();
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
