import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:south24/presentation/widgets/news_widget_horizantal.dart';

class UniversityResearchView extends StatefulWidget {
  const UniversityResearchView({Key? key}) : super(key: key);

  @override
  State<UniversityResearchView> createState() => _UniversityResearchViewState();
}

class _UniversityResearchViewState extends State<UniversityResearchView> {
  late final Controller provider;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();

    provider = context.read<Controller>();

    if (provider.universityResearch == null) {
      provider.isArabic()
          ? provider.getUniversityResearchArNews()
          : provider.getUniversityResearchEnNews();
    } else {
      if (provider.universityResearch!.isEmpty) {
        provider.isArabic()
            ? provider.getUniversityResearchArNews()
            : provider.getUniversityResearchEnNews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        analytics.logScreenView(screenName: 'University Research');

    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      if (!provider.isConnected) {
        return NoConnectionState(StateRendererType.fullScreenNoConnectionState,
                AppStrings.noInternetConnection.tr())
            .getScreenWidget(context);
      }

      if (provider.universityResearch == null) {
        return ErrorState(
            stateRendererType: StateRendererType.fullScreenErorr,
            retryActionFunction: () {
              provider.universityResearch = [];
              provider.notifyListeners();
              provider.isArabic()
                  ? provider.getUniversityResearchArNews()
                  : provider.getUniversityResearchEnNews();
            }).getScreenWidget(context);
      }

      if (provider.universityResearch!.isEmpty) {
        return LoadingState(
                stateRendererType: StateRendererType.fullScreenLoadingState)
            .getScreenWidget(context);
      }

      return Scaffold(
        body: ListView.builder(
          itemCount: provider.universityResearch!.length,
          addAutomaticKeepAlives: false,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
          itemBuilder: (context, index) {
            return NewsWidgetHorizontal(
              size: size,
              news: provider.universityResearch![index],
            );
          },
        ),
      );
    });
  }
}
