import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class LastSection extends StatelessWidget {
  const LastSection({Key? key}) : super(key: key);

  List<Widget> _buildTextWidgets(List<String> strings) {
    return strings
        .map((text) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppSize.s12,
                ),
                Text(
                  "– $text",
                  textAlign: TextAlign.justify,
                  style: getMediumStyle(
                      color: ColorManager.darkGrey,
                      fontSize: FontSizeManager.s14),
                ),
              ],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              AppStrings.about0.tr(),
              textAlign: TextAlign.center,
              style: getBoldStyle(
                  color: ColorManager.black, fontSize: FontSizeManager.s22),
            ),
          ),
          SizedBox(
            height: AppSize.s28,
          ),
          ..._buildTextWidgets([
            AppStrings.about6.tr(),
            AppStrings.about7.tr(),
            AppStrings.about8.tr(),
            AppStrings.about9.tr(),
            AppStrings.about10.tr(),
            AppStrings.about11.tr(),
            AppStrings.about12.tr(),
          ]),
        ],
      ),
    );
  }
}
