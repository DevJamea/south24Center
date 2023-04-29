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
    super.key,
    required this.size,
    required this.youtubeModel,
  });

  final Size size;
  final YoutubeModel youtubeModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(builder: (context, provider, child) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.s4),
              child: CachedNetworkImage(
                height: size.height > size.width
                    ? size.height * AppSize.s_12
                    : size.width * AppSize.s_12,
                fit: BoxFit.cover,
                imageUrl: youtubeModel.ytUrl!,
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
              height: size.height > size.width
                  ? size.height * AppSize.s_12
                  : size.width * AppSize.s_12,
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
              child: Text(
                provider.isArabic()
                    ? youtubeModel.ytTitle!.trim()
                    : youtubeModel.ytTitlee!.trim(),
                maxLines: 3,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: FontSizeManager.s14,
                    color: ColorManager.black,
                    fontFamily: FontConstants.fontFamily,
                    fontWeight: FontWeightManager.bold),
              ),
            ),
          ),
        ],
      );
    });
  }
}
