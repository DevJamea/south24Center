import 'package:easy_localization/easy_localization.dart';
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

  @override
  void initState() {
    super.initState();
    _playerKey = UniqueKey();
    final provider = Provider.of<Controller>(context, listen: false);
    if (provider.youtube.isEmpty) {
      provider.getYoutubeData();
    }
  }

  @override
  void dispose() {
    final provider = context.read<Controller>();
    provider.youtubePlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = context.watch<Controller>();

    

    if (!provider.isConnected) {
      return ErrorState(
        StateRendererType.fullScreenErrorState,
        AppStrings.noInternetConnection.tr(),
      ).getScreenWidget(context);
    }

    final youtubePlayerController = provider.youtubePlayerController;

    if (youtubePlayerController == null) {
      return LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
      ).getScreenWidget(context);
    }

    return Scaffold(
      body: Column(
        children: [
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              key: _playerKey,
              controller: youtubePlayerController,
            ),
            builder: (_, player) => player,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.youtube.length,
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
              itemBuilder: (context, index) {
                final youtubeModel = provider.youtube[index];
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
                      color: provider.selectedYoutube == youtubeModel.ytVideoId
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
  }
}
