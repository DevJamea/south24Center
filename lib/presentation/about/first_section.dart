import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class FirstSectionAbout extends StatelessWidget {
  const FirstSectionAbout();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.aboutUs.tr(),
          style: TextStyle(
            color: ColorManager.black,
            fontSize: FontSizeManager.s22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSize.s28),
        Container(
          padding: EdgeInsets.all(AppPadding.p4),
          decoration: BoxDecoration(
            color: ColorManager.lightPrimary,
            borderRadius: BorderRadius.circular(AppSize.s8),
          ),
          child: Text(
            AppStrings.about1.tr(),
            style: TextStyle(
              color: ColorManager.white,
              fontSize: FontSizeManager.s16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: AppSize.s28),
        AboutText(text: AppStrings.about2.tr()),
        AboutText(text: AppStrings.about3.tr()),
        AboutText(text: AppStrings.about4.tr()),
        AboutText(text: AppStrings.about5.tr()),
      ],
    );
  }
}


class AboutText extends StatelessWidget {
  final String text;

  const AboutText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppSize.s12),
        Text(
          text,
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: ColorManager.darkGrey,
            fontSize: FontSizeManager.s14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}