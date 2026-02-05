import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../resources/assets_manager.dart';

class BreakingNewsView extends StatefulWidget {
  const BreakingNewsView({Key? key}) : super(key: key);

  @override
  State<BreakingNewsView> createState() => _BreakingNewsViewState();
}

class _BreakingNewsViewState extends State<BreakingNewsView> {
  final twitterAr = "https://twitter.com/South24_net";
  final twitterEn = "https://twitter.com/South24E";
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: 'Twitter');

    return Consumer<Controller>(builder: (context, provider, child) {
      return Scaffold(
        body: SafeArea(
            child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(JsonAssets.twitter),
              ElevatedButton(
                  onPressed: () {
                    if (provider.isArabic()) {
                      launchUrl(Uri.parse(twitterAr),
                          mode: LaunchMode.externalApplication);
                    } else {
                      launchUrl(Uri.parse(twitterEn),
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(AppPadding.p4),
                    child: Text(AppStrings.breakingNews).tr()))
            ],
          ),
        )),
      );
    });
  }
}
