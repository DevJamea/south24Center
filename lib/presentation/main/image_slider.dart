import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/main/news_widget.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({
    super.key,
    required this.size,
    required this.newsList, required this.retryButtonFunction,
  });

  final Size size;
  final List<NewsJson>? newsList;
  final Function retryButtonFunction;

  @override
  Widget build(BuildContext context) {
    if (newsList == null) {
      return ErrorState(
          stateRendererType: StateRendererType.fullScreenErorr,
          retryActionFunction: () {
            retryButtonFunction();
          }).getScreenWidget(context);
    }

    if (newsList!.isEmpty) {
      return LoadingState(
              stateRendererType: StateRendererType.fullScreenLoadingState)
          .getScreenWidget(context);
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorManager.grey,
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: CarouselSlider(
        options: CarouselOptions(
          height: size.height > size.width
              ? size.height * AppSize.s_3
              : size.width * AppSize.s_5,
          autoPlay: true,
          viewportFraction: 1,
        ),
        items: newsList!.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return NewsWidget(
                height: size.height > size.width
                    ? size.height * AppSize.s_3
                    : size.width * AppSize.s_5,
                width: size.width,
                news: i,
                textOverFlow: false,
                padding: AppPadding.p20,
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
