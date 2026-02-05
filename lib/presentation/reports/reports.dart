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

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  late final Controller provider;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();

    provider = context.read<Controller>();

    if (provider.reports == null) {
      provider.getReportsNews();
    } else {
      if (provider.reports!.isEmpty) {
        provider.getReportsNews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        analytics.logScreenView(screenName: 'ReportsEn');

    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      
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
          addAutomaticKeepAlives: false,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
          itemBuilder: (context, index) {
            return NewsWidgetHorizontal(
              size: size,
              news: provider.reports![index],
            );
          },
        ),
      );
    });
  }
}
