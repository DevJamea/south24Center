import 'dart:ui' as UI;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/routs_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class SearchNewsWidget extends StatelessWidget {
  const SearchNewsWidget({
    required this.size,
    required this.news,
  });

  final Size size;
  final NewsJson news;

  @override
  Widget build(BuildContext context) {
    final Controller provider = context.read<Controller>();
    return Directionality(
      textDirection: provider.EnTopicId.contains(news.newsTopicid)
          ? UI.TextDirection.ltr
          : UI.TextDirection.rtl,
      child: InkWell(
        onTap: () {
          if (news.newsTopicid == "16") {
            Navigator.pushNamed(
              context,
              Routes.SearchedMemberDetails,
              arguments: news.newsId,
            );
          } else {
            Navigator.pushNamed(
              context,
              Routes.SearchedNewsDetails,
              arguments: news.newsId,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppPadding.p4,
            horizontal: AppPadding.p12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                    maxWidthDiskCache: 400,
                    maxHeightDiskCache: 280,
                    imageUrl: news.newsPic!,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p8),
                  child: SizedBox(
                    height: size.height > size.width
                        ? size.height * AppSize.s_15
                        : size.width * AppSize.s_20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppPadding.p20),
                          child: VerticalDivider(
                            thickness: AppSize.s4,
                            color: ColorManager.twitterColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            news.newsSubject!.trim(),
                            maxLines: 4,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontSize: FontSizeManager.s12,
                              color: ColorManager.black,
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontWeightManager.bold,
                            ),
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
      ),
    );
  }
}
