import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/core/utils/my_color.dart';
import 'package:local_coin/core/utils/util.dart';
import 'package:local_coin/data/controller/trade/running_trade_details_controller/running_trade_details_controller.dart';
import 'package:local_coin/data/model/trade/TradeDetailsResponseModel.dart';
import 'package:local_coin/view/components/buttons/circle_button_with_icon.dart';
import 'package:local_coin/view/components/image/my_image_widget.dart';

import '../../../../../../../core/utils/styles.dart';
import '../../../../../../../core/utils/url_container.dart';

class ChatItemWidget extends StatefulWidget {
  final int index;
  final String myUserId;
  final Chats? chats;
  final String? myImageUrl;
  final String? otherImageUrl;

  const ChatItemWidget({Key? key, required this.index, required this.myUserId, required this.chats, this.myImageUrl, this.otherImageUrl}) : super(key: key);

  @override
  State<ChatItemWidget> createState() => _ChatItemWidgetState();
}

class _ChatItemWidgetState extends State<ChatItemWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RunningTradeDetailsController>();
    if (widget.chats?.userId?.toString() == widget.myUserId) {
      return Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: 200.0,
              decoration: const BoxDecoration(color: MyColor.primaryColor200, borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8), bottomLeft: Radius.circular(8))),
              margin: const EdgeInsets.only(right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chats?.message?.toString() ?? '',
                    style: mulishRegular.copyWith(color: MyColor.colorWhite),
                  ),
                  widget.chats?.file != null && widget.chats!.file.toString().isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            InkWell(
                              onTap: () {
                                controller.downloadFile(widget.chats?.file);
                              },
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: 0.6,
                                    child: MyUtils.isFileTypeImage(widget.chats?.file.toString() ?? '')
                                        ? MyImageWidget(
                                            imageUrl: "${UrlContainer.baseUrl}${controller.chatFilePath}/${widget.chats?.file}",
                                            width: 200,
                                            height: 200,
                                            boxFit: BoxFit.fitWidth,
                                          )
                                        : const SizedBox(
                                            width: 200,
                                            height: 200,
                                            child: Center(
                                              child: Icon(
                                                Icons.description,
                                                size: 100,
                                                color: MyColor.colorGrey,
                                              ),
                                            ),
                                          ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: MyColor.secondaryColor,
                                        ),
                                        child: controller.isDownloading
                                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: MyColor.colorWhite))
                                            : const Icon(
                                                Icons.download_rounded,
                                                color: MyColor.colorWhite,
                                                size: 20,
                                              ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            )
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 12, top: 5.0, bottom: 5.0),
            child: Text(
              controller.getTime(widget.chats?.createdAt ?? ''),
              style: mulishRegular.copyWith(fontSize: 12),
            ),
          )
        ])
      ]);
    } else {
      // This is a received message
      return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                widget.otherImageUrl == 'admin'
                    ? CircleButtonWithIcon(
                        isAsset: false,
                        imagePath: '${UrlContainer.baseUrl}${controller.adminImagePath}',
                        circleSize: 40,
                        padding: 5,
                        imageSize: 35,
                        press: () {},
                        isIcon: false,
                      )
                    : CircleButtonWithIcon(
                        isAsset: false,
                        isIcon: false,
                        imagePath: '${UrlContainer.baseUrl}${controller.userImagePath}/${widget.otherImageUrl}',
                        imageSize: 35,
                        padding: 5,
                        circleSize: 40,
                        press: () {},
                      ),
                Container(
                  width: 200.0,
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  margin: const EdgeInsets.only(left: 10.0),
                  decoration: const BoxDecoration(color: MyColor.secondaryColor, borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chats?.message ?? '',
                        style: mulishRegular.copyWith(color: MyColor.colorWhite),
                      ),
                      widget.chats?.file != null && widget.chats!.file.toString().isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15),
                                InkWell(
                                  onTap: () {
                                    controller.downloadFile(widget.chats?.file);
                                  },
                                  child: Stack(
                                    children: [
                                      Opacity(
                                        opacity: 0.3,
                                        child: MyUtils.isFileTypeImage(widget.chats?.file.toString() ?? '')
                                            ? MyImageWidget(
                                                imageUrl: "${UrlContainer.baseUrl}${controller.chatFilePath}/${widget.chats?.file}",
                                                width: 200,
                                                height: 200,
                                                boxFit: BoxFit.fitWidth,
                                              )
                                            : SizedBox(
                                                width: 200,
                                                height: 200,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.description,
                                                    size: 100,
                                                    color: MyColor.colorGrey.withOpacity(0.3),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: MyColor.primaryColor,
                                            ),
                                            child: controller.isDownloading
                                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: MyColor.colorWhite))
                                                : const Icon(
                                                    Icons.download_rounded,
                                                    color: MyColor.colorWhite,
                                                    size: 20,
                                                  ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 45.0, top: 5.0, bottom: 5.0),
              child: Text(
                controller.getTime(widget.chats?.createdAt ?? ''),
                style: mulishRegular.copyWith(fontSize: 12),
              ),
            )
          ],
        ),
      );
    }
  }
}
