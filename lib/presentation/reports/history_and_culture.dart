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

class HistoryAndCultureView extends StatefulWidget {
  const HistoryAndCultureView({super.key});

  @override
  State<HistoryAndCultureView> createState() => _HistoryAndCultureViewState();
}

class _HistoryAndCultureViewState extends State<HistoryAndCultureView> {
  late final Controller provider;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();

    provider = context.read<Controller>();

    if (provider.historyAndCulture == null) {
      provider.isArabic()
          ? provider.getHistoryAndCultureArNews()
          : provider.getHistoryAndCultureEnNews();
    } else {
      if (provider.historyAndCulture!.isEmpty) {
        provider.isArabic()
            ? provider.getHistoryAndCultureArNews()
            : provider.getHistoryAndCultureEnNews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        analytics.logScreenView(screenName: 'History And Culture');

    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      if (!provider.isConnected) {
        return NoConnectionState(StateRendererType.fullScreenNoConnectionState,
                AppStrings.noInternetConnection.tr())
            .getScreenWidget(context);
      }

      if (provider.historyAndCulture == null) {
        return ErrorState(
            stateRendererType: StateRendererType.fullScreenErorr,
            retryActionFunction: () {
              provider.historyAndCulture = [];
              provider.notifyListeners();
              provider.isArabic()
                  ? provider.getHistoryAndCultureArNews()
                  : provider.getHistoryAndCultureEnNews();
            }).getScreenWidget(context);
      }

      if (provider.historyAndCulture!.isEmpty) {
        return LoadingState(
                stateRendererType: StateRendererType.fullScreenLoadingState)
            .getScreenWidget(context);
      }

      return Scaffold(
        body: ListView.builder(
          itemCount: provider.historyAndCulture!.length,
          addAutomaticKeepAlives: false,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
          itemBuilder: (context, index) {
            return NewsWidgetHorizontal(
              size: size,
              news: provider.historyAndCulture![index],
            );
          },
        ),
      );
    });
  }
}
