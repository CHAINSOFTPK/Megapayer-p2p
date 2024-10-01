import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/my_color.dart';
import 'package:local_coin/data/controller/localization/localization_controller.dart';
import 'package:local_coin/data/controller/my_language_controller/my_language_controller.dart';
import 'package:local_coin/data/repo/auth/general_setting_repo.dart';
import 'package:local_coin/data/services/api_service.dart';
import 'package:local_coin/view/components/app_bar/custom_appbar.dart';
import 'package:local_coin/view/components/custom_loader.dart';
import 'package:local_coin/view/components/no_data/no_data_widget.dart';
import 'package:local_coin/view/components/rounded_button.dart';
import 'package:local_coin/view/components/rounded_loading_button.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String comeFrom = '';

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(LocalizationController(sharedPreferences: Get.find()));
    final controller = Get.put(MyLanguageController(repo: Get.find(), localizationController: Get.find()));

    comeFrom = Get.arguments ?? '';

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyLanguageController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.bgColor1,
        appBar: CustomAppBar(
          isShowBackBtn: true,
          title: MyStrings.language.tr,
        ),
        body: controller.isLoading
            ? const CustomLoader(isFullScreen: true)
            : controller.langList.isEmpty
                ? const NoDataWidget()
                : ListView.separated(
                    padding: const EdgeInsets.all(Dimensions.space15),
                    itemCount: controller.langList.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final language = controller.langList[index];
                      return ListTile(
                        title: Text(
                          language.languageName,
                          style: TextStyle(
                            color: controller.selectedIndex == index ? MyColor.primaryColor : Colors.black,
                            fontWeight: controller.selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: controller.selectedIndex == index
                            ? Icon(Icons.check, color: MyColor.primaryColor)
                            : null,
                        onTap: () {
                          controller.changeSelectedIndex(index);
                        },
                      );
                    },
                  ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(Dimensions.space15),
          child: controller.isChangeLangLoading
              ? const RoundedLoadingBtn()
              : RoundedButton(
                  text: MyStrings.confirm.tr,
                  press: () {
                    if (!controller.isChangeLangLoading) {
                      controller.changeLanguage(controller.selectedIndex);
                    }
                  },
                ),
        ),
      ),
    );
  }
}