import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:south24/domain/modela/arabic_versions.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/routs_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class LatestReleaseSection extends StatelessWidget {
  const LatestReleaseSection({
    Key? key,
    required this.size,
    this.latestReleaseList,
    required this.retryButtonFunction,
  }) : super(key: key);

  final Size size;
  final List<ArabicVersions>? latestReleaseList;
  final Function retryButtonFunction;
  @override
  Widget build(BuildContext context) {
    if (latestReleaseList == null) {
      return ErrorState(
          stateRendererType: StateRendererType.fullScreenErorr,
          retryActionFunction: () {
            retryButtonFunction();
          }).getScreenWidget(context);
    }

    if (latestReleaseList!.isEmpty) {
      return LoadingState(
              stateRendererType: StateRendererType.fullScreenLoadingState)
          .getScreenWidget(context);
    }

    return Column(
      children: [
        const SizedBox(
          height: AppSize.s4,
        ),
        SizedBox(
          height: size.height * AppSize.s_3,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            addAutomaticKeepAlives: false,
            itemCount: 4,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.ArabicVersionsDetailsRoute,
                    arguments: latestReleaseList![
                        index], // Pass the news object as an argument
                  );
                },
                child: CachedNetworkImage(
                  height: size.height * AppSize.s_3,
                  width: size.width / AppSize.s2,
                  fit: BoxFit.cover,
                  imageUrl: latestReleaseList![index].docPic!,
                  placeholder: (context, url) =>
                      SvgPicture.asset(ImageAssets.imagePhaceholder),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}