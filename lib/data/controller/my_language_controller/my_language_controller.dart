import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/core/helper/shared_pref_helper.dart';
import 'package:local_coin/core/utils/messages.dart';
import 'package:local_coin/core/utils/url_container.dart';
import 'package:local_coin/data/controller/localization/localization_controller.dart';
import 'package:local_coin/data/model/global/response_model/response_model.dart';
import 'package:local_coin/data/model/language/language_model.dart';
import 'package:local_coin/data/model/language/main_language_response_model.dart';
import 'package:local_coin/data/repo/auth/general_setting_repo.dart';
import 'package:local_coin/view/components/show_custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLanguageController extends GetxController {
  GeneralSettingRepo repo;
  LocalizationController localizationController;
  MyLanguageController({required this.repo, required this.localizationController});

  bool isLoading = true;
  String languageImagePath = "";
  List<MyLanguageModel> langList = [];
  final List<String> supportedLanguages = ['en', 'ar', 'uz', 'ru', 'tr']; // Added 'tr' for Turkish

  @override
  void onInit() {
    super.onInit();
    fetchLanguagesFromServer();
  }

  Future<void> fetchLanguagesFromServer() async {
    print("Fetching language settings from server");
    try {
      ResponseModel response = await repo.getLanguage('en');
      print("Server response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Successfully received language data");
        await repo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.languageListKey, response.responseJson);
        print("Saved language data to SharedPreferences");
        loadLanguage();
      } else {
        print("Error response from server: ${response.message}");
        CustomSnackbar.showCustomSnackbar(errorList: [response.message], msg: [], isError: true);
        loadDefaultLanguages();
      }
    } catch (e) {
      print("Error fetching language settings: $e");
      CustomSnackbar.showCustomSnackbar(errorList: ["Failed to fetch language settings"], msg: [], isError: true);
      loadDefaultLanguages();
    }
  }

  void loadLanguage() {
    print("loadLanguage() started");
    langList.clear();
    isLoading = true;

    try {
      SharedPreferences pref = repo.apiClient.sharedPreferences;
      String languageString = pref.getString(SharedPreferenceHelper.languageListKey) ?? '';
      print("Retrieved language string from SharedPreferences: $languageString");

      if (languageString.isEmpty) {
        print("Language string is empty. Loading default languages.");
        loadDefaultLanguages();
      } else {
        try {
          var language = jsonDecode(languageString);
          print("Decoded language JSON: $language");

          if (language != null && language is Map<String, dynamic>) {
            MainLanguageResponseModel model = MainLanguageResponseModel.fromJson(language);
            print("MainLanguageResponseModel created: ${model.toString()}");

            languageImagePath = "${UrlContainer.baseUrl}/${model.data?.imagePath ?? ''}";
            print("Language image path: $languageImagePath");

            if (model.data?.languages != null && model.data!.languages!.isNotEmpty) {
              for (var listItem in model.data!.languages!) {
                if (supportedLanguages.contains(listItem.code)) {
                  MyLanguageModel langModel = MyLanguageModel(
                    languageCode: listItem.code ?? '',
                    countryCode: listItem.name ?? '',
                    languageName: listItem.name ?? '',
                    imageUrl: '' // We're not using image URLs anymore
                  );
                  langList.add(langModel);
                  print("Added language: ${langModel.languageName}");
                }
              }
            } else {
              print("No languages found in the model");
              loadDefaultLanguages();
            }

            String languageCode = pref.getString(SharedPreferenceHelper.languageCode) ?? 'en';
            print("Current language code: $languageCode");

            if (langList.isNotEmpty) {
              int index = langList.indexWhere((element) => element.languageCode.toLowerCase() == languageCode.toLowerCase());
              print("Selected language index: $index");
              changeSelectedIndex(index >= 0 ? index : 0);
            } else {
              print("Language list is empty");
              loadDefaultLanguages();
            }
          } else {
            print("Decoded language is null or not a Map");
            loadDefaultLanguages();
          }
        } catch (e) {
          print("Error decoding JSON: $e");
          loadDefaultLanguages();
        }
      }
    } catch (e) {
      print("Error in loadLanguage: $e");
      loadDefaultLanguages();
    }

    isLoading = false;
    update();
    print("loadLanguage() completed");
  }

  void loadDefaultLanguages() {
    print("Loading default languages");
    langList.clear();
    for (String langCode in supportedLanguages) {
      MyLanguageModel lang = MyLanguageModel(
        languageCode: langCode,
        countryCode: langCode.toUpperCase(),
        languageName: getLanguageName(langCode),
        imageUrl: '' // We're not using image URLs anymore
      );
      langList.add(lang);
    }
    selectedIndex = 0; // Default to first language (presumably English)
    languageImagePath = ""; // We're not using image paths anymore
    print("Default languages loaded");
  }

  String getLanguageName(String langCode) {
    switch (langCode) {
      case 'en': return 'English';
      case 'ar': return 'العربية';
      case 'uz': return 'O\'zbek';
      case 'ru': return 'Русский';
      case 'tr': return 'Türkçe'; // Added Turkish language name
      default: return 'Unknown';
    }
  }

  String selectedLangCode = 'en';

  bool isChangeLangLoading = false;
  void changeLanguage(int index) async {
    print("changeLanguage() started for index: $index");
    isChangeLangLoading = true;
    update();

    MyLanguageModel selectedLangModel = langList[index];
    String languageCode = selectedLangModel.languageCode;
    print("Selected language code: $languageCode");

    try {
      print("Fetching language data from server");
      ResponseModel response = await repo.getLanguage(languageCode);
      print("Server response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Successfully received language data");
        var resJson = jsonDecode(response.responseJson);
        print("Decoded response JSON: $resJson");

        await repo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.languageListKey, response.responseJson);
        print("Saved language data to SharedPreferences");

        Locale local = Locale(selectedLangModel.languageCode, selectedLangModel.countryCode);
        localizationController.setLanguage(local, "");
        print("Set new locale: $local");

        var value = resJson['data']['file'].toString() == '[]' ? {} : resJson['data']['file'];
        Map<String, String> json = {};
        value.forEach((key, value) {
          json[key] = value.toString();
        });
        print("Processed language file data");

        Map<String, Map<String, String>> language = {};
        language['${selectedLangModel.languageCode}_${selectedLangModel.countryCode}'] = json;

        Get.clearTranslations();
        Get.addTranslations(Messages(languages: language).keys);
        print("Updated translations");

        Get.back();
      } else {
        print("Error response from server: ${response.message}");
        CustomSnackbar.showCustomSnackbar(errorList: [response.message], msg: [], isError: true);
      }
    } catch (e) {
      print("Error in changeLanguage: $e");
      CustomSnackbar.showCustomSnackbar(errorList: ["Failed to change language"], msg: [], isError: true);
    }

    isChangeLangLoading = false;
    update();
    print("changeLanguage() completed");
  }

  int selectedIndex = 0;
  void changeSelectedIndex(int index) {
    selectedIndex = index;
    print("Changed selected index to: $index");
    update();
  }
}