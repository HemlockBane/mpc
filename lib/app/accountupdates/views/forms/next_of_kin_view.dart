import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/next_of_kin_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';

import 'account_update_form_view.dart';

class NextOfKinScreen extends PagedForm {

  @override
  State<StatefulWidget> createState() {
    return _NextOfKinScreen();
  }

  @override
  String getTitle() => "Next of Kin";

}

class _NextOfKinScreen extends State<NextOfKinScreen> with AutomaticKeepAliveClientMixin {

  late final AccountUpdateViewModel _viewModel;
  NextOfKinForm? _nextOfKinForm;

  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _middleNameController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _emailAddressController;
  TextEditingController? _dateOfBirthController;

  TextEditingController? _houseAddressController;
  TextEditingController? _cityController;

  void displayDatePicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
        helpText: 'Select Date of Birth',
        context: context,
        initialDate: DateTime(1980, 1, 1).add(Duration(days: 1)),
        firstDate: DateTime(1900, 1, 1).add(Duration(days: 1)),
        lastDate: DateTime.now().subtract(Duration(days: 365 * 2))
    );

    if(selectedDate != null ) {
      _dateOfBirthController?.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      _nextOfKinForm?.onDateOfBirthChange(DateFormat('dd-MM-yyyy').format(selectedDate));
    }
  }

  @override
  void initState() {
    _viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    this._nextOfKinForm = _viewModel.nextOfKinForm
      ..addressForm.setStates(_viewModel.nationalities.first.states ?? []);

    super.initState();
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailAddressController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _houseAddressController = TextEditingController();
    _cityController = TextEditingController();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 200),() {
        this._nextOfKinForm?.restoreFormState();
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
                stream: _nextOfKinForm?.firstNameStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _firstNameController?.withDefaultValueFromStream(
                          snapshot, _nextOfKinForm?.nextOfKinInfo.nextOfKinFirstName
                      ),
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.onFirstNameChange,
                      hint: 'First Name',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 20),
            StreamBuilder(
                stream: _nextOfKinForm?.middleNameStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _middleNameController?.withDefaultValueFromStream(
                          snapshot, _nextOfKinForm?.nextOfKinInfo.nextOfKinMiddleName
                      ),
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.onMiddleNameChange,
                      hint: 'Middle Name',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 20),
            StreamBuilder(
                stream: _nextOfKinForm?.lastNameStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _lastNameController?.withDefaultValueFromStream(
                          snapshot, _nextOfKinForm?.nextOfKinInfo.nextOfKinLastName
                      ),
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.onLastNameChange,
                      hint: 'Last Name',
                      animateHint: false,
                      fontSize: 15
                  );
                }),
            SizedBox(height: 20),
            StreamBuilder(
                stream: _nextOfKinForm?.phoneNumberStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _phoneNumberController?.withDefaultValueFromStream(
                          snapshot, _nextOfKinForm?.nextOfKinInfo.nextOfKinPhoneNumber
                      ),
                      inputFormats: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.onPhoneNumberChange,
                      hint: 'Phone Number',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 20),
            StreamBuilder(
                stream: _nextOfKinForm?.emailStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _emailAddressController?.withDefaultValueFromStream(
                          snapshot, _nextOfKinForm?.nextOfKinInfo.nextOfKinEmail
                      ),
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.onEmailAddressChange,
                      hint: 'Email Address',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: StreamBuilder(
                        stream: _nextOfKinForm?.relationshipStream,
                        builder: (BuildContext context, AsyncSnapshot<Relationship?> snapshot) {
                          return Styles.buildDropDown(relationships, snapshot, (value, i) {
                            _nextOfKinForm?.onRelationshipChange(value as Relationship);
                          }, hint: 'Relationship');
                        })
                ),
                SizedBox(width: 20),
                Expanded(
                    child: StreamBuilder(
                        stream: _nextOfKinForm?.dateOfBirthStream,
                        builder: (context, AsyncSnapshot<String?> snapshot) {
                          return Styles.appEditText(
                              controller: _dateOfBirthController?.withDefaultValueFromStream(
                                snapshot, _nextOfKinForm?.nextOfKinInfo.nextOfKinDOB
                              ),
                              onClick: () => displayDatePicker(context),
                              errorText: snapshot.hasError ? snapshot.error.toString() : null,
                              hint: 'Date of Birth',
                              animateHint: false,
                              readOnly: true,
                              startIcon: Icon(CustomFont.calendar, color: Colors.textFieldIcon.withOpacity(0.4)),
                              fontSize: 15
                          );
                        })
                ),
              ],
            ),
            SizedBox(height: 20),
            StreamBuilder(
                stream: _nextOfKinForm?.addressForm.addressStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _houseAddressController?.withDefaultValueFromStream(
                          snapshot, _nextOfKinForm?.nextOfKinInfo.addressInfo?.addressLine
                      ),
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.addressForm.onAddressChange,
                      hint: 'House Address',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 20),
            StreamBuilder(
                stream: _nextOfKinForm?.addressForm.cityStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _cityController?.withDefaultValueFromStream(
                        snapshot, _nextOfKinForm?.nextOfKinInfo.addressInfo?.addressCity
                      ),
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.addressForm.onCityChange,
                      hint: 'City Town',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 20),
            StreamBuilder(
                stream: _nextOfKinForm?.addressForm.stateStream,
                builder: (BuildContext context, AsyncSnapshot<StateOfOrigin?> snapshot) {
                  final stateOfOrigins = _nextOfKinForm?.addressForm.states ?? <StateOfOrigin>[];
                  return Styles.buildDropDown(stateOfOrigins, snapshot, (value, i) {
                    _nextOfKinForm?.addressForm.onStateChange(value as StateOfOrigin);
                  }, hint: 'State of Origin');
                }),
            SizedBox(height: 20),
            StreamBuilder(
                stream: _nextOfKinForm?.addressForm.localGovtStream,
                builder: (BuildContext context, AsyncSnapshot<LocalGovernmentArea?> snapshot) {
                  final localGovts = _nextOfKinForm?.addressForm.localGovt ?? <LocalGovernmentArea>[];
                  return Styles.buildDropDown(localGovts, snapshot, (value, i) {
                    _nextOfKinForm?.addressForm.onLocalGovtChange(value as LocalGovernmentArea);
                  }, hint: 'Local Govt. Area');
                }),
            SizedBox(height: 32),
            Spacer(),
            StreamBuilder(
                stream: _viewModel.loadingState,
                builder: (ctx, AsyncSnapshot<bool> isLoading) {
                  return Styles.statefulButton(
                      stream: _viewModel.nextOfKinForm.isValid,
                      onClick: () =>_viewModel.moveToNext(widget.position),
                      text: widget.isLast() ? 'Submit' : 'Next',
                      isLoading: isLoading.hasData && isLoading.data == true
                  );
                }
            ),
            SizedBox(height: 32,),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}