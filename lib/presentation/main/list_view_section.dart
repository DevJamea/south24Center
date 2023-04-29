import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/presentation/main/news_widget.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class ListViewSection extends StatelessWidget {
  final Size size;
  final List<NewsJson> newsList;
  final String sectionName;
  final Function function;

  const ListViewSection(
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
                      news: newsList[index],
                      textOverFlow: true,
                      padding: AppPadding.p4,
                      maxlines: 2,
                    )),
              );
            },
          ),
        )
      ],
    );
  }
}
