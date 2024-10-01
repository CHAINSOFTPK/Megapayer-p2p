import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/utils/util.dart';
import 'package:local_coin/data/controller/support_ticket/support_ticket_methods_list.dart';
import 'package:local_coin/data/repo/support_ticket/support_repo.dart';
import 'package:local_coin/view/components/app_bar/custom_appbar.dart';
import 'package:local_coin/view/components/custom_loader.dart';
import 'package:local_coin/view/components/image/my_image_widget.dart';

import '../../../../core/route/route.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../data/services/api_service.dart';

class SupportTicketMethodsList extends StatefulWidget {
  const SupportTicketMethodsList({super.key});

  @override
  State<SupportTicketMethodsList> createState() => _SupportTicketMethodsListState();
}

class _SupportTicketMethodsListState extends State<SupportTicketMethodsList> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SupportTicketRepo(apiClient: Get.find()));
    var controller = Get.put(SupportTicketMethodsController(
      repo: Get.find(),
    ));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getSupportMethodsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportTicketMethodsController>(builder: (controller) {
      return Scaffold(
        backgroundColor: MyColor.bgColor,
        appBar: const CustomAppBar(title: MyStrings.contactUs, bgColor: MyColor.primaryColor),
        body: RefreshIndicator(
          color: MyColor.primaryColor,
          onRefresh: () async {
            controller.getSupportMethodsList();
          },
          child: controller.isLoading
              ? const CustomLoader()
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: Dimensions.padding,
                  itemCount: controller.supportMethodsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = controller.supportMethodsList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimensions.space10),
                        GestureDetector(
                          onTap: () {
                            if (item.isDefault == '1') {
                              Get.toNamed(RouteHelper.allTicketScreen);
                            } else {
                              MyUtils.launchUrlToBrowser(item.url ?? "");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: IntrinsicHeight(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: MyImageWidget(
                                  radius: 0,
                                  imageUrl: "${controller.methodFilePath}/${item.image ?? ''}",
                                  width: double.infinity,
                                  height: 150,
                                  boxFit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }),
        ),
      );
    });
  }
}
