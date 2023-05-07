import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/presentation/main/news_widget.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class GridViewSection extends StatelessWidget {
  final Size size;
  final List<NewsJson> newsList;
  final String sectionName;
  final Function function;

  const GridViewSection(
      {super.key,
      required this.size,
      required this.newsList,
      required this.sectionName,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName.tr(),
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              InkWell(
                onTap: () {
                  function();
                },
                child: Text(
                  AppStrings.seeAll.tr(),
                  style: getSemiBoldStyle(color: ColorManager.grey),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: AppSize.s4,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
          child: GridView.custom(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverQuiltedGridDelegate(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 10,
              repeatPattern: QuiltedGridRepeatPattern.inverted,
              pattern: [
                const QuiltedGridTile(1, 2),
                const QuiltedGridTile(1, 1),
                const QuiltedGridTile(1, 1),
                const QuiltedGridTile(1, 2),
              ],
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  return SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.s4),
                      child: NewsWidget(
                        height: null,
                        width: null,
                        news: newsList[0],
                        textOverFlow: false,
                        padding: AppPadding.p4,
                      ),
                    ),
                  );
                } else if (index == 1) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 2 -
                        8, // subtracting crossAxisSpacing
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: AppPadding.p12,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.s4),
                        child: NewsWidget(
                          height: null,
                          width: null,
                          news: newsList[1],
                          textOverFlow: false,
                          maxLines: 2,
                          padding: AppPadding.p4,
                        ),
                      ),
                    ),
                  );
                } else {
                  // Other items in the grid
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: AppPadding.p12,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.s4),
                      child: NewsWidget(
                        height: null,
                        width: null,
                        news: newsList[2],
                        textOverFlow: false,
                        maxLines: 2,
                        padding: AppPadding.p4,
                      ),
                    ),
                  );
                }
              },
              childCount: 3,
            ),
          ),
        )
      ],
    );
  }
}
