import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:south24/presentation/widgets/news_widget_horizantal.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      return Scaffold(
        body: !provider.isConnected
            ? ErrorState(StateRendererType.fullScreenErrorState,
                    AppStrings.noInternetConnection.tr())
                .getScreenWidget(context)
            : provider.analytics.isEmpty
                ? LoadingState(
                        stateRendererType:
                            StateRendererType.fullScreenLoadingState)
                    .getScreenWidget(context , )
                : ListView.builder(
                    itemCount:provider.analytics.length,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppPadding.p8),
                    itemBuilder: (context, index) {
                      return NewsWidgetHorizontal(
                        size: size,
                        news: provider.analytics[index],
                      );
                    },
                  ),
      );
    });
  }
}
