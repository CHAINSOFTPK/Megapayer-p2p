import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../../core/utils/dimensions.dart';
import '../../../../../../../core/utils/my_color.dart';
import '../../../../home/shimmer/custom_shimmer_effect.dart';


class TradeShimmer extends StatelessWidget {
  const TradeShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index){
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  Dimensions.cornerRadius),
              border: Border.all(
                  color: MyColor.borderColor, width: 1)),
          child: Shimmer.fromColors(
            baseColor: MyColor.shimmerBaseColor,
            highlightColor: MyColor.shimmerSplashColor,
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children:  [
                    Expanded(
                      child: Row(
                        children: [
                          MyShimmerEffectUI.rectangular(height: 12,width: 30,),
                          SizedBox(width: 5,),
                          MyShimmerEffectUI.rectangular(height: 15,width: 20,),
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    MyShimmerEffectUI.rectangular(height: 15,width: 60,),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: MyColor.transparentColor),
                  padding: const EdgeInsets.all(10),
                  child: const Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child:
                      Row(
                        children: [
                          MyShimmerEffectUI.circular(height: 25,width: 25,),
                           SizedBox(
                            width: 12,
                          ),
                          MyShimmerEffectUI.rectangular(height: 15,width: 60,),
                        ],
                      )),
                      Expanded(
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: MyShimmerEffectUI.rectangular(height: 15,width: 80,),),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children:  [
                    MyShimmerEffectUI.rectangular(height: 15,width: 120,),
                    MyShimmerEffectUI.rectangular(height: 15,width: 120,),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        );
      });
  }
}