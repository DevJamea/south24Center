import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
  Function? getRetryActionFunction();
}



class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String? message;

  LoadingState(
      {required this.stateRendererType, String message = AppStrings.loading});

  @override
  String getMessage() => message ?? AppStrings.loading.tr();

  @override
  StateRendererType getStateRendererType() => stateRendererType;
  
  @override
  Function? getRetryActionFunction() {
    return null;
  }
}



class NoConnectionState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  NoConnectionState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;

  @override
  Function? getRetryActionFunction() {
    return null;
  }
}



class NoDataState extends FlowState {
  StateRendererType stateRendererType;
  String? message;

  NoDataState(
      {required this.stateRendererType, String message = AppStrings.noData});

  @override
  String getMessage() => message ?? AppStrings.noData.tr();

  @override
  StateRendererType getStateRendererType() => stateRendererType;

  @override
  Function? getRetryActionFunction() {
    return null;
  }
}

class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String? message;
  Function retryActionFunction;

  ErrorState(
      {required this.stateRendererType, 
      required this.retryActionFunction,
      String message = AppStrings.loading});

  @override
  String getMessage() => message ?? AppStrings.somtingWrong.tr();

  @override
  StateRendererType getStateRendererType() => stateRendererType;

  @override
  Function? getRetryActionFunction() {
    return retryActionFunction;
  }

}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context) {
    switch (runtimeType) {
      case LoadingState:
        {
          return StateRenderer(
            message: getMessage(),
            stateRendererType: getStateRendererType(),
          );
        }
      case NoDataState:
        {
          return StateRenderer(
            message: getMessage(),
            stateRendererType: getStateRendererType(),
          );
        }
      case NoConnectionState:
        {
          return StateRenderer(
            message: getMessage(),
            stateRendererType: getStateRendererType(),
          );
        }

          case ErrorState:
        {
          return StateRenderer(
            message: getMessage(),
            stateRendererType: getStateRendererType(),
            retryActionFunction: getRetryActionFunction(),
          );
        }

      default:
        {
          return Container();
        }
    }
  }


}
