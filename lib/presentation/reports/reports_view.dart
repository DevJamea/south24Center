import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
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
  late final Controller provider;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);
    provider = context.read<Controller>();

    if (provider.reports == null && !provider.isArabic()) {
      provider.getReportsNews();
    } else {
      if (provider.reports!.isEmpty && !provider.isArabic()) {
        provider.getReportsNews();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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

      if (!provider.isArabic()) {
        if (!provider.isConnected) {
          return NoConnectionState(
                  StateRendererType.fullScreenNoConnectionState,
                  AppStrings.noInternetConnection.tr())
              .getScreenWidget(context);
        }

        if (provider.reports == null) {
          return ErrorState(
              stateRendererType: StateRendererType.fullScreenErorr,
              retryActionFunction: () {
                provider.reports = [];
                provider.notifyListeners();
                provider.getReportsNews();
              }).getScreenWidget(context);
        }

        if (provider.reports!.isEmpty) {
          return LoadingState(
                  stateRendererType: StateRendererType.fullScreenLoadingState)
              .getScreenWidget(context);
        }

        return Scaffold(
          body: ListView.builder(
            itemCount: provider.reports!.length,
            padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
            itemBuilder: (context, index) {
              return NewsWidgetHorizontal(
                size: size,
                news: provider.reports![index],
              );
            },
          ),
        );
      }
      return _ReportsArabicTabController(
          tabs: tabs, size: size, tabController: _tabController);
    });
  }
}

class _ReportsArabicTabController extends StatelessWidget {
  const _ReportsArabicTabController({
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
                  child: _ReportsArabicPageView(provider),
                ),
              ],
            ),
          ));
    });
  }

  PageView _ReportsArabicPageView(Controller provider) {
    return PageView.builder(
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
    );
  }
}
