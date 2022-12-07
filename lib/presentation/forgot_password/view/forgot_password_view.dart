import 'package:complete_advanced_flutter_arabic/app/di.dart';
import 'package:complete_advanced_flutter_arabic/presentation/common/state_renderer/state_rendrere_impl.dart';
import 'package:complete_advanced_flutter_arabic/presentation/forgot_password/viewmdodel/forgot_password_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../resources/assets_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}
class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController=TextEditingController();
    final _formKey = GlobalKey<FormState>();
 final _viewModel=instance<ForgetPasswordViewModel>();
 bind(){
  _viewModel.start();
  _emailController.addListener(() {_viewModel.setEmail(_emailController.text); });
  _viewModel.isemailtrue.stream.map((isEmailTrue) {
    if(isEmailTrue)  {
         SchedulerBinding.instance.addPostFrameCallback((_) { 
       print('hello');
         });
          }
  });
 }
 @override
  void initState() {
    bind();
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outpotstate,
        builder: ((context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),(){})?? _getContentWidget();
        } ),
    ));
  }
  Widget _getContentWidget(){
return 
       Container(
        padding: const EdgeInsets.only(top: AppPadding.p100),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Center(
                    child: Image(image: AssetImage(ImageAssets.splashLogo))),
                const SizedBox(
                  height: AppSize.s28,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                      stream: _viewModel.outputIsEmailValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                              hintText: AppStrings.username,
                              labelText: AppStrings.username,
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.errorEmail),
                        );
                      }),
                ),
               
                const SizedBox(
                  height: AppSize.s28,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                      stream: _viewModel.outputIsEmailValid,
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: double.infinity,
                          height: AppSize.s40,
                          child: ElevatedButton(
                              onPressed: (snapshot.data ?? false)
                                  ? () {
                                      _viewModel.forgetPassword();
                                    }
                                  : null,
                              child: const Text(AppStrings.resetPassword)),
                        );
                      }),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        top: AppPadding.p8,
                        left: AppPadding.p28,
                        right: AppPadding.p28),
                    child: Text('data'),
              
            ),]
          ),
        ),
      ));
  }
  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
