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

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<Controller>(context, listen: false);
    provider.dialogues.isEmpty ? provider.getDialoguesNews() : null;
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      
      if (!provider.isConnected) {
        return ErrorState(StateRendererType.fullScreenErrorState,
                AppStrings.noInternetConnection.tr())
            .getScreenWidget(context);
      }

      if (provider.dialogues.isEmpty) {
        return LoadingState(
                stateRendererType: StateRendererType.fullScreenLoadingState)
            .getScreenWidget(context);
      }
      
      return Scaffold(
        body: ListView.builder(
                    itemCount: provider.dialogues.length,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppPadding.p8),
                    itemBuilder: (context, index) {
                      return NewsWidgetHorizontal(
                        size: size,
                        news: provider.dialogues[index],
                      );
                    },
                  ),
      );
    });
  }
}
