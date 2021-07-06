import 'dart:convert';

import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:moniepoint_flutter/app/accountupdates/model/data/customer_detail_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/account_update_form_view.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

class AdditionalInfoScreen extends PagedForm {
  @override
  State<StatefulWidget> createState() => _AdditionalInfoScreen();

  @override
  String getTitle() => "Additional Info";
}

class _AdditionalInfoScreen extends State<AdditionalInfoScreen> with AutomaticKeepAliveClientMixin {

  void saveForm() {
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    final info = viewModel.additionalInfoForm.customerInfo;
    PreferenceUtil.saveDataForLoggedInUser("account-update-additional-info", info);
  }

  void onRestoreForm() {
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    final savedInfo = PreferenceUtil.getDataForLoggedInUser("account-update-additional-info");
    final info = CustomerDetailInfo.fromJson(savedInfo);

    viewModel.additionalInfoForm.onTitleChange(Titles.fromTitle(info.title));
    viewModel.additionalInfoForm.onMaritalStatusChange(MaritalStatus.fromString(info.maritalStatus));
    viewModel.additionalInfoForm.onReligionChange(Religion.fromString(info.religion));
    viewModel.additionalInfoForm.onEmploymentStatusChange(EmploymentStatus.fromString(info.employmentStatus));

    final nationality = Nationality.fromNationalityName(info.nationality, viewModel.nationalities);
    viewModel.additionalInfoForm.onNationalityChange(nationality);

    final state = StateOfOrigin.fromLocalGovtId(info.localGovernmentAreaOfOriginId, nationality?.states ?? []);
    viewModel.additionalInfoForm.onStateOfOriginChange(state);

    viewModel.additionalInfoForm.onLocalGovtChange(
        LocalGovernmentArea.fromId(info.localGovernmentAreaOfOriginId, state?.localGovernmentAreas ?? [])
    );
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

    return ScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
                stream: viewModel.additionalInfoForm.titleStream,
                builder: (BuildContext context, AsyncSnapshot<Titles> snapshot) {
              return Styles.buildDropDown(titles, snapshot, (value, i) {
                viewModel.additionalInfoForm.onTitleChange(value as Titles);
              }, hint: 'Title');
            }),
            SizedBox(height: 16,),
            StreamBuilder(
                stream: viewModel.additionalInfoForm.maritalStatusStream,
                builder: (BuildContext context, AsyncSnapshot<MaritalStatus> snapshot) {
                  return Styles.buildDropDown(maritalStatuses, snapshot, (value, i) {
                    viewModel.additionalInfoForm.onMaritalStatusChange(value as MaritalStatus);
                  },hint: 'Marital Status');
                }),
            SizedBox(height: 16,),
            StreamBuilder(
                stream: viewModel.additionalInfoForm.religionStream,
                builder: (BuildContext context, AsyncSnapshot<Religion> snapshot) {
                  return Styles.buildDropDown(religions, snapshot, (value, i) {
                    viewModel.additionalInfoForm.onReligionChange(value as Religion);
                  },hint: 'Religion');
                }, ),
            SizedBox(height: 16,),
            Consumer<AccountUpdateViewModel>(builder: (context, vm , _) {
              return StreamBuilder(
                  stream: viewModel.additionalInfoForm.nationalityStream,
                  builder: (BuildContext context, AsyncSnapshot<Nationality> snapshot) {
                    return Styles.buildDropDown(vm.nationalities, snapshot, (value, i) {
                      viewModel.additionalInfoForm.onNationalityChange(value as Nationality);
                      setState(() {});
                    },hint: 'Nationality');
                  });
            }),
            SizedBox(height: 16),
            StreamBuilder(
                stream: viewModel.additionalInfoForm.stateOfOriginStream,
                builder: (BuildContext context, AsyncSnapshot<StateOfOrigin?> snapshot) {
                  return Styles.buildDropDown(viewModel.additionalInfoForm.states, snapshot, (value, i) {
                    viewModel.additionalInfoForm.onStateOfOriginChange(value as StateOfOrigin);
                    setState(() {});
                  }, hint: 'State of Origin');
                }),
            SizedBox(height: 16,),
            StreamBuilder(
                stream: viewModel.additionalInfoForm.localGovtAreaStream,
                builder: (BuildContext context, AsyncSnapshot<LocalGovernmentArea?> snapshot) {
                  return Styles.buildDropDown(viewModel.additionalInfoForm.localGovt, snapshot, (value, i) {
                    viewModel.additionalInfoForm.onLocalGovtChange(value as LocalGovernmentArea);
                  }, hint: 'Local Govt. Area Origin');
                }),
            SizedBox(height: 16,),
            StreamBuilder(
                stream: viewModel.additionalInfoForm.employmentStatusStream,
                builder: (BuildContext context, AsyncSnapshot<EmploymentStatus> snapshot) {
                  return Styles.buildDropDown(employmentStatus, snapshot, (value, i) {
                    viewModel.additionalInfoForm.onEmploymentStatusChange(value as EmploymentStatus);
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
                          stream: viewModel.additionalInfoForm.isValid,
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