import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/reports/arabic.dart';
import 'package:south24/presentation/reports/dialogues.dart';
import 'package:south24/presentation/reports/editorial.dart';
import 'package:south24/presentation/reports/international.dart';
import 'package:south24/presentation/reports/special_reports.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:south24/presentation/widgets/news_widget_horizantal.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({Key? key}) : super(key: key);

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    final provider = Provider.of<Controller>(context, listen: false);
      if (!provider.isArabic()) {
        if (provider.reports.isEmpty) {
          provider.getReportsNews();
        }
      }
    super.initState();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
 
  final List<String> tabs = [
    AppStrings.editorial,
    AppStrings.specialReports,
    AppStrings.international,
    AppStrings.arabic,
    AppStrings.dialogues,
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      _tabController.animateTo(provider.curretnReportsTab);

      
      return !provider.isArabic()
          ? Scaffold(
              body: ListView.builder(
                itemCount: provider.reports.length,
                padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
                itemBuilder: (context, index) {
                  return NewsWidgetHorizontal(
                    size: size,
                    news: provider.reports[index],
                  );
                },
              ),
            )
          : DefaultTabController(
              length: tabs.length,
              child: Scaffold(
                body: Column(
                  children: [
                    Container(
                      width: size.width,
                      color: ColorManager.lightPrimary,
                      child: TabBar(
                          controller: _tabController,
                          onTap: (value) {
                            provider.currentReports = value;
                            provider.curretnReportsTab = value;
                            print(value.toString());
                            provider.reporstPageController.animateToPage(value,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOutSine);
                          },
                          isScrollable: true,
                          indicatorColor: ColorManager.secondery,
                          labelColor: ColorManager.white,
                          indicatorWeight: AppSize.s4,
                          indicatorPadding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p8),
                          labelStyle: TextStyle(
                              fontSize: FontSizeManager.s10,
                              color: ColorManager.white,
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontWeightManager.semiBold),
                          tabs: tabs
                              .map((e) => Tab(
                                    icon: null,
                                    text: e.tr(),
                                  ))
                              .toList()),
                    ),
                    Expanded(
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tabs.length,
                        controller: provider.reporstPageController,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return const EditorialView();
                          } else if (index == 1) {
                            return const SpecialReportsView();
                          } else if (index == 2) {
                            return const InternationalView();
                          } else if (index == 3) {
                            return const ArabicView();
                          } else {
                            return const DialoguesView();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ));
    });
  }
}
