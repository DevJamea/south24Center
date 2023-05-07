import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/routs_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({
    Key? key,
    required this.news,
    this.height,
    this.width,
    required this.textOverFlow,
    this.maxLines,
    required this.padding,
  }) : super(key: key);

  final NewsJson news;
  final double? height;
  final double? width;
  final bool textOverFlow;
  final int? maxLines;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.detailsRoute,
          arguments: news,
        );
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            height: height ?? double.infinity,
            width: width ?? double.infinity,
            fit: BoxFit.cover,
            imageUrl: news.newsPic!.trim(),
            placeholder: (context, url) =>
                SvgPicture.asset(ImageAssets.imagePhaceholder),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
          ),
          Positioned(
            bottom: AppSize.s0,
            right: AppSize.s0,
            left: AppSize.s0,
            child: Container(
              color: ColorManager.lightGrey,
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: AppSize.s4,
              ),
              child: Center(
                child: Text(
                  news.newsSubject!.trim(),
                  textAlign: TextAlign.center,
                  maxLines: maxLines,
                  style: textOverFlow
                      ? Theme.of(context).textTheme.titleMedium
                      : Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
