
import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/additional_info_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

class AdditionalInfoScreen extends PagedForm {
  @override
  State<StatefulWidget> createState() => _AdditionalInfoScreen();

  @override
  String getTitle() => "Additional Info";
}

class _AdditionalInfoScreen extends State<AdditionalInfoScreen> with AutomaticKeepAliveClientMixin {

  late final AccountUpdateViewModel _viewModel;
  late final AdditionalInfoForm _additionalInfoForm;

  @override
  void initState() {
    _viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    _additionalInfoForm = _viewModel.additionalInfoForm..setNationalities(_viewModel.nationalities);
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration.zero, (){
        _additionalInfoForm.restoreFormState();
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
                stream: _additionalInfoForm.titleStream,
                builder: (BuildContext context, AsyncSnapshot<Titles> snapshot) {
              return Styles.buildDropDown(titles, snapshot, (value, i) {
                _additionalInfoForm.onTitleChange(value as Titles);
              }, hint: 'Title');
            }),
            SizedBox(height: 20,),
            StreamBuilder(
                stream: _additionalInfoForm.maritalStatusStream,
                builder: (BuildContext context, AsyncSnapshot<MaritalStatus> snapshot) {
                  return Styles.buildDropDown(maritalStatuses, snapshot, (value, i) {
                    _additionalInfoForm.onMaritalStatusChange(value as MaritalStatus);
                  },hint: 'Marital Status');
                }),
            SizedBox(height: 20,),
            StreamBuilder(
                stream: _additionalInfoForm.religionStream,
                builder: (BuildContext context, AsyncSnapshot<Religion> snapshot) {
                  return Styles.buildDropDown(religions, snapshot, (value, i) {
                    _additionalInfoForm.onReligionChange(value as Religion);
                  },hint: 'Religion');
                }, ),
            SizedBox(height: 20,),
            StreamBuilder(
                stream: _additionalInfoForm.nationalityStream,
                builder: (BuildContext context, AsyncSnapshot<Nationality> snapshot) {
                  return Styles.buildDropDown(_viewModel.nationalities, snapshot, (value, i) {
                    _additionalInfoForm.onNationalityChange(value as Nationality);
                  },hint: 'Nationality');
                }),
            SizedBox(height: 20),
            StreamBuilder(
                stream: _additionalInfoForm.stateOfOriginStream,
                builder: (BuildContext context, AsyncSnapshot<StateOfOrigin?> snapshot) {
                  return Styles.buildDropDown(_additionalInfoForm.states, snapshot, (value, i) {
                    _additionalInfoForm.onStateOfOriginChange(value as StateOfOrigin);
                  }, hint: 'State of Origin');
                }),
            SizedBox(height: 20,),
            StreamBuilder(
                stream: _additionalInfoForm.localGovtAreaStream,
                builder: (BuildContext context, AsyncSnapshot<LocalGovernmentArea?> snapshot) {
                  return Styles.buildDropDown(_additionalInfoForm.localGovt, snapshot, (value, i) {
                    _additionalInfoForm.onLocalGovtChange(value as LocalGovernmentArea);
                  }, hint: 'Local Govt. Area');
                }),
            SizedBox(height: 20,),
            StreamBuilder(
                stream: _additionalInfoForm.employmentStatusStream,
                builder: (BuildContext context, AsyncSnapshot<EmploymentStatus> snapshot) {
                  return Styles.buildDropDown(employmentStatus, snapshot, (value, i) {
                    _additionalInfoForm.onEmploymentStatusChange(value as EmploymentStatus);
                  }, hint: 'Employment Status');
                }),
            SizedBox(height: 32),
            Spacer(),
            Styles.statefulButton(
                stream: _additionalInfoForm.isValid,
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