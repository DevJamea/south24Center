import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/breaking_news/twitter_item.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/state_renderer.dart';
import '../common/state_renderer_impl.dart';


class BreakingNewsView extends StatefulWidget {
  const BreakingNewsView({Key? key}) : super(key: key);

  @override
  State<BreakingNewsView> createState() => _BreakingNewsViewState();
}

class _BreakingNewsViewState extends State<BreakingNewsView> {
  final twitterAr = "https://twitter.com/South24_net/status";
  final twitterEn = "https://twitter.com/South24E/status";
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<Controller>(context, listen: false);
     if (!provider.isArabic()) {
          provider.twitter.isEmpty ? provider.getTwitterEnNews() : null;
        } else {
          provider.twitter.isEmpty ? provider.getTwitterArNews() : null;
        }
  }

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: 'Twitter');

    return Consumer<Controller>(
      builder: (context, provider, child) {
       
        return Scaffold(
          body: provider.isConnected
              ? _buildTwitterList(provider)
              : NoConnectionState(
                  StateRendererType.fullScreenNoConnectionState,
                  AppStrings.noInternetConnection.tr(),
                ).getScreenWidget(context),
        );
      },
    );
  }

  Widget _buildTwitterList(Controller provider) {
    return provider.twitter.isEmpty
        ? LoadingState(
            stateRendererType: StateRendererType.fullScreenLoadingState,
          ).getScreenWidget(context)
        : ListView.builder(
            itemCount: provider.twitter.length,
            addAutomaticKeepAlives: false,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  provider.isArabic()
                      ? launchUrl(
                          Uri.parse("$twitterAr/${provider.twitter[index].twtId}"),
                          mode: LaunchMode.externalApplication)
                      : launchUrl(
                          Uri.parse("$twitterEn/${provider.twitter[index].twtId}"),
                          mode: LaunchMode.externalApplication);
                },
                child: TwitterItem(
                  twitterModel: provider.twitter[index],
                ),
              );
            },
          );
  }
}
