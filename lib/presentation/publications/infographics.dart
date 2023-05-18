import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/publications/infographics_widget.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class InfographicsView extends StatefulWidget {
  const InfographicsView({super.key});

  @override
  State<InfographicsView> createState() => _InfographicsViewState();
}

class _InfographicsViewState extends State<InfographicsView> {
  late final Controller provider;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();

    provider = context.read<Controller>();

    if (provider.infographic == null) {
      provider.isArabic()
          ? provider.getInfographicArNews()
          : provider.getInfographicEnNews();
    } else {
      if (provider.infographic!.isEmpty) {
        provider.isArabic()
            ? provider.getInfographicArNews()
            : provider.getInfographicEnNews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        analytics.setCurrentScreen(screenName: 'Infographics');

    final Size screenSize = MediaQuery.of(context).size;
    final bool isPortrait = screenSize.height > screenSize.width;
    final TextStyle textStyle = getMediumStyle(color: ColorManager.black);
    return Consumer<Controller>(builder: (context, provider, child) {
      
      if (!provider.isConnected) {
        return NoConnectionState(StateRendererType.fullScreenNoConnectionState,
                AppStrings.noInternetConnection.tr())
            .getScreenWidget(context);
      }

      if (provider.infographic == null) {
        return ErrorState(
            stateRendererType: StateRendererType.fullScreenErorr,
            retryActionFunction: () {
              provider.infographic = [];
              provider.notifyListeners();
              provider.isArabic()
                  ? provider.getInfographicArNews()
                  : provider.getInfographicEnNews();
            }).getScreenWidget(context);
      }

      if (provider.infographic!.isEmpty) {
        return LoadingState(
                stateRendererType: StateRendererType.fullScreenLoadingState)
            .getScreenWidget(context);
      }

      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
          child: GridView.builder(
            addAutomaticKeepAlives: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isPortrait ? 1 : 2,
              crossAxisSpacing: AppSize.s12,
              mainAxisExtent:
                  screenSize.height / 2 + AppSize.s8 + textStyle.fontSize!,
            ),
            itemCount: provider.infographic!.length,
            padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
            itemBuilder: (context, index) {
              return InfographicsWidget(
                infographics: provider.infographic![index],
              );
            },
          ),
        ),
      );
    });
  }
}
