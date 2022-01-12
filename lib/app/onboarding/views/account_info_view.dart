import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/onboarding/views/signup_account_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/mix_panel_analytics.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/custom_check_box.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

class AccountInfoScreen extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  AccountInfoScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _AccountInfoScreenState(this._scaffoldKey);
  }
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  late final OnBoardingViewModel _viewModel;
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isLoading = false;

  _AccountInfoScreenState(this._scaffoldKey);

  void subscribeUiToOnBoard() async {
    final mixPanel = await MixpanelManager.initAsync();
    mixPanel.track("Onboarding-Account-Info-Completed", properties: {
      "bvn": _viewModel.accountForm.account.bvn
    });
    Navigator.of(context).pushNamed(SignUpAccountScreen.PROFILE);
  }

  @override
  void initState() {
    _viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    super.initState();
    //TODO check if nationalities has been fetched if not re-fetch
  }

  Widget _buildMain(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Account Info',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.textColorBlack,
            fontSize: 24,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 30),
        StreamBuilder(
            stream: viewModel.accountForm.addressLineStream,
            builder: (context, snapshot) {
              return Styles.appEditText(
                hint: 'Address',
                onChanged: viewModel.accountForm.onAddressChange,
                errorText: snapshot.hasError ? snapshot.error.toString() : null,
                animateHint: true,
              );
            }),
        SizedBox(height: 24),
        StreamBuilder(
            stream: viewModel.accountForm.stateStream,
            builder: (BuildContext context, AsyncSnapshot<StateOfOrigin?> snapshot) {
              return Styles.buildDropDown(viewModel.accountForm.states, snapshot, (value, i) {
                viewModel.accountForm.onStateChange(value as StateOfOrigin);
                setState(() {});
              }, hint: 'State of Residence');
            }),
        SizedBox(height: 24),
        StreamBuilder(
            stream: viewModel.accountForm.localGovtStream,
            builder: (BuildContext context,
                AsyncSnapshot<LocalGovernmentArea?> snapshot) {
              return Styles.buildDropDown(viewModel.accountForm.localGovt, snapshot, (value, i) {
                viewModel.accountForm.onLocalGovtChange(value as LocalGovernmentArea);
                setState(() {});
              }, hint: 'Local Government Area');
            }),
        SizedBox(height: 32),
        Text(
          'Gender',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.textColorBlack,
            fontSize: 18,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 20),
        StreamBuilder(
            stream: viewModel.accountForm.genderStream,
            builder: (BuildContext mContext, AsyncSnapshot<String?> snapshot) {
              return Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Align(
                          child: Text('Male', style: TextStyle(fontSize: 16, color: Colors.textColorBlack),),
                          alignment: Alignment(-1.05, 0),
                        ),
                        leading: CustomCheckBox(onSelect: (v) {
                          viewModel.accountForm.onGenderChanged("MALE");
                        }, isSelected: snapshot.hasData && snapshot.data == "MALE"),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Align(
                          child: Text('Female', style: TextStyle(fontSize: 16, color: Colors.textColorBlack)),
                          alignment: Alignment(-1.05, 0),
                        ),
                        leading: CustomCheckBox(onSelect: (v) {
                          viewModel.accountForm.onGenderChanged("FEMALE");
                        }, isSelected: snapshot.hasData && snapshot.data == "FEMALE"),
                      )
                    ],
                  )
              );
            }
        ),
        Spacer(),
        Styles.statefulButton(
            stream: viewModel.accountForm.isAccountInfoValid,
            onClick: () => subscribeUiToOnBoard(),
            text: "Next",
            isLoading: _isLoading)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollView(
        maxHeight: MediaQuery.of(context).size.height - 64, //subtract the vertical padding
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            color: Colors.white,
            child: _buildMain(context)
        )
    );
  }
}
