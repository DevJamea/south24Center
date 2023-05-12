import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class NameSection extends StatelessWidget {
  const NameSection({
    required this.onShowMoreTab,
    required this.sectionName,
  });

  final Function onShowMoreTab;
  final String sectionName;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              onShowMoreTab();
            },
            child: Text(
              AppStrings.seeAll.tr(),
              style: getSemiBoldStyle(color: ColorManager.grey),
            ),
          ),
        ],
      ),
    );
  }
}