import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/data/controller/auth/auth/social_login_controller.dart';
import 'package:local_coin/data/repo/auth/social_login_repo.dart';
import 'package:local_coin/view/components/rounded_loading_button.dart';
import 'package:local_coin/view/components/will_pop_widget.dart';

import '../../../../../../../core/utils/my_color.dart';
import '../../../../core/route/route.dart';
import '../../../../core/utils/styles.dart';
import '../../../../data/controller/auth/login_controller.dart';
import '../../../../data/repo/auth/login_repo.dart';
import '../../../../data/services/api_service.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../components/rounded_button.dart';
import '.././../../../core/utils/dimensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Get.put(ApiClient(sharedPreferences: Get.find()), permanent: true);
    Get.put(LoginRepo(sharedPreferences: Get.find(), apiClient: Get.find()), permanent: true);
    Get.put(LoginController(loginRepo: Get.find()), permanent: true);
    Get.put(SocialLoginRepo(apiClient: Get.find()), permanent: true);
    Get.put(SocialLoginController(repo: Get.find()), permanent: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppLock.of(context)?.setEnabled(true);
      Get.find<LoginController>().isLoading = false;
      Get.find<LoginController>().remember = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) => WillPopWidget(
        nextRoute: '',
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        const Center(
                          child: Text(
                            MyStrings.wellComeBack,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Color(0xFF1d5550),
                              shadows: [
                                Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 1.0,
                                  color: Color.fromARGB(255, 198, 185, 185),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Center(
                          child: Text(
                            MyStrings.happyToSeeYouAgain,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Form Box
                        Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF1d5550).withOpacity(0.5),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                isUnderline: true,
                                hintText: MyStrings.enterUserNameOrEmail,
                                isShowBorder: true,
                                isPassword: false,
                                isShowPrefixIcon: false,
                                controller: controller.emailController,
                                isShowSuffixIcon: false,
                                fillColor: Color(0xFFd2dddd),
                                label: MyStrings.emailOrUserName,
                                inputType: TextInputType.emailAddress,
                                inputAction: TextInputAction.next,
                                focusNode: controller.emailFocusNode,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return MyStrings.enterEmailOrUsername.tr;
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  return;
                                },
                                nextFocus: controller.passwordFocusNode,
                              ),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                isShowBorder: true,
                                controller: controller.passwordController,
                                focusNode: controller.passwordFocusNode,
                                hintText: MyStrings.enterYourPassword_,
                                fillColor: Color(0xFFd2dddd),
                                isShowSuffixIcon: true,
                                label: MyStrings.password,
                                isUnderline: true,
                                isShowPrefixIcon: false,
                                isPassword: true,
                                inputType: TextInputType.text,
                                inputAction: TextInputAction.done,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return MyStrings.kPassNullError.tr;
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {},
                              ),
                              const SizedBox(height: 30),
                              controller.isLoading
                                  ? const RoundedLoadingBtn()
                                  : RoundedButton(
                                      press: () {
                                        try {
                                          print("Login button pressed");
                                          if (formKey.currentState!.validate()) {
                                            print("Form is valid, attempting to login");
                                            controller.loginUser();
                                          } else {
                                            print("Form is invalid");
                                          }
                                        } catch (e, stackTrace) {
                                          print("Error during login: $e");
                                          print("Stack trace: $stackTrace");
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("An error occurred during login. Please try again.")),
                                          );
                                        }
                                      },
                                      text: MyStrings.login,
                                    ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 23,
                                          height: 25,
                                          child: Checkbox(
                                            activeColor: Color(0xFF1d5550),
                                            value: controller.remember,
                                            side: BorderSide(
                                              width: 1.0,
                                              color: controller.remember
                                                  ? Color(0xFFd2dddd)
                                                  : Color(0xFF1d5550),
                                            ),
                                            onChanged: (value) {
                                              controller.changeRememberMe();
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Flexible(
                                          child: Text(
                                            MyStrings.rememberMe.tr,
                                            style: mulishSemiBold.copyWith(
                                              fontSize: Dimensions.fontDefault,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(RouteHelper.forgetPasswordScreen);
                                    },
                                    child: Text(
                                      MyStrings.forgetPassword.tr,
                                      style: mulishSemiBold.copyWith(
                                        color: Color(0xFF1d5550),
                                        fontSize: Dimensions.fontDefault,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  MyStrings.notAccount.tr,
                                  style: mulishRegular.copyWith(
                                      fontSize: Dimensions.fontLarge),
                                ),
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.emailController.text = '';
                                    controller.passwordController.text = '';
                                    controller.remember = false;
                                    Get.offAndToNamed(RouteHelper.registrationScreen);
                                  },
                                  child: Text(
                                    MyStrings.createNew.tr,
                                    style: mulishBold.copyWith(
                                        fontSize: 18,
                                        color: Color(0xFF1d5550)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            final result = await Get.toNamed(RouteHelper.languageScreen);
                            if (result == true) {
                              // Language changed, refresh the login screen
                              setState(() {});
                            }
                          },
                          child: Center(
                            child: Text(
                              "Select Language",
                              style: mulishSemiBold.copyWith(
                                fontSize: 16,
                                color: MyColor.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}