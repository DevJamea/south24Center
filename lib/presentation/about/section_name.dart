import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/about/member_card.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class SectionNameWidget extends StatelessWidget {
  const SectionNameWidget(
      {super.key, required this.sectionName, required this.tag});
  final sectionName;
  final tag;
  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(builder: (context, provider, child) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Divider(
                  color: ColorManager.lightBlack,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
                child: Text(
                  sectionName,
                  style: getSemiBoldStyle(color: ColorManager.black),
                ),
              ),
              Expanded(
                child: Divider(
                  color: ColorManager.lightBlack,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSize.s12,
          ),
          Container(
            margin: EdgeInsets.all(13),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3 / 4,
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSize.s12,
                  mainAxisSpacing: AppSize.s12),
              itemCount: provider.about!
                  .where((element) => element.newsTags == tag)
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                return MemberCard(
                  newsJson: provider.about!
                      .where((element) => element.newsTags == tag)
                      .toList()
                      .reversed
                      .toList()[index],
                );
              },
            ),
          )
        ],
      );
    });
  }
}
