import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/language_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class CenterSections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Uri facebook = Uri.parse("https://m.facebook.com/south24.net");
    final Uri twitterAr = Uri.parse("https://twitter.com/South24_net");
    final Uri telegram = Uri.parse("https://t.me/south24net");
    final Uri twitterEn = Uri.parse("https://twitter.com/South24E");
    final Uri youtube =
        Uri.parse("https://www.youtube.com/channel/UCqnCqHHLQgD70-jiGZ6hT4A");

    final Uri email1LaunchUri = Uri(
      scheme: 'mailto',
      path: AppStrings.email1,
    );

    final Uri email2LaunchUri = Uri(
      scheme: 'mailto',
      path: AppStrings.email2,
    );

    return Consumer<Controller>(builder: (context, provider, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: AppMargin.m12),
            child: Text(
              AppStrings.centerSections.tr(),
              style: getSemiBoldStyle(
                  color: ColorManager.black, fontSize: FontSizeManager.s18),
            ),
          ),
          SizedBox(
            height: AppSize.s8,
          ),
          FunctionWidget(
              text: AppStrings.south24Arabic.tr(),
              function: () {
                provider.changeLanguageToSpecific(
                    context, LanguageType.ARABIC.getValue());
              }),
          FunctionWidget(
              text: AppStrings.south24English.tr(),
              function: () {
                provider.changeLanguageToSpecific(
                    context, LanguageType.ENGLISH.getValue());
              }),
          TextWidget(
            text: AppStrings.arabicBreakingNewsService.tr(),
            uri:twitterAr,
          ),
          TextWidget(
            text: AppStrings.englishBreakingNewsService.tr(),
            uri: twitterEn,
          ),
          FunctionWidget(
              text: AppStrings.south24Channel.tr(),
              function: () {
                provider.animateToPage(provider.isArabic() ? 6 : 5);
              }),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: AppMargin.m12),
            child: Text(
              AppStrings.contactUs.tr(),
              style: getSemiBoldStyle(
                  color: ColorManager.black, fontSize: FontSizeManager.s18),
            ),
          ),
          SizedBox(
            height: AppSize.s8,
          ),
          TextWidget(
            text: AppStrings.email1,
            uri: email1LaunchUri,
          ),
          TextWidget(
            text: AppStrings.email2,
            uri: email2LaunchUri,
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: AppMargin.m12),
            child: Text(
              AppStrings.socialMedia.tr(),
              style: getSemiBoldStyle(
                  color: ColorManager.black, fontSize: FontSizeManager.s18),
            ),
          ),
          SizedBox(
            height: AppSize.s8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(
                youtube,
                ImageAssets.youtubeIcon,
              ),
              SizedBox(
                width: AppSize.s16,
              ),
              _buildIcon(
                telegram,
                ImageAssets.telegramIcon,
              ),
              SizedBox(
                width: AppSize.s16,
              ),
              _buildIcon(
                facebook,
                ImageAssets.facebookIcon,
              ),
              SizedBox(
                width: AppSize.s16,
              ),
              _buildIcon(
                provider.isArabic() ? twitterAr : twitterEn,
                ImageAssets.twitterIcon,
              ),
            ],
          ),
          SizedBox(
            height: AppSize.s28,
          ),
        ],
      );
    });
  }
}

class TextWidget extends StatelessWidget {
  final String text;
  final Uri uri;

  const TextWidget({super.key, required this.text, required this.uri});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          launchUrl(uri, mode: LaunchMode.externalApplication);
        },
        child: Text(text,
            style: getSemiBoldStyle(
                color: ColorManager.primary, fontSize: FontSizeManager.s16)));
  }
}

class FunctionWidget extends StatelessWidget {
  final String text;
  final Function function;

  const FunctionWidget({super.key, required this.text, required this.function});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          function();
        },
        child: Text(text,
            style: getSemiBoldStyle(
                color: ColorManager.primary, fontSize: FontSizeManager.s16)));
  }
}

Widget _buildIcon(Uri uri, String imageAsset) {
  return InkWell(
    splashColor: ColorManager.lightGrey,
    onTap: () {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    },
    child: Container(
      height: AppSize.s60,
      width: AppSize.s60,
      padding: EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
          color: ColorManager.gray50, borderRadius: BorderRadius.circular(30)),
      child: SvgPicture.asset(
        imageAsset,
        color: ColorManager.primary,
        fit: BoxFit.contain,
      ),
    ),
  );
}
