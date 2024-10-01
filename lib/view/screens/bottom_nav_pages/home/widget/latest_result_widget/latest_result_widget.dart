import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/my_color.dart';
import 'package:local_coin/core/utils/my_images.dart';
import 'package:local_coin/core/utils/styles.dart';
import 'package:local_coin/data/controller/home/home_controller.dart';
import 'package:local_coin/view/components/card_bg.dart';
import 'package:local_coin/view/screens/bottom_nav_pages/home/widget/latest_result_widget/latest_result_shimmer.dart';
import 'package:local_coin/view/screens/bottom_nav_pages/marketplace_screen/market_place_screen.dart';
import 'package:local_coin/view/screens/bottom_nav_pages/trade/trade_screen/trade_screen.dart';

import 'latest_result_list_item.dart';

class LatestResultWidget extends StatelessWidget {
  const LatestResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => controller.isLoading
          ? const LatestResultShimmer()
          : RadiusCardShape(
              cardRadius: 4,
              widget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MyStrings.tradeSummary.tr,
                    style: mulishSemiBold.copyWith(
                      color: MyColor.colorBlack,
                      fontSize: Dimensions.fontLarge,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
  children: [
    Expanded(
      child: GestureDetector(
        onTap: () {
          // Navigate to the TradeScreen page
          Get.to(() => const TradeScreen());
        },
        child: LatestResultListItem(
          title: MyStrings.running.tr,
          subtitle: 'Summary of Running Trades',
          price: controller.runningTrade ?? '0',
          percentageChange: 'Total',
          image: MyImages.running,
        ),
      ),
    ),
  ],
),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                        onTap: () {
          // Navigate to the TradeScreen page
                       Get.to(() => const TradeScreen());
                     },
                        child: LatestResultListItem(
                          title: MyStrings.completed.tr,
                          subtitle: 'Summary of Completed Trades',
                          price: controller.completedTrade ?? '0',
                          percentageChange: 'Total',
                          image: MyImages.completed,
                        ),
                      ),
                    ),
                   ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    MyStrings.addSummary.tr,
                    style: mulishSemiBold.copyWith(
                      fontSize: Dimensions.fontLarge,
                      color: MyColor.colorBlack,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                     children: [
                      Expanded(
                        child: GestureDetector(
                        onTap: () {
          // Navigate to the TradeScreen page
                       Get.to(() => MarketPlaceScreen());
                     },
                        child: LatestResultListItem(
                          title: MyStrings.buyAds.tr,
                          subtitle: 'Summary of Bought Ads',
                          price: controller.buyAdd ?? '0',
                          percentageChange: 'Total',
                          image: MyImages.buy,
                        ),
                      ),
                    ),
                  ],
                ),
                  const SizedBox(height: 20),
                  Row(
                     children: [
                      Expanded(
                        child: GestureDetector(
                        onTap: () {
          // Navigate to the TradeScreen page
                       Get.to(() =>  MarketPlaceScreen());
                     },
                        child: LatestResultListItem(
                          title: MyStrings.sellAds.tr,
                          subtitle: 'Summary of sold Ads',
                          price: controller.sellAdd ?? '0',
                          percentageChange: 'Total',
                          image: MyImages.sell,
                        ),
                      ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
