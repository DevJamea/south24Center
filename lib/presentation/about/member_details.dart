import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberDetails extends StatelessWidget {
  const MemberDetails({Key? key, required this.newsJson}) : super(key: key);

  final NewsJson newsJson;

  Style _getHTMLStyle() {
    return Style(
        fontSize: FontSize(FontSizeManager.s14),
        fontWeight: FontWeightManager.semiBold,
        fontFamily: FontConstants.fontFamily,
        color: ColorManager.darkPrimary,
        textAlign: TextAlign.justify);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Controller>(context);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          ImageAssets.splashLogo,
          height: AppBar().preferredSize.height - AppSize.s18,
        ),
      ),
      body: Stack(
        children: [
          CachedNetworkImage(
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: newsJson.newsPic!,
            placeholder: (context, url) =>
                SvgPicture.asset(ImageAssets.imagePhaceholder),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: ColorManager.white70,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSize.s28),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.s64),
                      child: CachedNetworkImage(
                        height: AppSize.s128,
                        width: AppSize.s128,
                        fit: BoxFit.cover,
                        imageUrl: newsJson.newsPic!,
                        placeholder: (context, url) =>
                            SvgPicture.asset(ImageAssets.imagePhaceholder),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.s16),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppPadding.p12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.isArabic()
                              ? newsJson.newsSubject!.trim()
                              : newsJson.newsEsubject!.trim(),
                          style: getBoldStyle(
                              color: ColorManager.darkGrey,
                              fontSize: FontSizeManager.s28),
                        ),
                        SizedBox(height: AppSize.s8),
                        Html(
                          data: provider.isArabic()
                              ? newsJson.newsBudy!.trim()
                              : newsJson.newsEbudy!.trim(),
                          style: {
                            'body': _getHTMLStyle(),
                            'span': _getHTMLStyle(),
                            'font': _getHTMLStyle()
                          },
                          onLinkTap: (url, context, attributes, element) {
                            launchUrl(Uri.parse(url!),
                                mode: LaunchMode.externalApplication);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
