import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/helper/date_converter.dart';
import 'package:local_coin/core/route/route.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/my_color.dart';
import 'package:local_coin/core/utils/styles.dart';
import 'package:local_coin/data/controller/support_ticket/support_controller.dart';
import 'package:local_coin/data/repo/support_ticket/support_repo.dart';
import 'package:local_coin/data/services/api_service.dart';
import 'package:local_coin/view/components/app_bar/custom_appbar.dart';
import 'package:local_coin/view/components/column/card_column.dart';
import 'package:local_coin/view/components/custom_loader.dart';
import 'package:local_coin/view/components/no_data/no_data_widget.dart';

class AllTicketScreen extends StatefulWidget {
  const AllTicketScreen({super.key});

  @override
  State<AllTicketScreen> createState() => _AllTicketScreenState();
}

class _AllTicketScreenState extends State<AllTicketScreen> {
  ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<SupportController>().hasNext()) {
        Get.find<SupportController>().getSupportTicket();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SupportTicketRepo(apiClient: Get.find()));
    final controller = Get.put(SupportController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
      scrollController.addListener(scrollListener);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportController>(builder: (controller) {
      return Scaffold(
        backgroundColor: MyColor.bgColor,
        appBar: const CustomAppBar(title: MyStrings.supportTicket),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.loadData();
          },
          color: MyColor.primaryColor,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: Dimensions.padding,
                  child: controller.isLoading
                      ? const CustomLoader(
                          isFullScreen: true,
                        )
                      : controller.ticketList.isEmpty
                          ? SizedBox(
                              height: context.height,
                              child: const Center(
                                child: NoDataWidget(
                                  topMargin: 0,
                                  bottomMargin: 0,
                                  title: MyStrings.noTicketFound,
                                ),
                              ),
                            )
                          : ListView.separated(
                              controller: scrollController,
                              itemCount: controller.ticketList.length + 1,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
                              itemBuilder: (context, index) {
                                if (controller.ticketList.length == index) {
                                  return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                                }
                                return GestureDetector(
                                  onTap: () {
                                    String id = controller.ticketList[index].ticket ?? '-1';
                                    String subject = controller.ticketList[index].subject ?? '';

                                    Get.toNamed(RouteHelper.ticketDetailsdScreen, arguments: [id, subject]);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space25),
                                    decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.mediumRadius), border: Border.all(color: Theme.of(context).textTheme.titleLarge!.color!.withOpacity(0.3), width: 1)),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.only(end: Dimensions.space10),
                                            child: CardColumn(
                                              header: "[${MyStrings.ticket.tr}#${controller.ticketList[index].ticket}] ${controller.ticketList[index].subject}",
                                              body: "${controller.ticketList[index].subject}",
                                              space: 5,
                                              headerTextDecoration: robotoRegular.copyWith(
                                                color: Theme.of(context).textTheme.titleLarge?.color,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              bodyTextDecoration: robotoRegular.copyWith(
                                                color: Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                const SizedBox(height: Dimensions.space20),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space5),
                                                  decoration: BoxDecoration(
                                                    color: controller.getStatusColor(controller.ticketList[index].status ?? "0").withOpacity(0.2),
                                                    border: Border.all(color: controller.getStatusColor(controller.ticketList[index].status ?? "0"), width: 1),
                                                    borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                                                  ),
                                                  child: Text(
                                                    controller.getStatusText(controller.ticketList[index].status ?? '0'),
                                                    style: robotoRegular.copyWith(
                                                      color: controller.getStatusColor(controller.ticketList[index].status ?? "0"),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: Dimensions.space10),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space5),
                                                  decoration: BoxDecoration(
                                                    color: controller.getStatusColor(controller.ticketList[index].priority ?? "0", isPriority: true).withOpacity(0.2),
                                                    border: Border.all(color: controller.getStatusColor(controller.ticketList[index].priority ?? "0", isPriority: true), width: 1),
                                                    borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                                                  ),
                                                  child: Text(
                                                    controller.getStatus(controller.ticketList[index].priority ?? '1', isPriority: true),
                                                    style: robotoRegular.copyWith(
                                                      color: controller.getStatusColor(controller.ticketList[index].priority ?? "0", isPriority: true),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: Dimensions.space20),
                                            Text(
                                              DateConverter.getFormatedSubtractTime(controller.ticketList[index].createdAt ?? ''),
                                              style: robotoRegular.copyWith(fontSize: 10, color: Theme.of(context).textTheme.titleLarge!.color?.withOpacity(0.7)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: FloatingActionButton(
            onPressed: () {
              Get.toNamed(RouteHelper.newTicketScreen)?.then((value) => {Get.find<SupportController>().getSupportTicket()});
            },
            backgroundColor: MyColor.primaryColor,
            child: const Icon(
              Icons.add,
              color: MyColor.colorWhite,
            ),
          ),
        ),
      );
    });
  }
}
