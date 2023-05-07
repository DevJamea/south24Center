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
  const SpecialReportsView({Key? key}) : super(key: key);

  @override
  _SpecialReportsViewState createState() => _SpecialReportsViewState();
}

class _SpecialReportsViewState extends State<SpecialReportsView> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<Controller>(context, listen: false);
    if (provider.specialReports.isEmpty) {
      provider.getSpecialReportsNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer<Controller>(
      builder: (context, provider, child) {
        if (provider.specialReports.isEmpty) {
          return LoadingState(
            stateRendererType: StateRendererType.fullScreenLoadingState,
          ).getScreenWidget(context);
        }

        if (!provider.isConnected) {
          return ErrorState(
            StateRendererType.fullScreenErrorState,
            AppStrings.noInternetConnection.tr(),
          ).getScreenWidget(context);
        }

        return ListView.builder(
          itemCount: provider.specialReports.length,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
          itemBuilder: (context, index) {
            return NewsWidgetHorizontal(
              size: size,
              news: provider.specialReports[index],
            );
          },
        );
      },
    );
  }
}
