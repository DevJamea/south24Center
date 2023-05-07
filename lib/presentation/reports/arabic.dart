import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:south24/presentation/widgets/news_widget_horizantal.dart';

class ArabicView extends StatefulWidget {
  const ArabicView({super.key});

  @override
  State<ArabicView> createState() => _ArabicViewState();
}

class _ArabicViewState extends State<ArabicView> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<Controller>(context, listen: false);
    provider.arabic.isEmpty ? provider.getArarbicNews() : null;
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

      if (provider.arabic.isEmpty && !provider.exceotionOccured) {
        return LoadingState(
                stateRendererType: StateRendererType.fullScreenLoadingState)
            .getScreenWidget(context);
      }
      
      if (provider.exceotionOccured) {
        return Center(
          child: ElevatedButton(
              onPressed: () {
                provider.getArarbicNews();
              },
              child: Text("reload")),
        );
      }

      return Scaffold(
        body: ListView.builder(
          itemCount: provider.arabic.length,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
          itemBuilder: (context, index) {
            return NewsWidgetHorizontal(
              size: size,
              news: provider.arabic[index],
            );
          },
        ),
      );
    });
  }
}
