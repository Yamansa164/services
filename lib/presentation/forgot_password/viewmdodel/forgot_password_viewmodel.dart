import 'dart:async';
import 'dart:io';

import 'package:complete_advanced_flutter_arabic/app/function.dart';
import 'package:complete_advanced_flutter_arabic/domain/usecase/forgetPassword_useCase.dart';
import 'package:complete_advanced_flutter_arabic/presentation/base/baseviewmodel.dart';

import '../../common/state_renderer/state_renderer.dart';
import '../../common/state_renderer/state_rendrere_impl.dart';

class ForgetPasswordViewModel extends BaseViewModel
    with ForgetPasswordViewModelInput, ForgetPasswordViewModelOutput {
  final StreamController _emailController =
      StreamController<String>.broadcast();
  final StreamController isemailtrue = StreamController<bool>();
  final ForgetPasswordUseCase forgetPasswordUseCase;
  ForgetPasswordViewModel(this.forgetPasswordUseCase);
  String email = '';

  @override
  void start() {
    inputstate.add(contentState());
  }

  void dispose() {
    super.dispose();
    _emailController.close();
  }
  ///// input

  @override
  Sink get inputEmail => _emailController.sink;

  @override
  void forgetPassword() async {
    inputstate.add(
        LodaingState(stateRendererType: StateRendererType.popupLoadingState));
    (await forgetPasswordUseCase.execute(email)).fold(
        (Faliure) => inputstate.add(ErrorState(
            stateRendererType: StateRendererType.popupErrorState,
            message: Faliure.message)), (supportMessage) {
      inputstate.add(
          SuccessState(supportMessage, ));
      isemailtrue.add(true);
    });
  }

  ////// output
  @override
  Stream<bool> get outputIsEmailValid =>
      _emailController.stream.map((emai) => isEmailValid(emai));

 

  @override
  void setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
  }
}

abstract class ForgetPasswordViewModelInput {
  void setEmail(String email);
  void forgetPassword();
  Sink get inputEmail;
}

abstract class ForgetPasswordViewModelOutput {
  Stream get outputIsEmailValid;
}
