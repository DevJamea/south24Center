import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/main/news_widget.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class ListViewSection extends StatelessWidget {
  const ListViewSection({
    Key? key,
    required this.size,
    required this.newsList,
  required this.retryButtonFunction,
  }) : super(key: key);

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
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        const SizedBox(height: AppSize.s4),
        SizedBox(
          height: size.width * AppSize.s_4,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            padding: EdgeInsets.symmetric(horizontal: AppPadding.p8),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.s4),
                  child: NewsWidget(
                    height: size.width * AppSize.s_4,
                    width: size.width * AppSize.s_5,
                    news: newsList![index],
                    textOverFlow: true,
                    padding: AppPadding.p4,
                    maxLines: 2,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
