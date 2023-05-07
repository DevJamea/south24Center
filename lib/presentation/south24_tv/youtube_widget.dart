import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/domain/modela/youtube_model.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class YoutubeWidget extends StatelessWidget {
  const YoutubeWidget({
    Key? key,
    required this.size,
    required this.youtubeModel,
  }) : super(key: key);

  final Size size;
  final YoutubeModel youtubeModel;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Controller>(context);
    final imageUrl = youtubeModel.ytUrl ?? '';
    final isArabic = provider.isArabic();

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.s4),
            child: CachedNetworkImage(
              height: size.longestSide * AppSize.s_12,
              fit: BoxFit.cover,
              imageUrl: imageUrl,
              placeholder: (context, url) =>
                  SvgPicture.asset(ImageAssets.imagePhaceholder),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            height: size.longestSide * AppSize.s_12,
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
            child: Text(
              isArabic ? youtubeModel.ytTitle!.trim() : youtubeModel.ytTitlee!.trim(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: FontSizeManager.s14,
                fontWeight: FontWeightManager.bold,
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
