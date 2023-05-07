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
  const FooterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Controller>(context);

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

    return Container(
      padding: const EdgeInsets.all(AppSize.s12),
      color: ColorManager.footerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.headOffice.tr(),
            style: getBoldStyle(
              color: ColorManager.secondery,
              fontSize: FontSizeManager.s24,
            ),
          ),
          const SizedBox(height: AppSize.s12),
          Row(
            children: [
              Icon(
                Icons.home,
                color: ColorManager.white,
              ),
              const SizedBox(width: AppSize.s12),
              Text(
                AppStrings.switzerland.tr(),
                style: getMediumStyle(
                  color: ColorManager.white70,
                  fontSize: FontSizeManager.s18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          _buildEmailRow(email1LaunchUri, AppStrings.email1),
          const SizedBox(height: 5),
          _buildEmailRow(email2LaunchUri, AppStrings.email2),
          const SizedBox(height: 5),
          _buildEmailRow(website, AppStrings.website),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(
                youtube,
                ImageAssets.youtubeIcon,
              ),
              const SizedBox(width: 12),
              _buildIcon(
                facebook,
                ImageAssets.facebookIcon,
              ),
              const SizedBox(width: 12),
              _buildIcon(
                provider.isArabic() ? twitterAr : twitterEn,
                ImageAssets.twitterIcon,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmailRow(Uri uri, String text) {
    return Row(
      children: [
        Icon(Icons.email, color: ColorManager.white),
        const SizedBox(width: AppSize.s12),
        InkWell(
          splashColor: ColorManager.lightGrey,
          onTap: () => launchUrl(uri),
          child: Text(
            text,
            style: getMediumStyle(
              color: ColorManager.white70,
              fontSize: FontSizeManager.s18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinkRow(
      IconData icon, String text, Uri uri, BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: ColorManager.white),
        SizedBox(width: AppSize.s12),
        InkWell(
          splashColor: ColorManager.lightGrey,
          onTap: () {
            launchUrl(uri, mode: LaunchMode.externalApplication);
          },
          child: Text(
            text,
            style: getMediumStyle(
              color: ColorManager.white70,
              fontSize: FontSizeManager.s18,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildIcon(Uri uri, String imageAsset) {
  return InkWell(
    splashColor: ColorManager.lightGrey,
    onTap: () {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    },
    child: SvgPicture.asset(
      imageAsset,
      color: ColorManager.white,
      height: AppSize.s40,
      width: AppSize.s40,
      fit: BoxFit.contain,
    ),
  );
}
