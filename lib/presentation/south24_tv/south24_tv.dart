import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    _playerKey = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      provider.youtube.isEmpty ? provider.getYoutubeData() : null;
      return !provider.isConnected
          ? ErrorState(StateRendererType.fullScreenErrorState,
                  AppStrings.noInternetConnection.tr())
              .getScreenWidget(context)
          : provider.youtubePlayerController == null
              ? LoadingState(
                      stateRendererType:
                          StateRendererType.fullScreenLoadingState)
                  .getScreenWidget(context)
              : OrientationBuilder(
                  builder: (context, orientation) {
                     if (orientation == Orientation.portrait) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        } else {
          SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
        }
                    return Scaffold(
                            body: Column(
                              children: [
                                YoutubePlayerBuilder(
                                    player: YoutubePlayer(
                                        key: _playerKey,
                                        controller:
                                            provider.youtubePlayerController!),
                                    builder: (context, pLayer) {
                                      return pLayer;
                                    }),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: provider.youtube.length,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: AppPadding.p8),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          if (provider.selectedYoutube !=
                                              provider
                                                  .youtube[index].ytVideoId!) {
                                            provider.getYoutubeVideoPlayer(
                                                provider
                                                    .youtube[index].ytVideoId!);
                                            _playerKey = UniqueKey();
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: provider.selectedYoutube ==
                                                      provider.youtube[index]
                                                          .ytVideoId!
                                                  ? ColorManager.lightGrey
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppSize.s4)),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: AppMargin.m4,
                                              horizontal: AppPadding.p12),
                                          child: YoutubeWidget(
                                              size: size,
                                              youtubeModel:
                                                  provider.youtube[index]),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                  },
                );
    });
  }
}
