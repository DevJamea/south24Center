import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:south24/presentation/south24_tv/youtube_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class South24TV extends StatefulWidget {
  const South24TV({Key? key}) : super(key: key);

  @override
  State<South24TV> createState() => _South24TVState();
}

class _South24TVState extends State<South24TV> {
  late Key _playerKey;
  late final Controller provider;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();

    _playerKey = UniqueKey();
    provider = context.read<Controller>();

    if (provider.youtube == null) {
      provider.getYoutubeData();
    } else {
      if (provider.youtube!.isEmpty) {
        provider.getYoutubeData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        analytics.setCurrentScreen(screenName: 'South TV');

    final size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, Provider, child) {
      final youtubePlayerController = provider.youtubePlayerController;

      if (!provider.isConnected) {
        return NoConnectionState(StateRendererType.fullScreenNoConnectionState,
                AppStrings.noInternetConnection.tr())
            .getScreenWidget(context);
      }

      if (provider.youtube == null) {
        return ErrorState(
            stateRendererType: StateRendererType.fullScreenErorr,
            retryActionFunction: () {
              provider.youtube = [];
              provider.notifyListeners();
              provider.getYoutubeData();
            }).getScreenWidget(context);
      }

      if (provider.youtubePlayerController == null ||
          provider.youtube!.isEmpty) {
        return LoadingState(
                stateRendererType: StateRendererType.fullScreenLoadingState)
            .getScreenWidget(context);
      }

      return Scaffold(
        body: Column(
          children: [
            YoutubePlayerBuilder(
              player: YoutubePlayer(
                key: _playerKey,
                controller: youtubePlayerController!,
              ),
              builder: (_, player) => player,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: provider.youtube!.length,
                addAutomaticKeepAlives: false,
                padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
                itemBuilder: (context, index) {
                  final youtubeModel = provider.youtube![index];
                  return InkWell(
                    onTap: () {
                      final selectedYoutubeId = youtubeModel.ytVideoId!;
                      if (provider.selectedYoutube != selectedYoutubeId) {
                        provider.getYoutubeVideoPlayer(selectedYoutubeId);
                        setState(() {
                          _playerKey = UniqueKey();
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            provider.selectedYoutube == youtubeModel.ytVideoId
                                ? ColorManager.lightGrey
                                : null,
                        borderRadius: BorderRadius.circular(AppSize.s4),
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: AppMargin.m4,
                        horizontal: AppPadding.p12,
                      ),
                      child:
                          YoutubeWidget(size: size, youtubeModel: youtubeModel),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
