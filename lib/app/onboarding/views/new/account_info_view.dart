import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
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
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isLoading = false;

  _AccountInfoScreenState(this._scaffoldKey);

  void subscribeUiToOnBoard() {}

  @override
  void initState() {
    super.initState();
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
            fontWeight: FontWeight.w600,
            color: Colors.colorPrimaryDark,
            fontSize: 24,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 30),
        StreamBuilder(
            stream: viewModel.profileForm.passwordStream,
            builder: (context, snapshot) {
              return Styles.appEditText(
                hint: 'Address',
                onChanged: viewModel.profileForm.onPasswordChanged,
                errorText: snapshot.hasError ? snapshot.error.toString() : null,
                animateHint: true,
              );
            }),
        SizedBox(height: 16),
        // StreamBuilder(
        //     stream: viewModel.accountForm.nationalityStream,
        //     builder:
        //         (BuildContext context, AsyncSnapshot<Nationality> snapshot) {
        //       return Styles.buildDropDown([], snapshot, (value, i) {
        //         viewModel.accountForm.onNationalityChange(value as Nationality);
        //         setState(() {});
        //       }, hint: 'Nationality');
        //     }),
        // StreamBuilder(
        //     stream: viewModel.accountForm.nationalityStream,
        //     builder: (BuildContext context,
        //         AsyncSnapshot<LocalGovernmentArea> snapshot) {
        //       return Styles.buildDropDown([], snapshot, (value, i) {
        //         viewModel.accountForm.onNationalityChange(value as Nationality);
        //         setState(() {});
        //       }, hint: 'State of Residence');
        //     }),
        // StreamBuilder(
        //     stream: viewModel.accountForm.nationalityStream,
        //     builder: (BuildContext context,
        //         AsyncSnapshot<LocalGovernmentArea> snapshot) {
        //       return Styles.buildDropDown([], snapshot, (value, i) {
        //         viewModel.accountForm.onNationalityChange(value as Nationality);
        //         setState(() {});
        //       }, hint: 'Local Government Area');
        //     }),
        Spacer(),
        Styles.statefulButton(
            stream: viewModel.profileForm.isValid,
            onClick: () => subscribeUiToOnBoard(),
            text: "Next",
            isLoading: _isLoading)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                    color: Colors.backgroundWhite,
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 41, bottom: 42),
                    child: _buildMain(context)),
              ),
            ),
          );
        }));
  }
}
