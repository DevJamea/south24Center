import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:south24/presentation/widgets/news_widget_horizantal.dart';

import '../common/state_renderer.dart';

class EditorialView extends StatefulWidget {
  const EditorialView({super.key});

  @override
  State<EditorialView> createState() => _EditorialViewState();
}

class _EditorialViewState extends State<EditorialView> {
  late final Controller provider;

  @override
  void initState() {
    super.initState();

    provider = context.read<Controller>();

    if (provider.editorial == null) {
      provider.getEditorialNews();
    } else {
      if (provider.editorial!.isEmpty) {
        provider.getEditorialNews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
     
      if (!provider.isConnected) {
          return NoConnectionState(
                  StateRendererType.fullScreenNoConnectionState,
                  AppStrings.noInternetConnection.tr())
              .getScreenWidget(context);
        }

        if (provider.editorial == null) {
          return ErrorState(
              stateRendererType: StateRendererType.fullScreenErorr,
              retryActionFunction: () {
                provider.editorial = [];
                provider.notifyListeners();
                provider.getEditorialNews();
              }).getScreenWidget(context);
        }

        if (provider.editorial!.isEmpty) {
          return LoadingState(
                  stateRendererType: StateRendererType.fullScreenLoadingState)
              .getScreenWidget(context);
        }
        
      return Scaffold(
        body: ListView.builder(
          itemCount: provider.editorial!.length,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
          itemBuilder: (context, index) {
            return NewsWidgetHorizontal(
              size: size,
              news: provider.editorial![index],
            );
          },
        ),
      );
    });
  }
}
