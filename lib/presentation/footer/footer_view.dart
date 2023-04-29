import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterView extends StatelessWidget {
  const FooterView({super.key});

  @override
  Widget build(BuildContext context) {
    final Uri email1LaunchUri = Uri(
      scheme: 'mailto',
      path: AppStrings.email1,
    );

    final Uri email2LaunchUri = Uri(
      scheme: 'mailto',
      path: AppStrings.email2,
    );

    final Uri facebook = Uri.parse("https://www.facebook.com/south24.net");
    final Uri twitterAr = Uri.parse("https://twitter.com/South24_net");
    final Uri website = Uri.parse("https://www.south24.net/");
    final Uri twitterEn = Uri.parse("https://twitter.com/South24E");
    final Uri youtube =
        Uri.parse("https://www.youtube.com/channel/UCqnCqHHLQgD70-jiGZ6hT4A");

    return Consumer<Controller>(builder: (context, provider, child) {
      return Container(
        padding: EdgeInsets.all(AppSize.s12),
        color: ColorManager.footerColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.headOffice.tr(),
              style: getBoldStyle(
                  color: ColorManager.secondery, fontSize: FontSizeManager.s24),
            ),
            SizedBox(
              height: AppSize.s12,
            ),
            Row(
              children: [
                Icon(
                  Icons.home,
                  color: ColorManager.white,
                ),
                SizedBox(
                  width: AppSize.s12,
                ),
                Text(
                  AppStrings.switzerland.tr(),
                  style: getMediumStyle(
                      color: ColorManager.white70,
                      fontSize: FontSizeManager.s18),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.email, color: ColorManager.white),
                SizedBox(
                  width: AppSize.s12,
                ),
                InkWell(
                  splashColor: ColorManager.lightGrey,
                  onTap: () {
                    launchUrl(email1LaunchUri);
                  },
                  child: Text(
                    AppStrings.email1,
                    style: getMediumStyle(
                        color: ColorManager.white70,
                        fontSize: FontSizeManager.s18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.email, color: ColorManager.white),
                SizedBox(
                  width: AppSize.s12,
                ),
                InkWell(
                  splashColor: ColorManager.lightGrey,
                  onTap: () {
                    launchUrl(email2LaunchUri);
                  },
                  child: Text(
                    AppStrings.email2,
                    style: getMediumStyle(
                        color: ColorManager.white70,
                        fontSize: FontSizeManager.s18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.link, color: ColorManager.white),
                SizedBox(
                  width: AppSize.s12,
                ),
                InkWell(
                  splashColor: ColorManager.lightGrey,
                  onTap: () {
                    launchUrl(website, mode: LaunchMode.externalApplication);
                  },
                  child: Text(
                    AppStrings.website,
                    style: getMediumStyle(
                        color: ColorManager.white70,
                        fontSize: FontSizeManager.s18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: ColorManager.lightGrey,
                  onTap: () {
                    launchUrl(youtube, mode: LaunchMode.externalApplication);
                  },
                  child: SvgPicture.asset(
                    ImageAssets.youtubeIcon,
                    color: ColorManager.white,
                    height: AppSize.s40,
                    width: AppSize.s40,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 12),
                InkWell(
                  splashColor: ColorManager.lightGrey,
                  onTap: () {
                    launchUrl(facebook, mode: LaunchMode.externalApplication);
                  },
                  child: SvgPicture.asset(
                    ImageAssets.facebookIcon,
                    color: ColorManager.white,
                    height: AppSize.s40,
                    width: AppSize.s40,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 12),
                InkWell(
                  splashColor: ColorManager.lightGrey,
                  onTap: () {
                    launchUrl(provider.isArabic() ? twitterAr : twitterEn,
                        mode: LaunchMode.externalApplication);
                  },
                  child: SvgPicture.asset(
                    ImageAssets.twitterIcon,
                    color: ColorManager.white,
                    height: AppSize.s40,
                    width: AppSize.s40,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
