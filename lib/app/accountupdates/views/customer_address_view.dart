import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:moniepoint_flutter/app/accountupdates/model/data/address_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/customer_address_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/radio_button.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

import 'account_update_form_view.dart';

class CustomerAddressScreen extends PagedForm {

  @override
  State<StatefulWidget> createState() {
    return _CustomerAddressScreen();
  }

  @override
  String getTitle() {
    return "Customer Address";
  }
}

class _CustomerAddressScreen extends State<CustomerAddressScreen> with AutomaticKeepAliveClientMixin {
  late CustomerAddressForm _customerAddressForm;

  TextEditingController? _addressController;
  TextEditingController? _cityController;

  TextEditingController? _mailingAddressController;
  TextEditingController? _mailingCityController;

  bool displayMailingAddress = false;

  void saveForm() {
    final info = _customerAddressForm.getAddressInfo;
    final mailingAddress = _customerAddressForm.getMailingAddressInfo;
    PreferenceUtil.saveDataForLoggedInUser("account-update-address-info", info);
    PreferenceUtil.saveDataForLoggedInUser("account-update-mailing-address-info", mailingAddress);
    PreferenceUtil.saveValueForLoggedInUser<bool>("account-update-address-info-mailing-default", _customerAddressForm.useAddressAsMailingAddress);
  }

  void onRestoreForm() {
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);

    final savedInfo = PreferenceUtil.getDataForLoggedInUser("account-update-address-info");
    final mailingAddress = PreferenceUtil.getDataForLoggedInUser("account-update-mailing-address-info");
    final mailingAddressDefault = PreferenceUtil.getValueForLoggedInUser<bool>("account-update-address-info-mailing-default");

    final info = AddressInfo.fromJson(savedInfo);

    if(info.addressLine != null || info.addressLine?.isNotEmpty == true) {
      _addressController?.text = info.addressLine ?? "";
      _customerAddressForm.onAddressChange(_addressController?.text);
    }

    if(info.addressCity != null || info.addressCity?.isNotEmpty == true) {
      _cityController?.text = info.addressCity ?? "";
      _customerAddressForm.onCityChange(_cityController?.text);
    }

    if(info.addressLocalGovernmentAreaId != null && info.addressLocalGovernmentAreaId != 0) {
      final nationality = viewModel.nationalities.first;

      final state = StateOfOrigin.fromLocalGovtId(
          info.addressLocalGovernmentAreaId, nationality.states ?? []
      );
      _customerAddressForm.onStateChange(state);

      _customerAddressForm.onLocalGovtChange(
          LocalGovernmentArea.fromId(info.addressLocalGovernmentAreaId,
              state?.localGovernmentAreas ?? [])
      );
    }

    if(mailingAddressDefault == false) {
      setState(() {
        displayMailingAddress = true;
        _customerAddressForm.setDefaultAsMailingAddress(false);
        _setMailingAddressValues(AddressInfo.fromJson(mailingAddress));
      });
    }
  }

  void _setMailingAddressValues(AddressInfo info, {bool triggerUpstream = true}) {
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);

    //Give a little time for the ui to rebuild
    Future.delayed(Duration(milliseconds: 80), (){
      if(info.addressLine != null || info.addressLine?.isNotEmpty == true) {
        _mailingAddressController?.text = info.addressLine ?? "";
        if(triggerUpstream) {
          _customerAddressForm.mailingAddressForm?.onAddressChange(
              _mailingAddressController?.text);
        }
      }

      if(info.addressCity != null || info.addressCity?.isNotEmpty == true) {
        _mailingCityController?.text = info.addressCity ?? "";
        if(triggerUpstream) {
          _customerAddressForm.mailingAddressForm?.onCityChange(
              _mailingCityController?.text);
        }
      }

      if(info.addressLocalGovernmentAreaId != null && triggerUpstream) {
        final nationality = viewModel.nationalities.first;

        final state = StateOfOrigin.fromLocalGovtId(
            info.addressLocalGovernmentAreaId, nationality.states ?? []);
        _customerAddressForm.mailingAddressForm?.onStateChange(state);
        _customerAddressForm.mailingAddressForm?.onLocalGovtChange(
            LocalGovernmentArea.fromId(info.addressLocalGovernmentAreaId,
                state?.localGovernmentAreas ?? [])
        );
      }
    });
  }

  Widget yesOrNoView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
            flex: 1,
            child: Text(
              'Use this address as mailing address ?',
              style: TextStyle(color: Colors.textColorBlack, fontSize: 14),
            )),
        SizedBox(width: 4),
        Expanded(
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      flex: 1,
                      child: RadioButton(
                          title: Text('YES', style: TextStyle(color: Colors.textColorBlack, fontWeight: FontWeight.bold)),
                          groupValue: (_customerAddressForm.useAddressAsMailingAddress)
                              ? "YES"
                              : "NO",
                          value: "YES",
                          onChange: (a) {
                            _customerAddressForm.setDefaultAsMailingAddress(true);
                            setState(() {
                              displayMailingAddress = false;
                            });
                          })),
                  SizedBox(width: 12),
                  Flexible(
                      child: RadioButton(
                          title: Text('NO', style: TextStyle(color: Colors.textColorBlack, fontWeight: FontWeight.bold)),
                          groupValue: (_customerAddressForm.useAddressAsMailingAddress)
                              ? "YES"
                              : "NO",
                          value: "NO",
                          onChange: (a) {
                            _customerAddressForm.setDefaultAsMailingAddress(false);
                            setState(() {
                              displayMailingAddress = true;
                            });
                            _setMailingAddressValues(_customerAddressForm.getMailingAddressInfo!, triggerUpstream: false);
                          }))
                ]))
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _mailingAddressController = TextEditingController();
    _mailingCityController = TextEditingController();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 200),() {
        onRestoreForm();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    this._customerAddressForm = viewModel.addressForm
      ..setStates(viewModel.nationalities.first.states ?? []); //TODO remove from here

    return ScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
                stream: _customerAddressForm.addressStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _addressController,
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _customerAddressForm.onAddressChange,
                      hint: 'House Address',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 16),
            StreamBuilder(
                stream: _customerAddressForm.cityStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _cityController,
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _customerAddressForm.onCityChange,
                      hint: 'City Town',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 16),
            StreamBuilder(
                stream: _customerAddressForm.stateStream,
                builder: (BuildContext context, AsyncSnapshot<StateOfOrigin?> snapshot) {
                  return Styles.buildDropDown(_customerAddressForm.states, snapshot, (value, i) {
                    _customerAddressForm.onStateChange(value as StateOfOrigin);
                  }, hint: 'State of Origin');
                }),
            SizedBox(height: 16,),
            StreamBuilder(
                stream: _customerAddressForm.localGovtStream,
                builder: (BuildContext context, AsyncSnapshot<LocalGovernmentArea?> snapshot) {
                  return Styles.buildDropDown(_customerAddressForm.localGovt, snapshot, (value, i) {
                    _customerAddressForm.onLocalGovtChange(value as LocalGovernmentArea);
                  }, hint: 'Local Govt. Area Origin');
                }),
            SizedBox(height: 16),
            Expanded(
                flex: 0,
                child: yesOrNoView()
            ),
            SizedBox(height: 16),
            Visibility(
                visible: displayMailingAddress,
                child: StreamBuilder(
                  stream: _customerAddressForm.mailingAddressForm?.addressStream,
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    return Styles.appEditText(
                        controller: _mailingAddressController,
                        errorText: snapshot.hasError ? snapshot.error.toString() : null,
                        onChanged: _customerAddressForm.mailingAddressForm?.onAddressChange,
                        hint: 'House Address',
                        animateHint: false,
                        fontSize: 15);
                  })),
            SizedBox(height: 16),
            Visibility(
                visible: displayMailingAddress,
                child: StreamBuilder(
                    stream: _customerAddressForm.mailingAddressForm?.cityStream,
                    builder: (context, AsyncSnapshot<String?> snapshot) {
                      return Styles.appEditText(
                          controller: _mailingCityController,
                          errorText: snapshot.hasError ? snapshot.error.toString() : null,
                          onChanged:  _customerAddressForm.mailingAddressForm?.onCityChange,
                          hint: 'City Town',
                          animateHint: false,
                          fontSize: 15);
                    })),
            SizedBox(height: 16),
            Visibility(
                visible: displayMailingAddress,
                child: StreamBuilder(
                  stream: _customerAddressForm.mailingAddressForm?.stateStream,
                  builder: (BuildContext context, AsyncSnapshot<StateOfOrigin?> snapshot) {
                    return Styles.buildDropDown(_customerAddressForm.states, snapshot, (value, i) {
                      _customerAddressForm.mailingAddressForm?.onStateChange(value as StateOfOrigin);
                    }, hint: 'State of Origin');
                  })),
            SizedBox(
              height: 16,
            ),
            Visibility(
                visible: displayMailingAddress,
                child: StreamBuilder(
                  stream: _customerAddressForm.mailingAddressForm?.localGovtStream,
                  builder: (BuildContext context, AsyncSnapshot<LocalGovernmentArea?> snapshot) {
                    return Styles.buildDropDown(_customerAddressForm.mailingAddressForm?.localGovt??<LocalGovernmentArea>[], snapshot, (value, i) {
                     _customerAddressForm.mailingAddressForm?.onLocalGovtChange(value as LocalGovernmentArea);
                    }, hint: 'Local Govt. Area');
                  })),
            SizedBox(height: 32),
            Expanded(
                child: Row(
                  children: [
                    (widget.isLast()) ? SizedBox() : Flexible(child: Container()),
                    Flexible(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Styles.statefulButton(
                              stream: _customerAddressForm.isValid,
                              onClick: () {
                                saveForm();
                                viewModel.moveToNext(widget.position);
                              },
                              text: widget.isLast() ? 'Proceed' : 'Next',
                              isLoading: false
                          ),
                        ))
                  ],
                )),
            // SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
