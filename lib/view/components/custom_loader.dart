import 'package:flutter/material.dart';
import 'package:local_coin/core/utils/my_color.dart';

class CustomLoader extends StatelessWidget {
  final bool isFullScreen;
  final bool isPagination;
  final double strokeWidth;

  const CustomLoader({Key? key, this.isFullScreen = false, this.isPagination = false, this.strokeWidth = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFullScreen
        ? SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: CircularProgressIndicator(
                color: MyColor.primaryColor,
              ),
            ),
          )
        : isPagination
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    color: MyColor.primaryColor,
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                color: MyColor.primaryColor,
              ));
  }
}
