import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:south24/app/constants.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();

  String getMessage();
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
}

class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
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
}

class SuccessState extends FlowState {
  String message;

  SuccessState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => StateRendererType.popupSuccess;
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
      case ErrorState:
        {
          return StateRenderer(
            message: getMessage(),
            stateRendererType: getStateRendererType(),
          );
        }

      default:
        {
          return Container();
        }
    }
  }

  _isCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  dismissDialog(BuildContext context) {
    if (_isCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopup(
      BuildContext context, StateRendererType stateRendererType, String message,
      {String title = Constants.empty}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
            stateRendererType: stateRendererType,
            message: message,
            title: title,
            retryActionFunction: () {})));
  }
}
