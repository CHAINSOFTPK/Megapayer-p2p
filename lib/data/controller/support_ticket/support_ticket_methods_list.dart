import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/data/repo/support_ticket/support_repo.dart';
import 'package:local_coin/view/components/show_custom_snackbar.dart';

import '../../model/global/response_model/response_model.dart';
import '../../model/support/community_group_model.dart';
import '../../model/support/support_methods_model.dart';

class SupportTicketMethodsController extends GetxController {
  SupportTicketRepo repo;
  SupportTicketMethodsController({required this.repo});

  bool isLoading = false;
  String methodFilePath = "";
  List<SupportMethod> supportMethodsList = [];

  Future<void> getSupportMethodsList() async {
    isLoading = true;
    update();
    try {
      ResponseModel responseModel = await repo.getSupportMethodsList();
      if (responseModel.statusCode == 200) {
        supportMethodsList.clear();
        SupportMethods model = supportMethodsFromJson(responseModel.responseJson);
        if (model.status == MyStrings.success) {
          methodFilePath = model.data!.methodFilePath ?? '';
          List<SupportMethod>? tempList = model.data?.methods;

          if (tempList != null && tempList.isNotEmpty) {
            supportMethodsList.addAll(tempList);
          }
        } else {
          CustomSnackbar.showCustomSnackbar(errorList: [MyStrings.somethingWentWrong], msg: [], isError: true);
        }
      } else {
        CustomSnackbar.showCustomSnackbar(errorList: [responseModel.message], msg: [], isError: true);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  String communityGroupImagePath = "";
  List<CommunityGroupElement> getCommunityGroupList = [];

  Future<void> getCommunityMethodGroupList() async {
    isLoading = true;
    update();
    try {
      ResponseModel responseModel = await repo.getCommunityGroupListList();
      if (responseModel.statusCode == 200) {
        getCommunityGroupList.clear();
        CommunityGroup model = communityGroupFromJson(responseModel.responseJson);
        if (model.status == MyStrings.success) {
          communityGroupImagePath = model.data!.communityGroupImagePath ?? '';
          List<CommunityGroupElement>? tempList = model.data?.communityGroups;

          if (tempList != null && tempList.isNotEmpty) {
            getCommunityGroupList.addAll(tempList);
          }
        } else {
          CustomSnackbar.showCustomSnackbar(errorList: [MyStrings.somethingWentWrong], msg: [], isError: true);
        }
      } else {
        CustomSnackbar.showCustomSnackbar(errorList: [responseModel.message], msg: [], isError: true);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }
}
