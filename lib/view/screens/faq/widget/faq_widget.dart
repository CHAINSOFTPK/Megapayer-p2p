import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/my_color.dart';
import 'package:local_coin/core/utils/styles.dart';
import 'package:local_coin/view/components/animated_widget/expanded_widget.dart';

class FaqListItem extends StatelessWidget {
  final String question;
  final String answer;
  final int index;
  final int selectedIndex;
  final VoidCallback press;

  const FaqListItem({Key? key, required this.answer, required this.question, required this.index, required this.press, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space15),
        decoration: BoxDecoration(
          color: MyColor.colorWhite.withOpacity(0.5),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(question.tr, style: robotoRegular.copyWith(color: MyColor.colorBlack, fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 30, width: 30, child: Icon(index == selectedIndex ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: MyColor.getPrimaryColor(), size: 20))
              ],
            ),
            ExpandedSection(
              expand: index == selectedIndex,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimensions.space10),
                  HtmlWidget(
                    answer.tr,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
