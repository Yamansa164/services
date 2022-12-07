import 'package:complete_advanced_flutter_arabic/presentation/common/state_renderer/state_rendrere_impl.dart';
import 'package:complete_advanced_flutter_arabic/presentation/store_details/viewmodel/store_detail_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app/di.dart';
import '../../../domain/model/models.dart';
import '../../resources/color_manager.dart';
import '../../resources/values_manager.dart';

class StoreDetailsView extends StatefulWidget {
  const StoreDetailsView({Key? key}) : super(key: key);

  @override
  _StoreDetailsViewState createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  final StoreDetailsViewModel _viewModel = instance<StoreDetailsViewModel>();

  _bind() {
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outpotstate,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _viewModel.start();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return StreamBuilder<StoreDetails>(
        stream: _viewModel.outputStoreDetailsViewObject,
        builder: (context, snapshot) {
        
          StoreDetails? storeDetailsViewObject = snapshot.data;
            print(storeDetailsViewObject);
          if (storeDetailsViewObject == null) {
            return Container(color: Colors.amber,);
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    storeDetailsViewObject.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                  ),
                ),
                _getSection('details'),
                _getInfoText(storeDetailsViewObject.details),
                _getSection('services'),
                _getInfoText(storeDetailsViewObject.services),
                _getSection('about'),
                _getInfoText(storeDetailsViewObject.about),
              ],
            );
          }
        });
  }

  Widget _getSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(
          top: AppPadding.p12,
          left: AppPadding.p12,
          right: AppPadding.p12,
          bottom: AppPadding.p2),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: ColorManager.primary),
      ),
    );
  }

  Widget _getInfoText(String text) {
    return Padding(
      padding: EdgeInsets.all(AppSize.s12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
