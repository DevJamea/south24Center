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

class AnalyticsArView extends StatefulWidget {
  const AnalyticsArView({super.key});

  @override
  State<AnalyticsArView> createState() => _AnalyticsArViewState();
}

class _AnalyticsArViewState extends State<AnalyticsArView> {
  late final Controller provider;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();

    provider = context.read<Controller>();

    if (provider.analytics == null) {
      provider.getAnalyticsArNews();
    } else {
      if (provider.analytics!.isEmpty) {
        provider.getAnalyticsArNews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: 'AnaluticsAr');

    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      if (!provider.isConnected) {
        return NoConnectionState(StateRendererType.fullScreenNoConnectionState,
                AppStrings.noInternetConnection.tr())
            .getScreenWidget(context);
      }

      if (provider.analytics == null) {
        return ErrorState(
            stateRendererType: StateRendererType.fullScreenErorr,
            retryActionFunction: () {
              provider.analytics = [];
              provider.notifyListeners();
              provider.getAnalyticsArNews();
            }).getScreenWidget(context);
      }

      if (provider.analytics!.isEmpty) {
        return LoadingState(
                stateRendererType: StateRendererType.fullScreenLoadingState)
            .getScreenWidget(context);
      }

      return Scaffold(
        body: ListView.builder(
          itemCount: provider.analytics!.length,
          addAutomaticKeepAlives: false,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
          itemBuilder: (context, index) {
            return NewsWidgetHorizontal(
              size: size,
              news: provider.analytics![index],
            );
          },
        ),
      );
    });
  }
}
