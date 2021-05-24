import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/next_of_kin_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/next_of_kin_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

import 'account_update_form_view.dart';

class NextOfKinScreen extends PagedForm {

  @override
  State<StatefulWidget> createState() {
    return _NextOfKinScreen();
  }

}

class _NextOfKinScreen extends State<NextOfKinScreen> with AutomaticKeepAliveClientMixin {

  NextOfKinForm? _nextOfKinForm;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  final TextEditingController _houseAddressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();


  void saveForm() {
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    final info = viewModel.nextOfKinForm.nextOfKinInfo;
    PreferenceUtil.saveDataForLoggedInUser("account-update-next-of-kin-info", info);
  }

  void onRestoreForm() {
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    final savedInfo = PreferenceUtil.getDataForLoggedInUser("account-update-next-of-kin-info");
    final info = NextOfKinInfo.fromJson(savedInfo);

    if(info.nextOfKinFirstName != null || info.nextOfKinFirstName?.isNotEmpty == true) {
      _firstNameController.text = info.nextOfKinFirstName ?? "";
      _nextOfKinForm?.onFirstNameChange(_firstNameController.text);
    }

    if(info.nextOfKinMiddleName != null || info.nextOfKinMiddleName?.isNotEmpty == true) {
      _middleNameController.text = info.nextOfKinMiddleName ?? "";
      _nextOfKinForm?.onMiddleNameChange(_middleNameController.text);
    }

    if(info.nextOfKinLastName != null || info.nextOfKinLastName?.isNotEmpty == true) {
      _lastNameController.text = info.nextOfKinLastName ?? "";
      _nextOfKinForm?.onLastNameChange(_lastNameController.text);
    }

    if(info.nextOfKinPhoneNumber != null || info.nextOfKinPhoneNumber?.isNotEmpty == true) {
      _phoneNumberController.text = info.nextOfKinPhoneNumber ?? "";
      _nextOfKinForm?.onPhoneNumberChange(_phoneNumberController.text);
    }

    if(info.nextOfKinEmail != null || info.nextOfKinEmail?.isNotEmpty == true) {
      _emailAddressController.text = info.nextOfKinEmail ?? "";
      _nextOfKinForm?.onEmailAddressChange(_emailAddressController.text);
    }

    if(info.nextOfKinRelationship != null || info.nextOfKinRelationship?.isNotEmpty == true) {
      _nextOfKinForm?.onRelationshipChange(Relationship.fromString(info.nextOfKinRelationship));
    }

    if(info.nextOfKinDOB != null || info.nextOfKinDOB?.isNotEmpty == true) {
      _dateOfBirthController.text = info.nextOfKinDOB ?? "";
      _nextOfKinForm?.onDateOfBirthChange(_dateOfBirthController.text);
    }

    if(info.addressInfo?.addressLine != null || info.addressInfo?.addressLine?.isNotEmpty == true) {
      _houseAddressController.text = info.addressInfo?.addressLine ?? "";
      _nextOfKinForm?.addressForm.onAddressChange(_houseAddressController.text);
    }

    if(info.addressInfo?.addressCity != null || info.addressInfo?.addressCity?.isNotEmpty == true) {
      _cityController.text = info.addressInfo?.addressCity ?? "";
      _nextOfKinForm?.addressForm.onCityChange(_cityController.text);
    }

    final nationality = viewModel.nationalities.first;

    final state = StateOfOrigin.fromLocalGovtId(info.addressInfo?.addressLocalGovernmentAreaId, nationality.states ?? []);
    _nextOfKinForm?.addressForm.onStateChange(state);

    _nextOfKinForm?.addressForm.onLocalGovtChange(
        LocalGovernmentArea.fromId(info.addressInfo?.addressLocalGovernmentAreaId, state?.localGovernmentAreas ?? [])
    );
  }

  void displayDatePicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
        helpText: 'Select Date of Birth',
        context: context,
        initialDate: DateTime(1980, 1, 1).add(Duration(days: 1)),
        firstDate: DateTime(1900, 1, 1).add(Duration(days: 1)),
        lastDate: DateTime.now().subtract(Duration(days: 365 * 2))
    );

    if(selectedDate != null ) {
      _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      _nextOfKinForm?.onDateOfBirthChange(DateFormat('dd-MM-yyyy').format(selectedDate));
    }
  }

  @override
  void initState() {
    super.initState();
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
    this._nextOfKinForm = viewModel.nextOfKinForm
      ..addressForm.setStates(viewModel.nationalities.first.states ?? []);

    return ScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
                stream: _nextOfKinForm?.firstNameStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _firstNameController,
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.onFirstNameChange,
                      hint: 'First Name',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 16),
            StreamBuilder(
                stream: _nextOfKinForm?.middleNameStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _middleNameController,
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.onMiddleNameChange,
                      hint: 'Middle Name',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 16),
            StreamBuilder(
                stream: _nextOfKinForm?.lastNameStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _lastNameController,
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.onLastNameChange,
                      hint: 'Last Name',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 16),
            StreamBuilder(
                stream: _nextOfKinForm?.phoneNumberStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _phoneNumberController,
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.onPhoneNumberChange,
                      hint: 'Phone Number',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 16),
            StreamBuilder(
                stream: _nextOfKinForm?.emailStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _emailAddressController,
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.onEmailAddressChange,
                      hint: 'Email Address',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 16),
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
                SizedBox(width: 16),
                Expanded(
                    child: StreamBuilder(
                        stream: _nextOfKinForm?.dateOfBirthStream,
                        builder: (context, snapshot) {
                          return Styles.appEditText(
                              controller: _dateOfBirthController,
                              onClick: () => displayDatePicker(context),
                              errorText: snapshot.hasError ? snapshot.error.toString() : null,
                              hint: 'Date of Birth',
                              animateHint: false,
                              readOnly: true,
                              startIcon: Icon(CustomFont.calendar, color: Colors.colorFaded),
                              fontSize: 15
                          );
                        })
                ),
              ],
            ),
            SizedBox(height: 16),
            StreamBuilder(
                stream: _nextOfKinForm?.addressForm.addressStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _houseAddressController,
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.addressForm.onAddressChange,
                      hint: 'House Address',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 16),
            StreamBuilder(
                stream: _nextOfKinForm?.addressForm.cityStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Styles.appEditText(
                      controller: _cityController,
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: _nextOfKinForm?.addressForm.onCityChange,
                      hint: 'City Town',
                      animateHint: false,
                      fontSize: 15);
                }),
            SizedBox(height: 16),
            StreamBuilder(
                stream: _nextOfKinForm?.addressForm.stateStream,
                builder: (BuildContext context, AsyncSnapshot<StateOfOrigin?> snapshot) {
                  return Styles.buildDropDown(_nextOfKinForm?.addressForm.states ?? <StateOfOrigin>[], snapshot, (value, i) {
                    _nextOfKinForm?.addressForm.onStateChange(value as StateOfOrigin);
                  }, hint: 'State of Origin');
                }),
            SizedBox(height: 16),
            StreamBuilder(
                stream: _nextOfKinForm?.addressForm.localGovtStream,
                builder: (BuildContext context, AsyncSnapshot<LocalGovernmentArea?> snapshot) {
                  return Styles.buildDropDown(_nextOfKinForm?.addressForm.localGovt ?? <LocalGovernmentArea>[], snapshot, (value, i) {
                    _nextOfKinForm?.addressForm.onLocalGovtChange(value as LocalGovernmentArea);
                  }, hint: 'Local Govt. Area Origin');
                }),
            SizedBox(height: 32),
            Expanded(child: Row(
              children: [
                (widget.isLast()) ? SizedBox() : Flexible(child: Container()),
                Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Styles.statefulButton(
                        stream: _nextOfKinForm?.isValid,
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
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}