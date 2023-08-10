import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class PartentersSection extends StatelessWidget {
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
                  AppStrings.partenters.tr(),
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
          ImageWidget(
              image: ImageAssets.hjfyemen, url: "https://www.hjfyemen.org/"),
          ImageWidget(
              image: ImageAssets.almarfacenter,
              url: "https://www.almarfacenter.org/"),
          ImageWidget(
            image: ImageAssets.peacetrackinitiative,
            url: "https://peacetrackinitiative.org/",
          ),
        ],
      );
    });
  }
}

class ImageWidget extends StatelessWidget {
  final String image;
  final String url;

  const ImageWidget({super.key, required this.image, required this.url});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
      child: Column(
        children: [
          InkWell(
              onTap: () {
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              },
              child: Image.asset(image)),
          SizedBox(
            height: AppSize.s12,
          ),
        ],
      ),
    );
  }
}
