import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/helper/shared_pref_helper.dart';
import 'package:local_coin/core/route/route.dart';
import 'package:local_coin/data/model/account/ProfileResponseModel.dart';
import 'package:local_coin/data/model/country_model/CountryModel.dart';
import 'package:local_coin/data/model/global/response_model/response_model.dart';
import 'package:local_coin/data/model/public_profile/profile_complete_post_model.dart';
import 'package:local_coin/data/model/public_profile/profile_complete_response_model.dart';
import 'package:local_coin/data/model/user/user.dart';
import 'package:local_coin/data/repo/account/profile_repo.dart';
import 'package:local_coin/environment.dart';
import 'package:local_coin/view/components/show_custom_snackbar.dart';

class ProfileCompleteController extends GetxController {
  ProfileRepo profileRepo;

  ProfileResponseModel model = ProfileResponseModel();

  ProfileCompleteController({required this.profileRepo});

  bool isLoading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  FocusNode userNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode mobileNoFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode zipCodeFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();

  bool countryLoading = true;
  List<Countries> countryList = [];
  List<Countries> filteredCountries = [];

  String? countryName;
  String? countryCode;
  String? mobileCode;

  Future<dynamic> getCountryData() async {
    ResponseModel mainResponse = await profileRepo.getCountryList();

    if (mainResponse.statusCode == 200) {
      CountryModel model = CountryModel.fromJson(jsonDecode(mainResponse.responseJson));
      List<Countries>? tempList = model.data?.countries;

      if (tempList != null && tempList.isNotEmpty) {
        countryList.clear();
        filteredCountries.clear();
        countryList.addAll(tempList);
        filteredCountries.addAll(tempList);
      }
      var selectDefCountry = tempList!.firstWhere(
        (country) => country.countryCode!.toLowerCase() == Environment.defaultCountryCode.toLowerCase(),
        orElse: () => Countries(),
      );
      if (selectDefCountry.dialCode != null) {
        setCountryNameAndCode(selectDefCountry.country.toString(), selectDefCountry.countryCode.toString(), selectDefCountry.dialCode.toString());
      }
    } else {
      CustomSnackbar.showCustomSnackbar(errorList: [mainResponse.message], msg: [], isError: true);
    }

    countryLoading = false;
    update();
  }

  bool submitLoading = false;
  updateProfile() async {
    String username = usernameController.text;
    String mobileNumber = mobileNoController.text;
    String address = addressController.text.toString();
    String city = cityController.text.toString();
    String zip = zipCodeController.text.toString();
    String state = stateController.text.toString();

    if (username.isEmpty) {
      CustomSnackbar.showCustomSnackbar(errorList: [MyStrings.kFirstNameNullError], isError: true, msg: []);
      return;
    }

    submitLoading = true;
    update();

    ProfileCompletePostModel model = ProfileCompletePostModel(
      username: username,
      countryName: countryName ?? "",
      countryCode: countryCode ?? "",
      mobileNumber: mobileNumber,
      mobileCode: mobileCode ?? "",
      address: address,
      state: state,
      zip: zip,
      city: city,
      image: null,
    );

    ResponseModel responseModel = await profileRepo.completeProfile(model);

    if (responseModel.statusCode == 200) {
      ProfileCompleteResponseModel model = ProfileCompleteResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        checkAndGotoNextStep(model.data?.user);
      } else {
        CustomSnackbar.showCustomSnackbar(errorList: model.message?.error ?? [MyStrings.requestFail], msg: [], isError: true);
      }
    } else {
      CustomSnackbar.showCustomSnackbar(errorList: [responseModel.message], msg: [], isError: true);
    }

    submitLoading = false;
    update();
  }

  void setCountryNameAndCode(String cName, String countryCode, String mobileCode) {
    countryName = cName;
    this.countryCode = countryCode;
    this.mobileCode = mobileCode;
    update();
  }

  void initData() {
    getCountryData();
  }

  void checkAndGotoNextStep(GlobalUser? user) async {
    bool needEmailVerification = user?.ev == "1" ? false : true;
    bool needSmsVerification = user?.sv == '1' ? false : true;
    bool isTwoFactorEnable = user?.tv == '1' ? false : true;

    await profileRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userIdKey, user?.id.toString() ?? '-1');
    await profileRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userEmailKey, user?.email ?? '');
    await profileRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userPhoneNumberKey, user?.mobile ?? '');
    await profileRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userNameKey, user?.username ?? '');

    if (needEmailVerification) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen);
    } else if (needSmsVerification) {
      Get.offAndToNamed(RouteHelper.smsVerificationScreen);
    } else if (isTwoFactorEnable) {
      Get.offAndToNamed(RouteHelper.twoFactorScreen);
    } else {
      String pin = profileRepo.apiClient.sharedPreferences.getString(SharedPreferenceHelper.screenLockPin) ?? '';
      if (pin.isEmpty || pin == 'null') {
        Get.offAndToNamed(RouteHelper.createPinScreen);
      } else {
        await profileRepo.sendUserToken();
        Get.offAndToNamed(RouteHelper.homeScreen);
      }
    }
  }
}
