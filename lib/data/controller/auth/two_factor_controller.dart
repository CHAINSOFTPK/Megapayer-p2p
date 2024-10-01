import 'dart:convert';

import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/helper/shared_pref_helper.dart';
import 'package:local_coin/core/route/route.dart';
import 'package:local_coin/data/model/auth/two_factor/two_factor_data_model.dart';
import 'package:local_coin/data/model/authorization/AuthorizationResponseModel.dart';
import 'package:local_coin/data/model/global/response_model/response_model.dart';
import 'package:local_coin/data/repo/auth/two_factor_repo.dart';
import 'package:local_coin/view/components/show_custom_snackbar.dart';

class TwoFactorController extends GetxController {
  TwoFactorRepo repo;
  TwoFactorController({required this.repo});

  bool submitLoading = false;
  String currentText = '';
  verifyYourSms(String currentText) async {
    if (currentText.isEmpty) {
      CustomSnackbar.showCustomSnackbar(errorList: [MyStrings.otpEmptyMsg], msg: [], isError: true);
      return;
    }

    submitLoading = true;
    update();

    ResponseModel responseModel = await repo.verify(currentText);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));

      if (model.status == MyStrings.success.toLowerCase()) {
        CustomSnackbar.showCustomSnackbar(errorList: [], msg: model.message?.success ?? [MyStrings.requestSuccess], isError: false);

        String pin = repo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.screenLockPin) ?? '';
        if (pin.isEmpty || pin == 'null') {
          Get.offAndToNamed(RouteHelper.createPinScreen);
        } else {
          Get.offAndToNamed(RouteHelper.homeScreen);
        }
      } else {
        CustomSnackbar.showCustomSnackbar(errorList: model.message?.error ?? [MyStrings.requestFail], msg: [], isError: true);
      }
    } else {
      CustomSnackbar.showCustomSnackbar(errorList: [responseModel.message], msg: [], isError: true);
    }
    submitLoading = false;
    update();
  }

  void enable2fa(String key, String code) async {
    if (code.isEmpty) {
      CustomSnackbar.showCustomSnackbar(errorList: [MyStrings.otpFieldEmptyMsg], msg: [], isError: true);
      return;
    }

    submitLoading = true;
    update();

    ResponseModel responseModel = await repo.enable2fa(key, code);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status.toString() == MyStrings.success.toString().toLowerCase()) {
        Get.back();
        CustomSnackbar.showCustomSnackbar(msg: model.message?.success ?? [MyStrings.requestSuccess], errorList: [], isError: false);
      } else {
        CustomSnackbar.showCustomSnackbar(errorList: model.message?.error ?? [MyStrings.requestFail], msg: [], isError: true);
      }
    } else {
      CustomSnackbar.showCustomSnackbar(errorList: [responseModel.message], msg: [], isError: true);
    }
    submitLoading = false;
    update();
  }

  void disable2fa(String code) async {
    if (code.isEmpty) {
      CustomSnackbar.showCustomSnackbar(errorList: [MyStrings.otpFieldEmptyMsg], msg: [], isError: true);
      return;
    }

    submitLoading = true;
    update();

    ResponseModel responseModel = await repo.disable2fa(code);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));

      if (model.status.toString() == MyStrings.success.toString().toLowerCase()) {
        Get.back();
        CustomSnackbar.showCustomSnackbar(msg: model.message?.success ?? [MyStrings.requestSuccess], errorList: [], isError: false);
      } else {
        CustomSnackbar.showCustomSnackbar(errorList: model.message?.error ?? [MyStrings.requestFail], isError: true, msg: []);
      }
    } else {
      CustomSnackbar.showCustomSnackbar(errorList: [responseModel.message], msg: [], isError: true);
    }
    submitLoading = false;
    update();
  }

  bool isLoading = false;
  TwoFactorCodeModel twoFactorCodeModel = TwoFactorCodeModel();

  void get2FaCode() async {
    isLoading = true;
    update();

    ResponseModel responseModel = await repo.get2FaData();

    if (responseModel.statusCode == 200) {
      TwoFactorCodeModel model = twoFactorCodeModelFromJson(responseModel.responseJson);

      if (model.status.toString() == MyStrings.success.toString().toLowerCase()) {
        twoFactorCodeModel = model;
        isLoading = false;
        update();
      } else {
        CustomSnackbar.showCustomSnackbar(errorList: model.message?.error ?? [MyStrings.requestFail], isError: true, msg: []);
      }
    } else {
      CustomSnackbar.showCustomSnackbar(errorList: [responseModel.message], isError: true, msg: []);
    }
    isLoading = false;
    update();
  }
}
