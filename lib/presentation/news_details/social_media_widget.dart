import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/constants.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/news_details/translated_news_details.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaIcons extends StatelessWidget {
  final String? newsId;
  final String? text;
  final String? transletedNewsId;
  const SocialMediaIcons({
    Key? key,
    required this.newsId,
    required this.text,
    required this.transletedNewsId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shareUrl = '${Constants.viewNewsById}$newsId';
    return Consumer<Controller>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconWidget(
              color: ColorManager.twitterColor,
              assetName: ImageAssets.twitterIcon,
              onPressed: () =>
                  _shareLink('${Constants.twitterShareLink}$shareUrl'),
            ),
            SizedBox(width: AppSize.s8),
            IconWidget(
              color: ColorManager.facebookColor,
              assetName: ImageAssets.facebookIcon,
              onPressed: () =>
                  _shareLink('${Constants.facebookShareLink}$shareUrl'),
            ),
            SizedBox(width: AppSize.s8),
            IconWidget(
              color: ColorManager.whatsappColor,
              assetName: ImageAssets.whatsappIcon,
              onPressed: () =>
                  _shareLink('${Constants.whatsappShareLink}$shareUrl'),
            ),
            SizedBox(width: AppSize.s8),
            IconWidget(
              color: ColorManager.telegramColor,
              assetName: ImageAssets.telegramIcon,
              onPressed: () =>
                  _shareLink('${Constants.telegramShareLink}$shareUrl'),
            ),
            SizedBox(width: AppSize.s8),
            IconWidget(
              color: ColorManager.darkGrey,
              assetName: ImageAssets.emailIcon,
              onPressed: () =>
                  _shareLink('${Constants.emailShareLink}$shareUrl'),
            ),
            SizedBox(width: AppSize.s8),
            text != null
                ? Expanded(
                    child: Row(
                      children: [
                        TranslateWidget(
                          onPressed: () {
                            provider.showBottomSheet(TranslatedNewsDetailsView(
                                newsId: transletedNewsId));
                          },
                          text: text!,
                        ),
                        SizedBox(width: AppSize.s8),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      );
    });
  }

  void _shareLink(String link) {
    launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
  }
}

class IconWidget extends StatelessWidget {
  const IconWidget({
    Key? key,
    required this.color,
    required this.assetName,
    required this.onPressed,
  }) : super(key: key);

  final Color color;
  final String assetName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: AppSize.s40,
        height: AppSize.s40,
        padding: EdgeInsets.all(AppPadding.p12),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SvgPicture.asset(
          assetName,
          color: Colors.white,
        ),
      ),
    );
  }
}

class TranslateWidget extends StatelessWidget {
  const TranslateWidget({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: AppSize.s40,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: ColorManager.lightGrey,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          text,
          style: TextStyle(color: ColorManager.white),
        ),
      ),
    );
  }
}
