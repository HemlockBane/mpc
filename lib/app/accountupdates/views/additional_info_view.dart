
import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/additional_info_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/account_update_form_view.dart';
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

  // void saveForm() {
  //   final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
  //   final info = viewModel.additionalInfoForm.customerInfo;
  //   PreferenceUtil.saveDataForLoggedInUser("account-update-additional-info", info);
  // }

  // void onRestoreForm() {
    // final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    // final savedInfo = PreferenceUtil.getDataForLoggedInUser("account-update-additional-info");
    // final info = CustomerDetailInfo.fromJson(savedInfo);
    //
    // viewModel.additionalInfoForm.onTitleChange(Titles.fromTitle(info.title));
    // viewModel.additionalInfoForm.onMaritalStatusChange(MaritalStatus.fromString(info.maritalStatus));
    // viewModel.additionalInfoForm.onReligionChange(Religion.fromString(info.religion));
    // viewModel.additionalInfoForm.onEmploymentStatusChange(EmploymentStatus.fromString(info.employmentStatus));
    //
    // final nationality = Nationality.fromNationalityName(info.nationality, viewModel.nationalities);
    // viewModel.additionalInfoForm.onNationalityChange(nationality);
    //
    // final state = StateOfOrigin.fromLocalGovtId(info.localGovernmentAreaOfOriginId, nationality?.states ?? []);
    // viewModel.additionalInfoForm.onStateOfOriginChange(state);
    //
    // viewModel.additionalInfoForm.onLocalGovtChange(
    //     LocalGovernmentArea.fromId(info.localGovernmentAreaOfOriginId, state?.localGovernmentAreas ?? [])
    // );
  // }

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
            StreamBuilder(
                stream: _viewModel.additionalInfoForm.titleStream,
                builder: (BuildContext context, AsyncSnapshot<Titles> snapshot) {
              return Styles.buildDropDown(titles, snapshot, (value, i) {
                _viewModel.additionalInfoForm.onTitleChange(value as Titles);
              }, hint: 'Title');
            }),
            SizedBox(height: 16,),
            StreamBuilder(
                stream: _viewModel.additionalInfoForm.maritalStatusStream,
                builder: (BuildContext context, AsyncSnapshot<MaritalStatus> snapshot) {
                  return Styles.buildDropDown(maritalStatuses, snapshot, (value, i) {
                    _viewModel.additionalInfoForm.onMaritalStatusChange(value as MaritalStatus);
                  },hint: 'Marital Status');
                }),
            SizedBox(height: 16,),
            StreamBuilder(
                stream: _viewModel.additionalInfoForm.religionStream,
                builder: (BuildContext context, AsyncSnapshot<Religion> snapshot) {
                  return Styles.buildDropDown(religions, snapshot, (value, i) {
                    _viewModel.additionalInfoForm.onReligionChange(value as Religion);
                  },hint: 'Religion');
                }, ),
            SizedBox(height: 16,),
            Consumer<AccountUpdateViewModel>(builder: (context, vm , _) {
              return StreamBuilder(
                  stream: _viewModel.additionalInfoForm.nationalityStream,
                  builder: (BuildContext context, AsyncSnapshot<Nationality> snapshot) {
                    return Styles.buildDropDown(vm.nationalities, snapshot, (value, i) {
                      _viewModel.additionalInfoForm.onNationalityChange(value as Nationality);
                      // setState(() {});
                    },hint: 'Nationality');
                  });
            }),
            SizedBox(height: 16),
            StreamBuilder(
                stream: _viewModel.additionalInfoForm.stateOfOriginStream,
                builder: (BuildContext context, AsyncSnapshot<StateOfOrigin?> snapshot) {
                  return Styles.buildDropDown(_viewModel.additionalInfoForm.states, snapshot, (value, i) {
                    _viewModel.additionalInfoForm.onStateOfOriginChange(value as StateOfOrigin);
                    // setState(() {});
                  }, hint: 'State of Origin');
                }),
            SizedBox(height: 16,),
            StreamBuilder(
                stream: _viewModel.additionalInfoForm.localGovtAreaStream,
                builder: (BuildContext context, AsyncSnapshot<LocalGovernmentArea?> snapshot) {
                  return Styles.buildDropDown(_viewModel.additionalInfoForm.localGovt, snapshot, (value, i) {
                    _viewModel.additionalInfoForm.onLocalGovtChange(value as LocalGovernmentArea);
                  }, hint: 'Local Govt. Area');
                }),
            SizedBox(height: 16,),
            StreamBuilder(
                stream: _viewModel.additionalInfoForm.employmentStatusStream,
                builder: (BuildContext context, AsyncSnapshot<EmploymentStatus> snapshot) {
                  return Styles.buildDropDown(employmentStatus, snapshot, (value, i) {
                    _viewModel.additionalInfoForm.onEmploymentStatusChange(value as EmploymentStatus);
                  }, hint: 'Employment Status');
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
                          stream: _viewModel.additionalInfoForm.isValid,
                          onClick: () {
                            _viewModel.moveToNext(widget.position);
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