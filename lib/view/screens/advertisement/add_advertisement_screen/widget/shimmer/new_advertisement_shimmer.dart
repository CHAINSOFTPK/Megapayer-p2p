import 'package:flutter/material.dart';
import 'package:local_coin/view/components/label_column/label_column_shimmer.dart';
import 'package:local_coin/view/screens/bottom_nav_pages/home/shimmer/custom_shimmer_effect.dart';

import '../../../../../../core/utils/my_color.dart';

class NewAdvertisementShimmer extends StatelessWidget {
  const NewAdvertisementShimmer({Key? key}) : super(key: key);
  final bool showPadding=false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(showPadding?10:2),
      child: const Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: LabelColumnShimmer()),
               SizedBox(
                width: 20,
              ),
              Expanded(child: LabelColumnShimmer()),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Divider(
            color: MyColor.borderColor,
          ),
          SizedBox(
            height: 12,
          ),
          MyShimmerEffectUI.rectangular(height: 20,width: 150,),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: LabelColumnShimmer()),
              SizedBox(
                width: 20,
              ),
              Expanded(child:LabelColumnShimmer()),
            ],
          ),
          SizedBox(
            height: 22,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: LabelColumnShimmer(),
              ),
               SizedBox(
                width: 12,
              ),
              Expanded(
                child: LabelColumnShimmer(),
              ),
            ],
          ),
          SizedBox(
            height: 22,
          ),
          LabelColumnShimmer(),
          SizedBox(
            height: 22,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: LabelColumnShimmer(),
              ),
              SizedBox(
                width: 12,
              ),
               Expanded(
                child: LabelColumnShimmer(),
              ),
            ],
          ),
          SizedBox(
            height: 22,
          ),
          LabelColumnShimmer(),
          SizedBox(
            height: 22,
          ),
          LabelColumnShimmer(),
          SizedBox(
            height: 22,
          ),
          LabelColumnShimmer(),
          SizedBox(
            height: 35,
          ),
         MyShimmerEffectUI.rectangular(height: 35,width: double.infinity,),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
