import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/my_color.dart';
import 'package:local_coin/core/utils/my_icons.dart';
import 'package:local_coin/core/utils/styles.dart';
import 'package:local_coin/data/controller/support_ticket/new_ticket_controller.dart';
import 'package:local_coin/data/repo/support_ticket/support_repo.dart';
import 'package:local_coin/data/services/api_service.dart';
import 'package:local_coin/view/components/app_bar/custom_appbar.dart';
import 'package:local_coin/view/components/circle_icon_button.dart';
import 'package:local_coin/view/components/custom_text_field.dart';
import 'package:local_coin/view/components/image/custom_svg_picture.dart';
import 'package:local_coin/view/components/label_text.dart';
import 'package:local_coin/view/components/rounded_button.dart';
import 'package:local_coin/view/components/rounded_loading_button.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class NewTicketScreen extends StatefulWidget {
  const NewTicketScreen({super.key});

  @override
  State<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends State<NewTicketScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SupportTicketRepo(apiClient: Get.find()));
    Get.put(NewTicketController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewTicketController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.bgColor,
        appBar: CustomAppBar(
          title: MyStrings.addNewTicket.tr,
        ),
        body: controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.textToTextSpace),
                      CustomTextField(
                        labelText: MyStrings.subject.tr,
                        hintText: MyStrings.enterYourSubject.tr,
                        controller: controller.subjectController,
                        isPassword: false,
                        isShowSuffixIcon: false,
                        nextFocus: controller.messageFocusNode,
                        onSuffixTap: () {},
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      LabelText(text: MyStrings.priority.tr),
                      const SizedBox(height: Dimensions.space5),
                      DropDownTextFieldContainer(
                        color: MyColor.transparentColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: DropdownButton<String>(
                            dropdownColor: MyColor.colorWhite,
                            value: controller.selectedPriority,
                            elevation: 8,
                            icon: const Icon(Icons.arrow_drop_down_circle),
                            iconDisabledColor: Colors.grey,
                            iconEnabledColor: MyColor.primaryColor,
                            isExpanded: true,
                            underline: Container(
                              height: 0,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              controller.setPriority(newValue);
                            },
                            items: controller.priorityList.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontDefault),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      CustomTextField(
                        labelText: MyStrings.message.tr,
                        hintText: MyStrings.enterYourMessage.tr,
                        isPassword: false,
                        controller: controller.messageController,
                        maxLines: 5,
                        focusNode: controller.messageFocusNode,
                        isShowSuffixIcon: false,
                        onSuffixTap: () {},
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 10),
                      LabelText(text: MyStrings.attachments.tr),
                      const SizedBox(height: 10),
                      controller.attachmentList.isNotEmpty
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  //add new photo
                                  ZoomTapAnimation(
                                    onTap: () {
                                      controller.pickFile();
                                    },
                                    child: Container(
                                      width: context.width / 4,
                                      height: context.width / 4,
                                      margin: const EdgeInsets.only(right: Dimensions.space15),
                                      decoration: BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.circular(Dimensions.mediumRadius)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomSvgPicture(image: MyIcons.fileIcon, color: MyColor.colorGrey.withOpacity(0.5)),
                                          Text(
                                            MyStrings.chooseFile.tr,
                                            style: robotoRegular.copyWith(color: MyColor.colorGrey.withOpacity(0.5), fontSize: Dimensions.fontSmall),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                                        ),
                                                      )
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
                                                            image: MyIcons.fileIcon,
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
                                    CustomSvgPicture(image: MyIcons.fileIcon, color: MyColor.colorGrey.withOpacity(0.5)),
                                    Text(
                                      MyStrings.chooseFile.tr,
                                      style: robotoRegular.copyWith(color: MyColor.colorGrey.withOpacity(0.5), fontSize: Dimensions.fontSmall),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      const SizedBox(height: 30),
                      Center(
                        child: controller.submitLoading
                            ? const RoundedLoadingBtn()
                            : RoundedButton(
                                text: MyStrings.submit.tr,
                                press: () {
                                  print("tap");
                                  controller.submit();
                                },
                              ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class DropDownTextFieldContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  const DropDownTextFieldContainer({Key? key, required this.child, this.color = MyColor.primaryColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
        border: Border.all(color: MyColor.textFieldDisableBorderColor, width: .5),
      ),
      child: child,
    );
  }
}
