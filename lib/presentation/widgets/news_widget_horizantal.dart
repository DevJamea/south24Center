import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/routs_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class NewsWidgetHorizontal extends StatelessWidget {
  const NewsWidgetHorizontal({
    required this.size,
    required this.news,
  });

  final Size size;
  final NewsJson news;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double maxTextWidth = size.width * 0.8;

    final subjectTextSpan = TextSpan(
      text: HtmlUnescape().convert(news.newsSubject!.trim()),
      style: TextStyle(
        fontSize: FontSizeManager.s14,
        color: ColorManager.black,
        fontFamily: FontConstants.fontFamily,
        fontWeight: FontWeight.bold,
      ),
    );

    final subjectTextPainter = TextPainter(
      text: subjectTextSpan,
      maxLines: 3,
      textDirection: TextDirection.ltr,
    );
    subjectTextPainter.layout(maxWidth: maxTextWidth);
    final subjectTextHeight = subjectTextPainter.height;

    final bodyTextSpan = TextSpan(
      text: HtmlUnescape().convert(news.newsBudy!.trim()),
      style: TextStyle(
        fontSize: FontSizeManager.s12,
        color: ColorManager.grey,
        fontFamily: FontConstants.fontFamily,
        fontWeight: FontWeightManager.light,
      ),
    );

    final bodyTextPainter = TextPainter(
      text: bodyTextSpan,
      maxLines: null,
      textDirection: TextDirection.ltr,
    );
    bodyTextPainter.layout(maxWidth: maxTextWidth);
    final bodyTextHeight = bodyTextPainter.height;

    final widgetHeight = subjectTextHeight + bodyTextHeight;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.detailsRoute,
          arguments: news,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.p4,
          horizontal: AppPadding.p12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.s4),
                child: CachedNetworkImage(
                  height: size.height > size.width
                      ? size.height * AppSize.s_15
                      : size.width * AppSize.s_20,
                  fit: BoxFit.cover,
                  imageUrl: news.newsPic!,
                  maxWidthDiskCache: 400,
                  maxHeightDiskCache: 280,
                  placeholder: (context, url) =>
                      SvgPicture.asset(ImageAssets.imagePhaceholder),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p8,
                ),
                child: SizedBox(
                  height: widgetHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                        text: subjectTextSpan,
                      ),
                      Expanded(
                        child: RichText(
                          text: bodyTextSpan,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
