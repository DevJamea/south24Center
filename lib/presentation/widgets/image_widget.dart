import 'package:flutter/material.dart';
import 'package:south24/presentation/resources/assets_manager.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: ImageAssets.imagePhaceholderPng,
      image: imageUrl,
      fit: BoxFit.fill,
      fadeInDuration: const Duration(milliseconds: 5),
      fadeOutDuration: const Duration(milliseconds: 5),
      imageErrorBuilder: (context, error, stackTrace) =>
          const Center(child: Icon(Icons.error)),
    );
  }
}
