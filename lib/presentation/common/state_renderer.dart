import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

enum StateRendererType {
  fullScreenLoadingState,
  fullScreenNoConnectionState,
  fullScreenNoDataState,
  fullScreenErorr
}

class StateRenderer extends StatelessWidget {
  StateRendererType stateRendererType;
  String message;
  String title;
  Function? retryActionFunction;

  StateRenderer(
      {required this.stateRendererType,
      this.message = AppStrings.loading,
      this.title = "",
      this.retryActionFunction});

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      
      case StateRendererType.fullScreenLoadingState:
        return _getItemsColumn(
            [_getAnimatedImage(JsonAssets.loading), _getMessage(message)]);

      case StateRendererType.fullScreenNoConnectionState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.noIternet),
          _getMessage(message),
        ]);

      case StateRendererType.fullScreenNoDataState:
        return _getItemsColumn(
            [_getAnimatedImage(JsonAssets.noData), _getMessage(message)]);

      case StateRendererType.fullScreenErorr:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.erorr),
          _getMessage(message),
          _getRetryButton(context)
        ]);
      default:
        return Container();
    }
  }

  Widget _getItemsColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animationName) {
    return SizedBox(
        height: AppSize.s100,
        width: AppSize.s100,
        child: Lottie.asset(animationName));
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Text(
          message,
          style: getRegularStyle(
              color: ColorManager.black, fontSize: FontSizeManager.s18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _getRetryButton(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  retryActionFunction!.call();
                },
                child: Text(AppStrings.retry.tr()))),
      ),
    );
  }
}
