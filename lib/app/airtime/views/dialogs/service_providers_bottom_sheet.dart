import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_type.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/service_provider_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:provider/provider.dart';

import '../service_provider_list_item.dart';

class ServiceProviderDialog extends StatefulWidget {

  final PurchaseType purchaseType;
  final AirtimeBeneficiary airtimeBeneficiary;

  ServiceProviderDialog(this.airtimeBeneficiary, this.purchaseType);

  @override
  State<StatefulWidget> createState() => _ServiceProviderDialog();
}

class _ServiceProviderDialog extends State<ServiceProviderDialog> with SingleTickerProviderStateMixin {

  AirtimeServiceProvider? _selectedProvider;
  Stream<Resource<List<AirtimeServiceProvider>>>? serviceProviderStream;
  TextEditingController _beneficiaryNameController = TextEditingController();
  AnimationController? _animationController;
  bool _saveBeneficiary = false;

  final List<AirtimeServiceProvider> _currentList = [];

  _ServiceProviderDialog() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600)
    );
  }

  Widget makeListView(BuildContext context, AsyncSnapshot<Resource<List<AirtimeServiceProvider>?>> a) {
    final viewModel = Provider.of<ServiceProviderViewModel>(context, listen: false);

    return ListViewUtil.makeListViewWithState(
        context: context,
        snapshot: a,
        animationController: _animationController!,
        currentList: _currentList,
        listView: (List<AirtimeServiceProvider>? items) {
          return ListView.separated(
              shrinkWrap: true,
              itemCount: items?.length ?? 0,
              separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Divider(color: Color(0XFFE0E0E0)),
                  ),
              itemBuilder: (context, index) {
                return ServiceProviderListItem(Key(index.toString()), items![index], index, (item, index){
                  setState(() {
                    _selectedProvider?.isSelected = false;
                    _selectedProvider = items[index];
                    _selectedProvider?.isSelected = true;
                  });
                });
              });
        });
  }

  @override
  void initState() {
    final viewModel = Provider.of<ServiceProviderViewModel>(context, listen: false);
    serviceProviderStream = (widget.purchaseType == PurchaseType.DATA)
        ? viewModel.getDataServiceProviders()
        : viewModel.getAirtimeServiceProviders();
    _beneficiaryNameController.text = widget.airtimeBeneficiary.name ?? "";
    super.initState();
  }

  Widget _saveBeneficiaryWidget() {
    return Expanded(
        flex: 0,
        child: Container(
          padding: EdgeInsets.only(top: 0, bottom: 0),
          color: Colors.darkBlue.withOpacity(0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Save beneficiary?',
                style: TextStyle(color: Colors.primaryColor, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              SizedBox(width: 12),
              Switch(
                value: _saveBeneficiary,
                onChanged: (onChanged) => setState(()=> _saveBeneficiary = onChanged) ,
                trackColor: MaterialStateProperty.resolveWith((states) {
                  if(states.contains(MaterialState.selected)) {
                    return Colors.solidOrange.withOpacity(0.5);
                  } else {
                    return Colors.grey.withOpacity(0.5);
                  }
                }),
                thumbColor: MaterialStateProperty.resolveWith((states) {
                  if(states.contains(MaterialState.selected)) {
                    return Colors.solidOrange;
                  } else {
                    return Colors.white.withOpacity(0.5);
                  }
                }),
              )
            ],
          ),
        )
    );
  }
  
  bool _isFormValid() {
    if(_selectedProvider == null || _selectedProvider?.isSelected == false) return false;
    if(_saveBeneficiary && _beneficiaryNameController.text.isEmpty) return false;
    return true;
  }



  @override
  Widget build(BuildContext context) {

    return BottomSheets.makeAppBottomSheet(
        height: (_saveBeneficiary ? 700 : 600) + MediaQuery.of(context).viewInsets.bottom * 0.7,
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_network_provider.svg',
        centerImageColor: Colors.primaryColor,
        centerImageHeight: 30,
        centerImageWidth: 30,
        centerBackgroundHeight: 80,
        centerBackgroundWidth: 80,
        centerBackgroundPadding: 16,
        content: Container(
          child: Column(
            children: [
              SizedBox(height: 24),
              Center(
                child: Text('Select Network Provider',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: Colors.solidDarkBlue)),
              ),
              SizedBox(height: 24),
              Expanded(
                  child: StreamBuilder(
                      stream: serviceProviderStream,
                      builder: (context, AsyncSnapshot<Resource<List<AirtimeServiceProvider>?>> a) {
                        return makeListView(context, a);
                      })
              ),
              SizedBox(height: 16),
              _saveBeneficiaryWidget(),
              SizedBox(height: 22),
              Visibility(
                  visible: _saveBeneficiary,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom * 0.7),
                    child: Styles.appEditText(
                      padding: EdgeInsets.only(top: 24, bottom: 24),
                      fontSize: 13,
                      controller: _beneficiaryNameController,
                      hint: 'Enter Beneficiary Name',
                      onChanged: (v) {
                        setState(() {});
                      },
                      startIcon: Icon(
                        CustomFont.username_icon,
                        color: Colors.colorFaded,
                        size: 28,
                      ),
                    ),
                  )
              ),
              SizedBox(height: _saveBeneficiary ? 32 : 0),
              Expanded(
                  flex: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 16),
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: Styles.appButton(
                                paddingTop: 18,
                                paddingBottom: 18,
                                buttonStyle: Styles.greyButtonStyle,
                                onClick: () => Navigator.of(context).pop(),
                                text: 'Cancel',
                                elevation: 0),
                          )),
                      SizedBox(width: 32),
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: Styles.appButton(
                                paddingTop: 18,
                                paddingBottom: 18,
                                onClick: _isFormValid()
                                    ? () => Navigator.of(context).pop(Triple(_selectedProvider, _saveBeneficiary, _beneficiaryNameController.text))
                                    : null,
                                text: 'Next',
                                elevation: 0
                            ),
                          )),
                      SizedBox(width: 16),
                    ],
                  )),
              SizedBox(height: 43),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _beneficiaryNameController.dispose();
    super.dispose();
  }
}
