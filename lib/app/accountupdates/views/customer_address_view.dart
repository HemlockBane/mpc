import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/customer_address_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/custom_check_box.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

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
  late final AccountUpdateViewModel _viewModel;
  late CustomerAddressForm _customerAddressForm;

  final mailingFormKey = Key("mailing-form");

  TextEditingController? _addressController;
  TextEditingController? _cityController;

  TextEditingController? _mailingAddressController;
  TextEditingController? _mailingCityController;

  @override
  void initState() {
    _viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    _customerAddressForm = _viewModel.addressForm..setStates(_viewModel.nationalities.first.states ?? []);
    _customerAddressForm.mailingAddressForm?..setStates(_viewModel.nationalities.first.states ?? []);

    super.initState();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _mailingAddressController = TextEditingController();
    _mailingCityController = TextEditingController();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration.zero, (){
        _customerAddressForm.restoreFormState();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.getTitle(),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.textColorBlack,
                    fontSize: 21
                )
            ),
            SizedBox(height: 22,),
            StreamBuilder(
                stream: _customerAddressForm.addressStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _addressController?.withDefaultValueFromStream(
                          snapshot, _customerAddressForm.getAddressInfo.addressLine
                      ),
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _customerAddressForm.onAddressChange,
                      hint: 'House Address',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 20),
            StreamBuilder(
                stream: _customerAddressForm.cityStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _cityController?.withDefaultValueFromStream(
                          snapshot, _customerAddressForm.getAddressInfo.addressCity
                      ),
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _customerAddressForm.onCityChange,
                      hint: 'City Town',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 20),
            StreamBuilder(
                stream: _customerAddressForm.stateStream,
                builder: (BuildContext context, AsyncSnapshot<StateOfOrigin?> snapshot) {
                  return Styles.buildDropDown(_customerAddressForm.states, snapshot, (value, i) {
                    _customerAddressForm.onStateChange(value as StateOfOrigin);
                  }, hint: 'State of Origin');
                }),
            SizedBox(height: 20,),
            StreamBuilder(
                stream: _customerAddressForm.localGovtStream,
                builder: (BuildContext context, AsyncSnapshot<LocalGovernmentArea?> snapshot) {
                  return Styles.buildDropDown(_customerAddressForm.localGovt, snapshot, (value, i) {
                    _customerAddressForm.onLocalGovtChange(value as LocalGovernmentArea);
                  }, hint: 'Local Govt. Area');
                }),
            SizedBox(height: 16),
            Expanded(
                flex: 0,
                child: StreamBuilder(
                  stream: _customerAddressForm.useAsMailingAddressStream,
                  builder: (ctx, AsyncSnapshot<bool?> snapshot) {
                    return Row(
                      children: [
                        CustomCheckBox(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(5),
                            onSelect: (v) {
                              print("Sending Value of $v");
                              _customerAddressForm.setDefaultAsMailingAddress(v);
                            },
                            isSelected: snapshot.hasData && snapshot.data == true
                        ),
                        SizedBox(width: 4,),
                        Text(
                            "Use this address as mailing address",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.textColorBlack
                            ),
                        )
                      ],
                    );
                  },
                )
            ),
            SizedBox(height: 16),
            StreamBuilder(
                stream: _customerAddressForm.useAsMailingAddressStream,
                builder: (ctx, AsyncSnapshot<bool?> snapshot) {
                  return Visibility(
                      key: mailingFormKey,
                      visible: snapshot.hasData && snapshot.data == false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StreamBuilder(
                              stream: _customerAddressForm.mailingAddressForm?.addressStream,
                              builder: (context, AsyncSnapshot<String?> snapshot) {
                                return Styles.appEditText(
                                    controller: _mailingAddressController?.withDefaultValueFromStream(
                                        snapshot, _customerAddressForm.mailingAddressForm?.getAddressInfo.addressCity
                                    ),
                                    errorText: snapshot.hasError ? snapshot.error.toString() : null,
                                    onChanged: _customerAddressForm.mailingAddressForm?.onAddressChange,
                                    hint: 'House Address',
                                    animateHint: false,
                                    fontSize: 15
                                );
                              }),
                          SizedBox(height: 20),
                          StreamBuilder(
                              stream: _customerAddressForm.mailingAddressForm?.cityStream,
                              builder: (context, AsyncSnapshot<String?> snapshot) {
                                return Styles.appEditText(
                                    controller: _mailingCityController?.withDefaultValueFromStream(
                                        snapshot, _customerAddressForm.mailingAddressForm?.getAddressInfo.addressCity
                                    ),
                                    errorText: snapshot.hasError ? snapshot.error.toString() : null,
                                    onChanged:  _customerAddressForm.mailingAddressForm?.onCityChange,
                                    hint: 'City Town',
                                    animateHint: false,
                                    fontSize: 15);
                              }),
                          SizedBox(height: 20),
                          StreamBuilder(
                              stream: _customerAddressForm.mailingAddressForm?.stateStream,
                              builder: (BuildContext context, AsyncSnapshot<StateOfOrigin?> snapshot) {
                                return Styles.buildDropDown(_customerAddressForm.mailingAddressForm?.states??<StateOfOrigin>[], snapshot, (value, i) {
                                  _customerAddressForm.mailingAddressForm?.onStateChange(value as StateOfOrigin);
                                }, hint: 'State of Origin');
                              }),
                          SizedBox(height: 20),
                          StreamBuilder(
                              stream: _customerAddressForm.mailingAddressForm?.localGovtStream,
                              builder: (BuildContext context, AsyncSnapshot<LocalGovernmentArea?> snapshot) {
                                return Styles.buildDropDown(_customerAddressForm.mailingAddressForm?.localGovt ?? <LocalGovernmentArea>[], snapshot, (value, i) {
                                  _customerAddressForm.mailingAddressForm?.onLocalGovtChange(value as LocalGovernmentArea);
                                }, hint: 'Local Govt. Area');
                              }),
                        ],
                      )
                  );
                }
            ),
            SizedBox(height: 32),
            Spacer(),
            Styles.statefulButton(
                stream: _customerAddressForm.isValid,
                onClick: () {
                  _viewModel.moveToNext(widget.position);
                },
                text: widget.isLast() ? 'Submit' : 'Next',
                isLoading: false
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
