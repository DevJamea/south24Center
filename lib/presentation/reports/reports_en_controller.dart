import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/reports/history_and_culture.dart';
import 'package:south24/presentation/reports/reports.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class ReportsEnControllerView extends StatefulWidget {
  const ReportsEnControllerView({Key? key}) : super(key: key);

  @override
  State<ReportsEnControllerView> createState() =>
      _ReportsEnControllerViewState();
}

class _ReportsEnControllerViewState extends State<ReportsEnControllerView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final Controller provider;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);
    provider = context.read<Controller>();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  final List<String> tabs = [
    AppStrings.reports,
    AppStrings.historyAndCulture,
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      _tabController.animateTo(provider.curretnReportsTab);
      return _ReportsEnglishTabController(
          tabs: tabs, size: size, tabController: _tabController);
    });
  }
}

class _ReportsEnglishTabController extends StatelessWidget {
  const _ReportsEnglishTabController({
    required this.tabs,
    required this.size,
    required TabController tabController,
  }) : _tabController = tabController;

  final List<String> tabs;
  final Size size;
  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(builder: (context, provider, child) {
      return DefaultTabController(
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
                        provider.reporstPageController.animateToPage(value,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOutSine);
                      },
                      isScrollable: true,
                      indicatorColor: ColorManager.secondery,
                      labelColor: ColorManager.white,
                      indicatorWeight: AppSize.s4,
                      indicatorPadding:
                          const EdgeInsets.symmetric(horizontal: AppPadding.p8),
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
                  child: _ReportsEnglishPageView(provider),
                ),
              ],
            ),
          ));
    });
  }

  PageView _ReportsEnglishPageView(Controller provider) {
    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tabs.length,
      controller: provider.reporstPageController,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const ReportsView();
        } else {
          return const HistoryAndCultureView();
        }
      },
    );
  }
}
