import 'dart:convert';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/data/model/faq/faq_response_model.dart';
import 'package:local_coin/data/model/global/response_model/response_model.dart';
import 'package:local_coin/data/repo/faq_repo/faq_repo.dart';
import 'package:local_coin/view/components/show_custom_snackbar.dart';

class FaqController extends GetxController {
  FaqRepo faqRepo;
  FaqController({required this.faqRepo});

  bool isLoading = true;
  bool isPress = false;
  int selectedIndex = 0;

  List<Faqs> faqList = [];

  void changeSelectedIndex(int index) {
    if (selectedIndex == index) {
      selectedIndex = -1;
      update();
      return;
    }
    selectedIndex = index;
    update();
  }

  void loadData() async {
    selectedIndex = 0;
    ResponseModel model = await faqRepo.loadFaq();
    if (model.statusCode == 200) {
      FaqResponseModel responseModel = FaqResponseModel.fromJson(jsonDecode(model.responseJson));
      if (responseModel.status == "success") {
        List<Faqs>? tempFaqList = responseModel.data?.faqs;
        if (tempFaqList != null && tempFaqList.isNotEmpty) {
          faqList.addAll(tempFaqList);
        }
      } else {
        CustomSnackbar.showCustomSnackbar(errorList: responseModel.message?.error ?? [MyStrings.somethingWentWrong], msg: [], isError: true);
      }
    } else {
      CustomSnackbar.showCustomSnackbar(errorList: [model.message], msg: [], isError: true);
    }
    isLoading = false;
    update();
  }
}
