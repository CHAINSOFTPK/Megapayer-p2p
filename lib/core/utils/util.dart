import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class MyUtils {
  static dynamic getShadow() {
    return [
      BoxShadow(blurRadius: 15.0, offset: const Offset(0, 25), color: Colors.grey.shade500.withOpacity(0.6), spreadRadius: -35.0),
    ];
  }

  static dynamic getBottomSheetShadow() {
    return [
      BoxShadow(
        // color: MyColor.screenBgColor,
        color: Colors.grey.shade400.withOpacity(0.08),
        spreadRadius: 3,
        blurRadius: 4,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ];
  }

  static dynamic getCardShadow() {
    return [
      BoxShadow(
        color: Colors.grey.shade400.withOpacity(0.05),
        spreadRadius: 2,
        blurRadius: 2,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static void stopLandscape() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static Future<void> launchUrlToBrowser(String downloadUrl) async {
    try {
      final Uri url = Uri.parse(downloadUrl);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static String get _getDeviceType {
    final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
    return data.size.width < 550 ? 'phone' : 'tablet';
  }

  static bool get isTablet {
    return _getDeviceType == 'tablet';
  }

  static bool isFileTypeImage(String img) {
    try {
      String type = img.split('.').last.toLowerCase();
      if (type == "png") {
        return true;
      } else if (type == "jpg") {
        return true;
      } else if (type == "jpeg") {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static TextInputType getInputTextFieldType(String type) {
    if (type == "email") {
      return TextInputType.emailAddress;
    } else if (type == "number") {
      return TextInputType.number;
    } else if (type == "url") {
      return TextInputType.url;
    }
    return TextInputType.text;
  }

  static bool getInputType(String type) {
    if (type == "text") {
      return true;
    } else if (type == "email") {
      return true;
    } else if (type == "number") {
      return true;
    } else if (type == "url") {
      return true;
    }
    return false;
  }
}
