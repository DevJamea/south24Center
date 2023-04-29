import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:south24/domain/modela/arabic_versions.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/routs_manager.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class PublicationsWidget extends StatelessWidget {
  const PublicationsWidget({Key? key, required this.versions})
      : super(key: key);
  final ArabicVersions versions;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPortrait = screenSize.height > screenSize.width;
    final double aspectRatio = isPortrait ? 1.5 : 0.75;

    final double height = screenSize.height / 2;
    final double width = screenSize.width / 2 - AppSize.s8;

    final TextStyle textStyle =
        getMediumStyle(color: ColorManager.black, fontSize: FontSizeManager.s14);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.ArabicVersionsDetailsRoute,
          arguments: versions, // Pass the news object as an argument
        );
      },
      child: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: CachedNetworkImage(
                  fit: BoxFit.fitHeight,
                  imageUrl: versions.docPic!,
                  placeholder: (context, url) =>
                      SvgPicture.asset(ImageAssets.imagePhaceholder),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s8),
                child: Text(
                  versions.docSubject!.trim(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
