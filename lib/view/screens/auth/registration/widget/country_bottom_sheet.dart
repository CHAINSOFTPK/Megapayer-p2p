import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/my_color.dart';
import 'package:local_coin/core/utils/styles.dart';
import 'package:local_coin/core/utils/url_container.dart';
import 'package:local_coin/core/utils/util.dart';
import 'package:local_coin/data/controller/auth/profile_complete_controller.dart';
import 'package:local_coin/data/model/country_model/CountryModel.dart';
import 'package:local_coin/view/components/bottom_sheet/custom_bottom_sheet_plus.dart';
import 'package:local_coin/view/components/bottom_sheet_card/bottom_sheet_card.dart';
import 'package:local_coin/view/components/custom_text_field.dart';

class CountryBottomSheet {
  static void profileCompleteCountryBottomSheet(BuildContext context, ProfileCompleteController controller) {
    CustomBottomSheetPlus(
      bgColor: Colors.grey.withOpacity(.2),
      isNeedPadding: false,
      child: StatefulBuilder(
        builder: (context, setState) {
          if (controller.filteredCountries.isEmpty) {
            controller.filteredCountries = controller.countryList;
          }
          // Function to filter countries based on the search input.
          void filterCountries(String query) {
            if (query.isEmpty) {
              controller.filteredCountries = controller.countryList;
            } else {
              List<Countries> filterData = controller.filteredCountries.where((country) => country.country!.toLowerCase().contains(query.toLowerCase())).toList();
              setState(() {
                controller.filteredCountries = filterData;
              });
            }
          }

          return Container(
            height: MediaQuery.of(context).size.height * .8,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: MyColor.colorWhite,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: MyUtils.getShadow(),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  labelText: '',
                  hintText: MyStrings.searchCountry.tr,
                  controller: controller.countryController,
                  inputType: TextInputType.text,
                  onChanged: filterCountries,
                  prefixIcon: Icons.search,
                ),
                const SizedBox(height: 15),
                Flexible(
                  child: ListView.builder(
                      itemCount: controller.filteredCountries.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var countryItem = controller.filteredCountries[index];

                        return GestureDetector(
                          onTap: () {
                            controller.countryController.text = controller.filteredCountries[index].country ?? '';
                            controller.setCountryNameAndCode(controller.filteredCountries[index].country ?? '', controller.filteredCountries[index].countryCode ?? '', controller.filteredCountries[index].dialCode ?? '');

                            Navigator.pop(context);

                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          child: BottomSheetCard(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(end: Dimensions.space10),
                                  child: Image.network(
                                    UrlContainer.countryFlagImageLink.replaceAll("{countryCode}", countryItem.countryCode.toString().toLowerCase()),
                                    height: Dimensions.space25,
                                    width: Dimensions.space40 + 2,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '+${controller.filteredCountries[index].dialCode}  ${controller.filteredCountries[index].country?.tr ?? ''}',
                                    style: robotoRegular.copyWith(color: MyColor.textColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          );
        },
      ),
    ).show(context);
  }
}
