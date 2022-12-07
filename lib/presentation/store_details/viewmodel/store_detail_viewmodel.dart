import 'dart:async';
import 'dart:ffi';
import 'dart:io' as io;

import 'package:complete_advanced_flutter_arabic/domain/model/models.dart';
import 'package:complete_advanced_flutter_arabic/domain/usecase/get_storeDetails_usecase.dart';
import 'package:complete_advanced_flutter_arabic/presentation/base/baseviewmodel.dart';
import 'package:complete_advanced_flutter_arabic/presentation/common/state_renderer/state_renderer.dart';
import 'package:complete_advanced_flutter_arabic/presentation/common/state_renderer/state_rendrere_impl.dart';
import 'package:complete_advanced_flutter_arabic/presentation/resources/strings_manager.dart';
import 'package:rxdart/rxdart.dart';

class StoreDetailsViewModel extends BaseViewModel
    with StoreDetailsViewModelInput, StoreDetailsViewModelOutput {
  StoreDetailsUseCase _storeDetailsUseCase;
  StoreDetailsViewModel(this._storeDetailsUseCase);
  final StreamController _storeDetailsViewObjectController =
      BehaviorSubject<StoreDetails>();
  @override
  void start() {
    _getStoreDetailsData();
  }

  _getStoreDetailsData() async {
    inputstate.add(LodaingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    (await _storeDetailsUseCase.execute(Void)).fold((faliure) {
      inputstate.add(ErrorState(
          stateRendererType: StateRendererType.fullScreenErrorState,
          message: faliure.message));
    }, (storeDetails) {
      inputstate.add(contentState());
      inputStoreDetailsViewObject.add(StoreDetails(
        details: storeDetails.details,
        image: storeDetails.image,
        services: storeDetails.services,
        about: storeDetails.about,
        id: storeDetails.id,
        title: storeDetails.title,
      ));
    });
  }

  @override
  void dispose() {
    _storeDetailsViewObjectController.close();
    super.dispose();
  }

  @override
  Sink get inputStoreDetailsViewObject =>
      _storeDetailsViewObjectController.sink;

  @override
  // TODO: implement outputStoreDetailsViewObject
  Stream<StoreDetails> get outputStoreDetailsViewObject =>
      _storeDetailsViewObjectController.stream
          .map((storeDetailsView) => storeDetailsView);
}

abstract class StoreDetailsViewModelInput {
  Sink get inputStoreDetailsViewObject;
} 

abstract class StoreDetailsViewModelOutput {
  Stream<StoreDetails> get outputStoreDetailsViewObject;
}
