import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/my_color.dart';
import 'package:local_coin/core/utils/styles.dart';

class LabelTextInstruction extends StatelessWidget {
  final bool isRequired;
  final String text;
  final String? instructions;
  final TextAlign? textAlign;
  final TextStyle? textStyle;

  const LabelTextInstruction({
    super.key,
    required this.text,
    this.textAlign,
    this.textStyle,
    this.isRequired = false,
    this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

    return isRequired
        ? Row(
            children: [
              Text(
                text.tr,
                textAlign: textAlign,
                style: mulishSemiBold.copyWith(fontSize: Dimensions.fontDefault, color: MyColor.textColor),
              ),
              const SizedBox(
                width: 2,
              ),
              if (instructions != null) ...[
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 2, end: Dimensions.space15 - 5),
                  child: Tooltip(
                      key: tooltipKey,
                      message: "$instructions",
                      child: GestureDetector(
                        onTap: () {
                          tooltipKey.currentState?.ensureTooltipVisible();
                        },
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: Dimensions.space15,
                          color: Theme.of(context).textTheme.titleLarge!.color?.withOpacity(0.8),
                        ),
                      )),
                ),
              ],
              Text(
                '*',
                style: robotoBold.copyWith(color: MyColor.closeRedColor),
              ),
            ],
          )
        : Row(
            children: [
              Text(
                text.tr,
                textAlign: textAlign,
                style: textStyle ?? robotoRegular.copyWith(color: Theme.of(context).textTheme.titleLarge!.color),
              ),
              if (instructions != null) ...[
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 2, end: 10),
                  child: Tooltip(
                      key: tooltipKey,
                      message: "$instructions",
                      child: GestureDetector(
                        onTap: () {
                          tooltipKey.currentState?.ensureTooltipVisible();
                        },
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: Dimensions.space15,
                          color: MyColor.textColor.withOpacity(0.8),
                        ),
                      )),
                ),
              ],
            ],
          );
  }
}
