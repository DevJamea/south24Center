import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context, provider, child) {
        return Container(
          height: AppSize.s50,
          margin: const EdgeInsets.all(AppPadding.p12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: ColorManager.lightGrey,
                offset: const Offset(0, 4),
                blurRadius: AppSize.s8,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                     final searchQuery = provider.searchController.text.trim();
                    if (searchQuery.isNotEmpty) {
                      provider.searchData(searchQuery);
                      FocusScope.of(context).unfocus();
                    }
                  },
                  controller: provider.searchController,
                  style: getMediumStyle(color: ColorManager.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: AppStrings.search.tr(),
                  ),
                ),
              ),
              Container(
                height: AppSize.s50,
                margin: const EdgeInsets.all(AppMargin.m4),
                child: ElevatedButton(
                  onPressed: () {
                    final searchQuery = provider.searchController.text.trim();
                    if (searchQuery.isNotEmpty) {
                      provider.searchData(searchQuery);
                      FocusScope.of(context).unfocus();
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  child: Text(
                    AppStrings.searchWord.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
