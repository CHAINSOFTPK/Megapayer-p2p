// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/my_color.dart';
import 'package:local_coin/view/components/header_text.dart';

import '../../../../../../core/utils/styles.dart';

class HeadingTextWidget extends StatelessWidget {
  const HeadingTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .025,
        ),
        Center(
          child: Text(
              MyStrings.createAnAccount,
              textAlign: TextAlign.center,
              style:mulishBold.copyWith(color: MyColor.primaryColor,fontWeight: FontWeight.bold,
              fontFamily: 'Poppins', 
              fontSize: Dimensions.fontOverLarge + 10,shadows: [
                  const Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 2.0,
                    color: MyColor.applightColor,
                  ),
                ],),
            ),
          ),
       
        const SizedBox(height: 5),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .1),
            child: Text(
              MyStrings.enterValidInfoToCreateAccount.tr,
              textAlign: TextAlign.center,
              style: mulishRegular.copyWith(color: MyColor.customColor, fontSize: 10),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .03,
        ),
      ],
    );
  }
}
