import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/helper/date_converter.dart';
import 'package:local_coin/core/route/route.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/my_color.dart';
import 'package:local_coin/core/utils/my_icons.dart';
import 'package:local_coin/core/utils/my_images.dart';
import 'package:local_coin/core/utils/styles.dart';
import 'package:local_coin/core/utils/url_container.dart';
import 'package:local_coin/data/controller/support_ticket/ticket_details_controller.dart';
import 'package:local_coin/data/model/support/support_ticket_view_response_model.dart';
import 'package:local_coin/data/repo/support_ticket/support_repo.dart';
import 'package:local_coin/data/services/api_service.dart';
import 'package:local_coin/view/components/app_bar/custom_appbar.dart';
import 'package:local_coin/view/components/buttons/custom_circle_animated_button.dart';
import 'package:local_coin/view/components/circle_icon_button.dart';
import 'package:local_coin/view/components/custom_loader.dart';
import 'package:local_coin/view/components/custom_text_field.dart';
import 'package:local_coin/view/components/image/custom_svg_picture.dart';
import 'package:local_coin/view/components/image/my_image_widget.dart';
import 'package:local_coin/view/components/label_text.dart';
import 'package:local_coin/view/components/rounded_button.dart';
import 'package:local_coin/view/components/rounded_loading_button.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({super.key});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  String title = "";
  @override
  void initState() {
    String ticketId = Get.arguments[0];
    title = Get.arguments[1];
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SupportTicketRepo(apiClient: Get.find()));
    var controller = Get.put(TicketDetailsController(repo: Get.find(), ticketId: ticketId));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: MyStrings.replyTicket,
      ),
      body: GetBuilder<TicketDetailsController>(builder: (controller) {
        return controller.isLoading
            ? const CustomLoader(
                isFullScreen: true,
              )
            : SingleChildScrollView(
                padding: Dimensions.padding,
                child: Container(
                  // padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                              color: Theme.of(context).textTheme.titleLarge!.color!.withOpacity(0.1),
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space5),
                                    decoration: BoxDecoration(
                                      color: controller.getStatusColor(controller.model.data?.myTickets?.status ?? "0").withOpacity(0.2),
                                      border: Border.all(color: controller.getStatusColor(controller.model.data?.myTickets?.status ?? "0"), width: 1),
                                      borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                                    ),
                                    child: Text(
                                      controller.getStatusText(controller.model.data?.myTickets?.status ?? '0'),
                                      style: robotoRegular.copyWith(
                                        color: controller.getStatusColor(controller.model.data?.myTickets?.status ?? "0"),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                    height: 2,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "[${MyStrings.ticket.tr}#${controller.model.data?.myTickets?.ticket ?? ''}] ${controller.model.data?.myTickets?.subject ?? ''}",
                                      style: robotoSemiBold.copyWith(
                                        color: Theme.of(context).textTheme.titleLarge!.color!,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                    height: 2,
                                  ),
                                ],
                              ),
                            ),
                            if (controller.model.data?.myTickets?.status != '3')
                              CustomCircleAnimatedButton(
                                onTap: () {
                                  // AppDialog().warningAlertDialog(context, msgText: MyStrings.ticketCloseDialogTitle.tr, () {
                                  controller.closeTicket(controller.model.data?.myTickets?.id.toString() ?? '-1');
                                  // });
                                },
                                height: 40,
                                width: 40,
                                backgroundColor: MyColor.transparentColor,
                                border: Border.all(color: MyColor.borderColor, width: 2),
                                child: const Icon(Icons.close_rounded, color: MyColor.colorGrey, size: 20),
                              )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.space15,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                              color: Theme.of(context).textTheme.titleLarge!.color!.withOpacity(0.1),
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: controller.replyController,
                              hintText: MyStrings.yourReply.tr,
                              maxLines: 4,
                              onChanged: (value) {},
                              labelText: '',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(height: 20),
                            LabelText(text: MyStrings.attachments.tr),
                            controller.attachmentList.isNotEmpty ? const SizedBox(height: 20) : const SizedBox.shrink(),
                            controller.attachmentList.isNotEmpty
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        //add new photo

                                        //aded photo
                                        Row(
                                          children: List.generate(
                                            controller.attachmentList.length,
                                            (index) => Row(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.all(Dimensions.space5),
                                                      decoration: const BoxDecoration(),
                                                      child: controller.isImage(controller.attachmentList[index].path)
                                                          ? ClipRRect(
                                                              borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                                              child: Image.file(
                                                                controller.attachmentList[index],
                                                                width: context.width / 4,
                                                                height: context.width / 4,
                                                                fit: BoxFit.cover,
                                                              ))
                                                          : Container(
                                                              width: context.width / 4,
                                                              height: context.width / 4,
                                                              decoration: BoxDecoration(
                                                                color: MyColor.colorWhite,
                                                                borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                                                border: Border.all(color: MyColor.borderColor, width: 1),
                                                              ),
                                                              child: const Center(
                                                                child: CustomSvgPicture(
                                                                  image: MyIcons.pdfFile,
                                                                  height: 30,
                                                                  width: 30,
                                                                ),
                                                              ),
                                                            ),
                                                    ),
                                                    CircleIconButton(
                                                      onTap: () {
                                                        controller.removeAttachmentFromList(index);
                                                      },
                                                      height: Dimensions.space25,
                                                      width: Dimensions.space25,
                                                      backgroundColor: MyColor.red,
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: MyColor.colorWhite,
                                                        size: Dimensions.space15,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ZoomTapAnimation(
                                    onTap: () {
                                      controller.pickFile();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20, vertical: Dimensions.space30),
                                      margin: const EdgeInsets.only(top: Dimensions.space5),
                                      width: context.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                        color: MyColor.borderColor.withOpacity(0.3),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.attachment_rounded,
                                            color: MyColor.colorGrey.withOpacity(0.5),
                                          ),
                                          Text(
                                            MyStrings.chooseFile.tr,
                                            style: robotoRegular.copyWith(color: MyColor.colorGrey.withOpacity(0.5)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: Dimensions.space30),
                            controller.submitLoading
                                ? const RoundedLoadingBtn()
                                : RoundedButton(
                                    text: MyStrings.reply.tr,
                                    press: () {
                                      controller.uploadTicketViewReply();
                                    },
                                  ),
                            const SizedBox(height: Dimensions.space30),
                            controller.messageList.isEmpty
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20, vertical: Dimensions.space20),
                                    decoration: BoxDecoration(
                                      color: MyColor.bodyTextColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          MyStrings.noMSgFound.tr,
                                          style: robotoRegular.copyWith(color: MyColor.colorGrey),
                                        ),
                                      ],
                                    ))
                                : Container(
                                    padding: const EdgeInsets.symmetric(vertical: 30),
                                    child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: controller.messageList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) => TicketViewCommentReplyModel(
                                        index: index,
                                        messages: controller.messageList[index],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
      }),
    );
  }
}

class TicketViewCommentReplyModel extends StatelessWidget {
  const TicketViewCommentReplyModel({Key? key, required this.index, required this.messages}) : super(key: key);

  final SupportMessage messages;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketDetailsController>(
        builder: (controller) => Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: messages.adminId == "1" ? MyColor.warningColor.withOpacity(0.1) : MyColor.colorWhite,
                borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                border: Border.all(
                  color: messages.adminId == "1" ? MyColor.warningColor : MyColor.borderColor,
                  strokeAlign: 1,
                ),
              ),
              // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: MyColor.colorGrey.withOpacity(0.1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: ClipOval(
                          child: Image.asset(
                            MyImages.profile,
                            height: 45,
                            width: 45,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (messages.admin == null)
                                Text(
                                  '${messages.ticket?.name}',
                                  style: robotoBold.copyWith(color: MyColor.colorBlack),
                                )
                              else
                                Text(
                                  '${messages.admin?.name}',
                                  style: robotoBold.copyWith(color: MyColor.colorBlack),
                                ),
                              Text(
                                messages.adminId == "1" ? MyStrings.admin.tr : MyStrings.you.tr,
                                style: robotoRegular.copyWith(color: MyColor.bodyTextColor),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateConverter.getFormatedSubtractTime(messages.createdAt ?? ''),
                            style: robotoRegular.copyWith(color: MyColor.bodyTextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                          ),
                          child: Text(
                            messages.message ?? "",
                            style: robotoRegular.copyWith(
                              color: MyColor.bodyTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (messages.attachments?.isNotEmpty ?? false)
                    Container(
                      height: MediaQuery.of(context).size.width > 500 ? 100 : 100,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: messages.attachments != null
                              ? List.generate(
                                  messages.attachments!.length,
                                  (i) => controller.selectedIndex == i
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30, vertical: Dimensions.space10),
                                          decoration: BoxDecoration(
                                            color: MyColor.bgColor,
                                            borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                          ),
                                          child: const SpinKitThreeBounce(
                                            size: 20.0,
                                            color: MyColor.primaryColor,
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            String url = '${UrlContainer.supportImagePath}${messages.attachments?[i].attachment}';
                                            String ext = messages.attachments?[i].attachment!.split('.')[1] ?? 'pdf';
                                            print(ext);
                                            print(controller.isImage(messages.attachments?[i].attachment.toString() ?? ""));
                                            print(url);
                                            if (controller.isImage(messages.attachments?[i].attachment.toString() ?? "")) {
                                              Get.toNamed(
                                                RouteHelper.previewImageScreen,
                                                arguments: "${UrlContainer.supportImagePath}${messages.attachments?[i].attachment}",
                                              );
                                            } else {
                                              controller.downloadAttachment(url, messages.attachments?[i].id ?? -1, ext);
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width > 500 ? 100 : 100,
                                            height: MediaQuery.of(context).size.width > 500 ? 100 : 100,
                                            margin: const EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: MyColor.borderColor),
                                              borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                            ),
                                            child: controller.isImage(messages.attachments?[i].attachment.toString() ?? "")
                                                ? MyImageWidget(
                                                    imageUrl: "${UrlContainer.supportImagePath}${messages.attachments?[i].attachment}",
                                                    width: MediaQuery.of(context).size.width > 500 ? 100 : 100,
                                                    height: MediaQuery.of(context).size.width > 500 ? 100 : 100,
                                                  )
                                                : Center(
                                                    child: Icon(
                                                    Icons.file_present_rounded,
                                                    size: MediaQuery.of(context).size.width > 500 ? 50 : 50,
                                                  )),
                                          ),
                                        ),
                                )
                              : const [SizedBox.shrink()],
                        ),
                      ),
                    ),
                ],
              ),
            ));
  }
}
//