import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/my_color.dart';

ThemeData light = ThemeData(
    fontFamily: 'Mulish',
    primaryColor: MyColor.primaryColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: MyColor.colorWhite,
    hintColor: MyColor.colorBlack,
    focusColor: MyColor.gbr,
    unselectedWidgetColor: MyColor.colorBlack,
    dialogBackgroundColor:  MyColor.colorWhite,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      color:MyColor.colorWhite,
      foregroundColor: Colors.red,
      systemOverlayStyle: SystemUiOverlayStyle( //<-- SEE HERE
        statusBarColor: MyColor.primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(MyColor.colorWhite),
      fillColor: WidgetStateProperty.all(MyColor.primaryColor),
    ));
