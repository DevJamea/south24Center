import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:south24/presentation/widgets/news_widget_horizantal.dart';

class SpecialReportsView extends StatefulWidget {
  const SpecialReportsView({super.key});

  @override
  State<SpecialReportsView> createState() => _SpecialReportsViewState();
}

class _SpecialReportsViewState extends State<SpecialReportsView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      provider.specialReports.isEmpty ?provider.getSpecialReportsNews() : null;
      return Scaffold(
        body: !provider.isConnected
            ? ErrorState(StateRendererType.fullScreenErrorState,
                    AppStrings.noInternetConnection.tr())
                .getScreenWidget(context)
            : provider.specialReports.isEmpty
                ? LoadingState(
                        stateRendererType:
                            StateRendererType.fullScreenLoadingState)
                    .getScreenWidget(context)
                : ListView.builder(
                    itemCount: provider.specialReports.length,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppPadding.p8),
                    itemBuilder: (context, index) {
                      return NewsWidgetHorizantal(
                        size: size,
                        news: provider.specialReports[index],
                      );
                    },
                  ),
      );
    });
  }
}
