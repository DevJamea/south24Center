import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class FullscreenImageView extends StatelessWidget {
  final String imageUrl;

  const FullscreenImageView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        title: Image(
          image: const AssetImage(ImageAssets.splashLogo),
          height: AppBar().preferredSize.height - AppSize.s18,
        ),
      ),
      body: SafeArea(
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Hero(
              tag: imageUrl,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) =>
                    SvgPicture.asset(ImageAssets.imagePhaceholder),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
