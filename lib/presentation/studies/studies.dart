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

class StudiesView extends StatefulWidget {
  const StudiesView({Key? key}) : super(key: key);

  @override
  State<StudiesView> createState() => _StudiesViewState();
}

class _StudiesViewState extends State<StudiesView> {
  late final Controller provider;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();

    provider = context.read<Controller>();
    if (provider.stdudies == null) {
      provider.getStdudiesNews();
    } else {
      if (provider.stdudies!.isEmpty) {
        provider.getStdudiesNews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: 'Studies');

    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(
      builder: (context, provider, child) {
        if (!provider.isConnected) {
          return NoConnectionState(
                  StateRendererType.fullScreenNoConnectionState,
                  AppStrings.noInternetConnection.tr())
              .getScreenWidget(context);
        }

        if (provider.stdudies == null) {
          return ErrorState(
              stateRendererType: StateRendererType.fullScreenErorr,
              retryActionFunction: () {
                provider.stdudies = [];
                provider.notifyListeners();
                provider.getStdudiesNews();
              }).getScreenWidget(context);
        }

        if (provider.stdudies!.isEmpty) {
          return LoadingState(
                  stateRendererType: StateRendererType.fullScreenLoadingState)
              .getScreenWidget(context);
        }

        return Scaffold(
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: provider.stdudies!.length,
            addAutomaticKeepAlives: false,
            padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
            itemBuilder: (context, index) {
              return NewsWidgetHorizontal(
                size: size,
                news: provider.stdudies![index],
              );
            },
          ),
        );
      },
    );
  }
}
