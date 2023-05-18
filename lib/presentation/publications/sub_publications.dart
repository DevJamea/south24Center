import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/publications/publications_widget.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class SubPublicationsView extends StatefulWidget {
  const SubPublicationsView({Key? key}) : super(key: key);

  @override
  _SubPublicationsViewState createState() => _SubPublicationsViewState();
}

class _SubPublicationsViewState extends State<SubPublicationsView> {
  late final Controller provider;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();

    provider = context.read<Controller>();

    if (provider.isArabic()) {
      if (provider.arabicVersions == null) {
        provider.getArarbicNews();
      } else {
        if (provider.arabicVersions!.isEmpty) {
          provider.getArarbicNews();
        }
      }
    } else {
      if (provider.publications == null) {
        provider.getPublicationsNews();
      } else {
        if (provider.publications!.isEmpty) {
          provider.getPublicationsNews();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        analytics.setCurrentScreen(screenName: 'Publications');

    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;
    final textStyle = getMediumStyle(color: ColorManager.black);

    return Consumer<Controller>(
      builder: (context, provider, child) {
        if (!provider.isConnected) {
          return NoConnectionState(
                  StateRendererType.fullScreenNoConnectionState,
                  AppStrings.noInternetConnection.tr())
              .getScreenWidget(context);
        }

        if (provider.isArabic()) {
          if (provider.arabicVersions == null) {
            return ErrorState(
                stateRendererType: StateRendererType.fullScreenErorr,
                retryActionFunction: () {
                  provider.arabicVersions = [];
                  provider.notifyListeners();
                  provider.getArabicVersionsNews();
                }).getScreenWidget(context);
          }

          if (provider.arabicVersions!.isEmpty) {
            return LoadingState(
                    stateRendererType: StateRendererType.fullScreenLoadingState)
                .getScreenWidget(context);
          }
        } else {
          if (provider.publications == null) {
            return ErrorState(
                stateRendererType: StateRendererType.fullScreenErorr,
                retryActionFunction: () {
                  provider.publications = [];
                  provider.notifyListeners();
                  provider.getPublicationsNews();
                }).getScreenWidget(context);
          }

          if (provider.publications!.isEmpty) {
            return LoadingState(
                    stateRendererType: StateRendererType.fullScreenLoadingState)
                .getScreenWidget(context);
          }
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
                    size.height / 2 + AppSize.s8 + textStyle.fontSize!,
              ),
              itemCount: provider.isArabic()
                  ? provider.arabicVersions!.length
                  : provider.publications!.length,
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
              itemBuilder: (context, index) {
                return PublicationsWidget(
                  versions: provider.isArabic()
                      ? provider.arabicVersions![index]
                      : provider.publications![index],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
