import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

class AdditionalInfoScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _AdditionalInfoScreen();
  }

}

class _AdditionalInfoScreen extends State<AdditionalInfoScreen> with AutomaticKeepAliveClientMixin {

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
                  return Styles.buildDropDown(maritalStatus, snapshot, (value, i) {
                    viewModel.additionalInfoForm.onMaritalStatusChange(value as MaritalStatus);
                  },hint: 'Marital Status');
                }),
            SizedBox(height: 16,),
            StreamBuilder(
                stream: viewModel.additionalInfoForm.religionStream,
                builder: (BuildContext context, AsyncSnapshot<Religion> snapshot) {
                  return Styles.buildDropDown(religion, snapshot, (value, i) {
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
                Flexible(child: Container()),
                Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: double.infinity,
                        child: StreamBuilder(
                            stream: viewModel.additionalInfoForm.isValid,
                            builder: (BuildContext mContext, AsyncSnapshot<bool> snapshot) {
                          final enableButton = snapshot.hasData && snapshot.data == true;
                          return Styles.appButton(onClick: enableButton ? ()=> null :  null, text: 'Next');
                        }),
                      ),
                    )
                )
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