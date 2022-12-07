import 'package:complete_advanced_flutter_arabic/app/constants.dart';
import 'package:complete_advanced_flutter_arabic/presentation/common/state_renderer/state_renderer.dart';
import 'package:complete_advanced_flutter_arabic/presentation/resources/strings_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}

class LodaingState extends FlowState {
  StateRendererType stateRendererType;
  String? message;
  LodaingState(
      {required this.stateRendererType, this.message = AppStrings.loading});
  @override
  String getMessage() => message ?? AppStrings.loading;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

class SuccessState extends FlowState {
  String message;
  SuccessState(this.message, );
  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => StateRendererType.popupSuccessState;
}

class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;
  ErrorState( {required this.stateRendererType, required this.message});
  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

class EmptyState extends FlowState {
  String message;
  EmptyState({required this.message});

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.fullScreenEmptyState;
}

class contentState extends FlowState {
  @override
  String getMessage() => Constants.empty;

  @override
  StateRendererType getStateRendererType() => StateRendererType.contentState;
}

// is there dialog open
_isCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

dissMissDialog(BuildContext context) {
  if (_isCurrentDialogShowing(context)) {
    Navigator.of(context, rootNavigator: true).pop(true);
  }
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreen,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LodaingState:
        {
          if (getStateRendererType() == StateRendererType.popupLoadingState) {
            showPopUp(context, getStateRendererType(), getMessage());
            return contentScreen;
          } else {
            return StateRenderer(
              stateRendererType: getStateRendererType(),
              retryActionFunction: retryActionFunction,
              message: getMessage(),
            );
          }
        }
      case SuccessState:
        {
          dissMissDialog(context);
          showPopUp(context, StateRendererType.popupSuccessState, title: AppStrings.Success,getMessage());
          return contentScreen;
        }
      case ErrorState:
        {
          dissMissDialog(context);
          if (getStateRendererType() == StateRendererType.popupErrorState) {
            showPopUp(context, getStateRendererType(), getMessage());
            return contentScreen;
          } else {
            return StateRenderer(
              stateRendererType: getStateRendererType(),
              retryActionFunction: retryActionFunction,
              message: getMessage(),
            );
          }
        }
      case contentState:
        {
          dissMissDialog(context);

          return contentScreen;
        }
      case EmptyState:
        {
          return StateRenderer(
              stateRendererType: getStateRendererType(),
              retryActionFunction: () {},
              message: getMessage());
        }
      default:
        {
          dissMissDialog(context);
          return contentScreen;
        }
    }
  }

  showPopUp(BuildContext context, StateRendererType stateRendererType,
      String message,{String title=Constants.empty}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
              stateRendererType: stateRendererType,
              retryActionFunction: () {},
              title: title,
              message: message,
            )));
  }
}
