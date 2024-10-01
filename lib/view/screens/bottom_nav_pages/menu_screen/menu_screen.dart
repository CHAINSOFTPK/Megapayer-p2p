import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/route/route.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/my_icons.dart';
import 'package:local_coin/core/utils/my_images.dart';
import 'package:local_coin/core/utils/styles.dart';
import 'package:local_coin/data/controller/menu/my_menu_controller.dart';
import 'package:local_coin/data/repo/menu_repo/menu_repo.dart';
import 'package:local_coin/data/services/api_service.dart';
import 'package:local_coin/view/components/bottom_sheet/custom_bottom_sheet.dart';
import 'package:local_coin/view/components/small_text.dart';
import 'package:local_coin/view/components/will_pop_widget.dart';
import 'package:local_coin/view/screens/bottom_nav_pages/menu_screen/widget/delete_account_bottom_sheet.dart';
import 'package:local_coin/view/screens/bottom_nav_pages/trade/trade_details_screen/widget/acition_widget/show_divider.dart';

import '../../../../core/utils/my_color.dart';
import '../../../components/card_bg.dart';
import '../../../components/custom_sized_box.dart';
import '../../../components/app_bar/custom_appbar.dart';
import '../../../components/bottom_Nav/bottom_nav.dart';
import '../../../components/row_item/menu_screen_row.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(MenuRepo(apiClient: Get.find()));
    Get.put(MyMenuController(repo: Get.find()));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
        nextRoute: RouteHelper.homeScreen,
        child: SafeArea(
          child: Scaffold(
            appBar: const CustomAppBar(
              title: MyStrings.userMenu,
              isShowBackBtn: false,
              isShowActionBtn: false,
              bgColor: MyColor.colorWhite,
            ),
            body: GetBuilder<MyMenuController>(
                builder: (controller) => Container(
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: MyColor.bgColor1),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomSizedBox(),
                            // First Box with Shadow
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: MyColor.bgColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset:
                                        const Offset(0, 3), // Shadow position
                                  ),
                                ],
                              ),
                              child: RadiusCardShape(
                                  cardRadius: 12,
                                  cardBgColor: MyColor.bgColor,
                                  widget: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MenuRow(
                                          press: () {
                                            Get.toNamed(
                                                RouteHelper.profileScreen);
                                          },
                                          iconLocation: MyIcons.profileNewIcon,
                                          text: MyStrings.profile),
                                      MenuRow(
                                          press: () {
                                            Get.toNamed(RouteHelper
                                                .changePasswordScreen);
                                          },
                                          iconLocation: MyIcons.lockIcon,
                                          text: MyStrings.changePassword),
                                      MenuRow(
                                          press: () {
                                            Get.toNamed(RouteHelper.kycScreen);
                                          },
                                          iconLocation: MyIcons.kycNewIcon,
                                          text: MyStrings.kycVerification),
                                      MenuRow(
                                          press: () {
                                            Get.toNamed(
                                                RouteHelper.notificationScreen);
                                          },
                                          iconLocation:
                                              MyIcons.menuNotificationIcon,
                                          text: MyStrings.notification,
                                          showDivider: false),
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            // Second Box with Shadow
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: MyColor.bgColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset:
                                        const Offset(0, 3), // Shadow position
                                  ),
                                ],
                              ),
                              child: RadiusCardShape(
                                  cardRadius: 12,
                                  widget: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MenuRow(
                                          press: () {
                                            Get.toNamed(RouteHelper
                                                .withdrawHistoryScreen);
                                          },
                                          iconLocation: MyIcons.withdrawNewIcon,
                                          text: MyStrings.myWithdrawals),
                                      MenuRow(
                                          press: () {
                                            Get.toNamed(RouteHelper
                                                .depositHistoryScreen);
                                          },
                                          iconLocation: MyIcons.depositNewIcon,
                                          text: MyStrings.depositHistory),
                                      MenuRow(
                                          press: () {
                                            Get.toNamed(
                                                RouteHelper.transactionScreen);
                                          },
                                          iconLocation: MyIcons.transferNewIcon,
                                          text: MyStrings.transactions),
                                      MenuRow(
                                          press: () {
                                            Get.toNamed(RouteHelper
                                                .advertisementScreen);
                                          },
                                          iconLocation: MyIcons.addNewIcon,
                                          text: MyStrings.advertisement),
                                      MenuRow(
                                          press: () {
                                            Get.toNamed(
                                                RouteHelper.referralScreen);
                                          },
                                          iconLocation: MyIcons.referNewIcon,
                                          text: MyStrings.referral,
                                          showDivider: false),
                                    ],
                                  )),
                            ),
                            const CustomSizedBox(
                              height: 15,
                            ),
                            // Third Box with Shadow
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: MyColor.bgColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset:
                                        const Offset(0, 3), // Shadow position
                                  ),
                                ],
                              ),
                              child: RadiusCardShape(
                                  cardRadius: 12,
                                  widget: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MenuRow(
                                        press: () {
                                          Get.toNamed(
                                              RouteHelper.twoFactorSetupScreen);
                                        },
                                        iconLocation: MyIcons.lockIcon,
                                        text: MyStrings.twoFactorAuth,
                                      ),
                                      MenuRow(
                                        press: () {
                                          Get.toNamed(RouteHelper.faqScreen);
                                        },
                                        iconLocation: MyIcons.faqIcon,
                                        text: MyStrings.faq.toUpperCase(),
                                      ),
                                      MenuRow(
                                        press: () {
                                          Get.toNamed(
                                              RouteHelper.allTicketScreen);
                                        },
                                        iconLocation: MyImages.supportTicket,
                                        text: MyStrings.supportTicket,
                                      ),
                                      MenuRow(
                                        press: () {
                                          Get.toNamed(
                                              RouteHelper.privacyScreen);
                                        },
                                        iconLocation: MyIcons.policyIconIcon,
                                        text: MyStrings.policies,
                                      ),
                                      MenuRow(
                                        isLoading: controller.logoutLoading,
                                        press: () {
                                          controller.logout();
                                        },
                                        iconLocation: MyIcons.logOutIcon,
                                        text: MyStrings.signOut,
                                        showDivider: false,
                                      ),
                                      const CustomDivider(),
                                      InkWell(
                                        onTap: () {
                                          const OpenCustomBottomSheet(
                                                  child:
                                                      DeleteAccountBottomsheetBody())
                                              .customBottomSheet(context);
                                        },
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              MyImages.userdeleteImage,
                                              height: 20,
                                              width: 20,
                                              fit: BoxFit.cover,
                                            ),
                                            const CustomSizedBox(
                                                width: 15, height: 0),
                                            SmallText(
                                              text: MyStrings.deleteAccount.tr,
                                              textStyle:
                                                  mulishSemiBold.copyWith(
                                                      fontSize: Dimensions
                                                          .fontDefault,
                                                      color: MyColor
                                                          .redCancelTextColor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    )),
            bottomNavigationBar: const CustomBottomNav(
              currentIndex: 4,
            ),
          ),
        ));
  }
}
