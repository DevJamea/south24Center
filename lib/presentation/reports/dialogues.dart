import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:south24/presentation/widgets/news_widget_horizantal.dart';

class DialoguesView extends StatefulWidget {
  const DialoguesView({super.key});

  @override
  State<DialoguesView> createState() => _DialoguesViewState();
}

class _DialoguesViewState extends State<DialoguesView> {
  late final Controller provider;

  @override
  void initState() {
    super.initState();

    provider = context.read<Controller>();

    if (provider.dialogues == null) {
      provider.getDialoguesNews();
    } else {
      if (provider.dialogues!.isEmpty) {
        provider.getDialoguesNews();
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

        if (provider.dialogues == null) {
          return ErrorState(
              stateRendererType: StateRendererType.fullScreenErorr,
              retryActionFunction: () {
                provider.dialogues = [];
                provider.notifyListeners();
                provider.getDialoguesNews();
              }).getScreenWidget(context);
        }

        if (provider.dialogues!.isEmpty) {
          return LoadingState(
                  stateRendererType: StateRendererType.fullScreenLoadingState)
              .getScreenWidget(context);
        }

      return Scaffold(
        body: ListView.builder(
          itemCount: provider.dialogues!.length,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
          itemBuilder: (context, index) {
            return NewsWidgetHorizontal(
              size: size,
              news: provider.dialogues![index],
            );
          },
        ),
      );
    });
  }
}
