import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import '../../model/auth/login_response_model.dart';
import '../../model/global/response_model/response_model.dart';
import '../../../../view/components/show_custom_snackbar.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/route/route.dart';
import '../../repo/auth/login_repo.dart';

class LoginController extends GetxController {
  LoginRepo loginRepo;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<String> errors = [];
  String? email;
  String? password;
  bool isLoading = false;
  bool remember = false;

  LoginController({required this.loginRepo});

  void forgetPassword() {
    Get.toNamed(RouteHelper.forgetPasswordScreen);
  }

  void checkAndGotoNextStep(LoginResponseModel responseModel) async {
    bool needEmailVerification = responseModel.data?.user?.ev == "1" ? false : true;
    bool needSmsVerification = responseModel.data?.user?.sv == '1' ? false : true;
    bool isTwoFactorEnable = responseModel.data?.user?.tv == '1' ? false : true;
    bool needKycUnverified = responseModel.data?.user?.kv == '1' ? false : true;

    if (remember) {
      await loginRepo.apiClient.sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, true);
    } else {
      await loginRepo.apiClient.sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
    }

    await loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userIdKey, responseModel.data?.user?.id.toString() ?? '-1');
    await loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey, responseModel.data?.accessToken ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.accessTokenType, responseModel.data?.tokenType ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userEmailKey, responseModel.data?.user?.email ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userPhoneNumberKey, responseModel.data?.user?.mobile ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userNameKey, responseModel.data?.user?.username ?? '');

    await loginRepo.sendUserToken();

    bool isProfileCompleteEnable = responseModel.data?.user?.profileComplete == '0' ? true : false;

    if (isProfileCompleteEnable) {
      await Get.offAndToNamed(RouteHelper.profileComplete);
    } else if (needEmailVerification) {
      await Get.offAndToNamed(RouteHelper.emailVerificationScreen);
    } else if (needSmsVerification) {
      await Get.offAndToNamed(RouteHelper.smsVerificationScreen);
    } else if (isTwoFactorEnable) {
      await Get.offAndToNamed(RouteHelper.twoFactorScreen);
    } else if (needKycUnverified) {
      await Get.offAndToNamed(RouteHelper.kycScreen);
    } else {
      String pin = loginRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.screenLockPin) ?? '';
      if (pin.isEmpty || pin == 'null') {
        await Get.offAndToNamed(RouteHelper.createPinScreen);
      }
    }

    // Always navigate to MarketPlace screen after all checks
    Get.offAllNamed(RouteHelper.marketPlaceScreen);

    if (remember) {
      changeRememberMe();
    }
  }

  void loginUser() async {
    changeIsLoading();
    ResponseModel model = await loginRepo.loginUser(emailController.text.toString(), passwordController.text.toString());

    if (model.statusCode == 200) {
      LoginResponseModel loginModel = LoginResponseModel.fromJson(jsonDecode(model.responseJson));
      if (loginModel.status.toString().toLowerCase() == MyStrings.success.toLowerCase()) {
        checkAndGotoNextStep(loginModel);
      } else {
        CustomSnackbar.showCustomSnackbar(errorList: [loginModel.message?.error?.toString() ?? MyStrings.loginFailedTryAgain], msg: [], isError: true);
        changeIsLoading();
        return;
      }
    } else {
      CustomSnackbar.showCustomSnackbar(errorList: [model.message], msg: [], isError: true);
      changeIsLoading();
    }
  }

  void changeIsLoading() {
    isLoading = !isLoading;
    update();
  }

  changeRememberMe() {
    remember = !remember;
    update();
  }

  rememberMe() async {
    await loginRepo.apiClient.sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, true);
  }

  void clearAllSharedPreData() {
    loginRepo.apiClient.sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
    loginRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey, '');
    return;
  }
}