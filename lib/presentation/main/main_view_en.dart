import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/footer/footer_view.dart';
import 'package:south24/presentation/main/grid_view_section.dart';
import 'package:south24/presentation/main/image_slider.dart';
import 'package:south24/presentation/main/latest_release_section.dart';
import 'package:south24/presentation/main/list_view_section.dart';
import 'package:south24/presentation/main/name_section.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class MianViewEn extends StatefulWidget {
  const MianViewEn({
    super.key,
  });

  @override
  State<MianViewEn> createState() => _MianStateEn();
}

class _MianStateEn extends State<MianViewEn> {
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

  void initState() {
    super.initState();
    provider = context.read<Controller>();

    _getInitData(provider.slider, provider.getSliderEnNews);
    _getInitData(provider.analytics, provider.getAnalyticsEnNews);
    _getInitData(provider.reports, provider.getReportsNews);
    _getInitData(provider.publications, provider.getPublicationsNews);
  }

  @override
  Widget build(BuildContext context) {
        analytics.logScreenView(screenName: 'MainEn');

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
                provider.getSliderEnNews();
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
                provider.getAnalyticsEnNews();
              },
            ),

            const SizedBox(
              height: AppSize.s14,
            ),

            //Reports Section
            NameSection(
              sectionName: AppStrings.reports,
              onShowMoreTab: () {
                provider.animateToPage(2);
              },
            ),

            GridViewSection(
              size: size,
              newsList: provider.reports!,
              retryButtonFunction: () {
                provider.reports = [];
                provider.notifyListeners();
                provider.getReportsNews();
              },
            ),

            const SizedBox(
              height: AppSize.s12,
            ),

            //Latest Release Section

            NameSection(
              sectionName: AppStrings.latestRelease,
              onShowMoreTab: () {
                provider.animateToPage(4);
              },
            ),

            LatestReleaseSection(
              size: size,
              latestReleaseList: provider.publications,
              retryButtonFunction: () {
                provider.publications = [];
                provider.notifyListeners();
                provider.getPublicationsNews();
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
