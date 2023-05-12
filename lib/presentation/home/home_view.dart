import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/about/about.dart';
import 'package:south24/presentation/analytics/analytics.dart';
import 'package:south24/presentation/breaking_news/breaking_news_view.dart';
import 'package:south24/presentation/home/bottom_app_bar_view.dart';
import 'package:south24/presentation/main/main_view_ar.dart';
import 'package:south24/presentation/main/main_view_en.dart';
import 'package:south24/presentation/publications/publications_view.dart';
import 'package:south24/presentation/reports/reports_view.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/routs_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:south24/presentation/south24_quarterly/south24_quarterly.dart';
import 'package:south24/presentation/south24_tv/south24_tv.dart';
import 'package:south24/presentation/studies/studies.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<Controller>(context, listen: false);
    _tabController = TabController(length: provider.tabsAr.length, vsync: this);
    if (!provider.isArabic()) {
      provider.twitter.isEmpty ? provider.getTwitterEnNews() : null;
    } else {
      provider.twitter.isEmpty ? provider.getTwitterArNews() : null;
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _tabController?.animateTo(Provider.of<Controller>(context).curretnTab);
    return Consumer<Controller>(builder: (context, provider, widget) {
      return DefaultTabController(
          length: provider.tabsAr.length,
          child: Scaffold(
            appBar: AppBar(
              primary: true,
              title: Image(
                image: const AssetImage(ImageAssets.splashLogo),
                height: AppBar().preferredSize.height - AppSize.s18,
              ),
              leading: Hero(
                tag: AppStrings.heroTag,
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.SearchScreenRoute,
                    );
                  },
                ),
              ),
              bottom: TabBar(
                  controller: _tabController,
                  onTap: (value) {
                    if (value == 8) {
                      provider.changeLanguage(context);
                    }
                    provider.current = value;
                    provider.curretnTab = value;
                    provider.pageController.animateToPage(value,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOutSine);
                  },
                  isScrollable: true,
                  indicatorColor: ColorManager.secondery,
                  labelColor: ColorManager.white,
                  indicatorWeight: AppSize.s4,
                  indicatorPadding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p8),
                  labelStyle: Theme.of(context).textTheme.headlineLarge,
                  unselectedLabelStyle:
                      Theme.of(context).textTheme.headlineMedium,
                  tabs: provider
                      .getTabsNames(context)
                      .map((e) => Tab(
                            icon: null,
                            text: e.tr(),
                          ))
                      .toList()),
            ),
            bottomNavigationBar: !provider.isConnected
                ? null
                : provider.checkTwittersNullable(context)
                    ? null
                    : SouthBottomAppBar(size: size),
            body: WillPopScope(
              onWillPop: () async {
                if (provider.curretnTab == 0) {
                  return true;
                } else {
                  provider.animateToPage(0);
                  return false;
                }
              },
              child: SafeArea(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.getTabsNames(context).length,
                  controller: provider.pageController,
                  itemBuilder: (context, index) {
                    if (index == 0 && provider.isArabic()) {
                      return const MianViewAr();
                    } else if (index == 0 && !provider.isArabic()) {
                      return const MianViewEn();
                    } else if (index == 1) {
                      return const AnalyticsView();
                    } else if (index == 2) {
                      return const ReportsView();
                    } else if (index == 3) {
                      return const BreakingNewsView();
                    } else if (index == 4) {
                      return provider.isArabic()
                          ? const StudiesView()
                          : const PublicationsView();
                    } else if (index == 5) {
                      return provider.isArabic()
                          ? const PublicationsView()
                          : const South24TV();
                    } else if (index == 6) {
                      return provider.isArabic()
                          ? const South24TV()
                          : const South24QuarterlyView();
                    } else {
                      return const AboutView();
                    }
                  },
                ),
              ),
            ),
          ));
    });
  }
}
