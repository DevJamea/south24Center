import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/parser.dart' as html;
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/routs_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({Key? key, required this.newsJson}) : super(key: key);

  final NewsJson newsJson;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height / 1.5;
    final double width = screenSize.width / 2 - AppSize.s8;

    final TextStyle textStyle = getSemiBoldStyle(
        color: ColorManager.black, fontSize: FontSizeManager.s14);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.MemberDetailsRoute,
          arguments: newsJson,
        );
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: ColorManager.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                double height = constraints.maxHeight;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(height / 2),
                  child: CachedNetworkImage(
                    width: height,
                    fit: BoxFit.cover,
                    imageUrl: newsJson.newsPic!,
                    placeholder: (context, url) =>
                        SvgPicture.asset(ImageAssets.imagePhaceholder),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                );
              }),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.s4, vertical: AppSize.s8),
                child: Text(
                  Localizations.localeOf(context).languageCode ==
                          AppStrings.arabicLanguage
                      ? newsJson.newsSubject!.trim()
                      : newsJson.newsEsubject!.trim(),
                  maxLines: 2, // Set maxLines to 2
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.s4,
                ),
                child: Text(
                  Localizations.localeOf(context).languageCode ==
                          AppStrings.arabicLanguage
                      ? html
                          .parse(newsJson.newsAuth!.trim())
                          .documentElement!
                          .text
                      : html
                          .parse(newsJson.newsRef!.trim())
                          .documentElement!
                          .text,
                  style: getMediumStyle(color: ColorManager.darkGrey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
