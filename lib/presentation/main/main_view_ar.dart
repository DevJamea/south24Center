import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/footer/footer_view.dart';
import 'package:south24/presentation/main/grid_view_section.dart';
import 'package:south24/presentation/main/image_slider.dart';
import 'package:south24/presentation/main/latest_release_section.dart';
import 'package:south24/presentation/main/list_view_section.dart';
import 'package:south24/presentation/main/name_section.dart';
import 'package:south24/presentation/main/news_widget.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:south24/presentation/widgets/news_widget_horizantal.dart';

class MianViewAr extends StatefulWidget {
  const MianViewAr({
    super.key,
  });

  @override
  State<MianViewAr> createState() => _MianStateAr();
}

class _MianStateAr extends State<MianViewAr> {
  late final Controller provider;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  _getInitData(List<dynamic>? list, Function getData) {
    if (list == null) {
      getData();
    } else {
      if (list.isEmpty) {
        getData();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    provider = context.read<Controller>();

    _getInitData(provider.searchList, provider.getSliderArNews);
    _getInitData(provider.analytics, provider.getAnalyticsArNews);
    _getInitData(provider.specialReports, provider.getSpecialReportsNews);
    _getInitData(provider.international, provider.getInternationalNews);
    _getInitData(provider.arabic, provider.getArarbicNews);
    _getInitData(provider.arabicVersions, provider.getArabicVersionsNews);
  }

  @override
  Widget build(BuildContext context) {
        analytics.setCurrentScreen(screenName: 'MainAr');

    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      if (!provider.isConnected) {
        return NoConnectionState(StateRendererType.fullScreenNoConnectionState,
                AppStrings.noInternetConnection.tr())
            .getScreenWidget(context);
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //image Silder section
            ImageSlider(
              size: size,
              newsList: provider.slider,
              retryButtonFunction: () {
                provider.slider = [];
                provider.notifyListeners();
                provider.getSliderArNews();
              },
            ),
            const SizedBox(
              height: AppSize.s14,
            ),

            //Analytics Section

            NameSection(
              sectionName: AppStrings.analytics,
              onShowMoreTab: () {
                provider.animateToPage(1);
              },
            ),

            ListViewSection(
              size: size,
              newsList: provider.analytics!,
              retryButtonFunction: () {
                provider.analytics = [];
                provider.notifyListeners();
                provider.getAnalyticsArNews();
              },
            ),

            const SizedBox(
              height: AppSize.s14,
            ),

            //Special Reports Section

            NameSection(
              sectionName: AppStrings.specialReports,
              onShowMoreTab: () {
                provider.animateToPage(2);
                provider.animateToReportsPage(1);
              },
            ),

            GridViewSection(
              size: size,
              newsList: provider.specialReports!,
              retryButtonFunction: () {
                provider.specialReports = [];
                provider.notifyListeners();
                provider.getSpecialReportsNews();
              },
            ),

            const SizedBox(
              height: AppSize.s14,
            ),

            //International Section

            NameSection(
              sectionName: AppStrings.international,
              onShowMoreTab: () {
                provider.animateToPage(2);
                provider.animateToReportsPage(2);
              },
            ),

            _InternationalSection(
              size: size,
              newsList: provider.international,
              retryButtonFunction: () {
                provider.international = [];
                provider.notifyListeners();
                provider.getInternationalNews();
              },
            ),
            const SizedBox(
              height: AppSize.s14,
            ),

            //Arabic News Section

            NameSection(
              sectionName: AppStrings.arabic,
              onShowMoreTab: () {
                provider.animateToPage(2);
                provider.animateToReportsPage(3);
              },
            ),

            _ArabicNewsSection(
              size: size,
              newsList: provider.arabic,
              retryButtonFunction: () {
                provider.arabic = [];
                provider.notifyListeners();
                provider.getArarbicNews();
              },
            ),

            //Latest Release Section

            NameSection(
              sectionName: AppStrings.latestRelease,
              onShowMoreTab: () {
                provider.animateToPage(5);
              },
            ),

            LatestReleaseSection(
              size: size,
              latestReleaseList: provider.arabicVersions,
              retryButtonFunction: () {
                provider.arabicVersions = [];
                provider.notifyListeners();
                provider.getArabicVersionsNews();
              },
            ),

            SizedBox(
              height: AppSize.s12,
            ),

            FooterView()
          ],
        ),
      );
    });
  }
}

class _ArabicNewsSection extends StatelessWidget {
  const _ArabicNewsSection({
    Key? key,
    required this.size,
    this.newsList,
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
      children: [
        const SizedBox(
          height: AppSize.s4,
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                  bottom: AppPadding.p12,
                  right: AppPadding.p12,
                  left: AppPadding.p12),
              child: SizedBox(
                width: double.infinity,
                height: size.height * AppSize.s_3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.s4),
                  child: NewsWidget(
                    height: null,
                    width: null,
                    news: newsList![index],
                    textOverFlow: false,
                    padding: AppPadding.p4,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _InternationalSection extends StatelessWidget {
  const _InternationalSection({
    Key? key,
    required this.size,
    required this.retryButtonFunction,
    this.newsList,
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
      children: [
        const SizedBox(
          height: AppSize.s4,
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return NewsWidgetHorizontal(size: size, news: newsList![index]);
          },
        ),
      ],
    );
  }
}
