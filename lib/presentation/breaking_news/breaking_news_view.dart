import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/breaking_news/twitter_item.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/state_renderer_impl.dart';

class BreakingNewsView extends StatefulWidget {
  const BreakingNewsView({super.key});

  @override
  State<BreakingNewsView> createState() => _BreakingNewsViewState();
}

class _BreakingNewsViewState extends State<BreakingNewsView> {
  final twitterAr = "https://twitter.com/South24_net/status";
  final twitterEn = "https://twitter.com/South24E/status";

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(builder: (context, provider, child) {
      if (!provider.isArabic()) {
        provider.twitter.isEmpty ? provider.getTwitterEnNews() : null;
      } else {
        provider.twitter.isEmpty ? provider.getTwitterArNews() : null;
      }
      return Scaffold(
          body: !provider.isConnected
              ? ErrorState(StateRendererType.fullScreenErrorState,
                      AppStrings.noInternetConnection.tr())
                  .getScreenWidget(context)
              : provider.twitter.isEmpty
                  ? LoadingState(
                          stateRendererType:
                              StateRendererType.fullScreenLoadingState)
                      .getScreenWidget(context)
                  : ListView.builder(
                      itemCount: provider.twitter.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () {
                              provider.isArabic()
                                  ? launchUrl(
                                      Uri.parse(
                                          "$twitterAr/${provider.twitter[index].twtId}"),
                                      mode: LaunchMode.externalApplication)
                                  : launchUrl(
                                      Uri.parse(
                                          "$twitterEn/${provider.twitter[index].twtId}"),
                                      mode: LaunchMode.externalApplication);
                            },
                            child: TwitterItem(
                              twitterModel: provider.twitter[index],
                            ));
                      },
                    ));
    });
  }
}

