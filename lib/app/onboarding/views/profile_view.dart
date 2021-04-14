import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/pin_entry.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  ProfileScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState(this._scaffoldKey);
  }
}

class _ProfileScreenState extends State<ProfileScreen> {

  late final GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isPasswordVisible  = false;

  _ProfileScreenState(this._scaffoldKey);
  
  Widget getPasswordToggleIcon(BuildContext context) {
    return IconButton(
        icon: Icon(this._isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.colorFaded),
        onPressed: () {
          setState(() {
            this._isPasswordVisible = !_isPasswordVisible;
          });
        }
    );
  }

  Widget _buildMain(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Create Your Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.darkBlue,
            fontSize: 21,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 30),
        StreamBuilder(
            stream: viewModel.profileForm.usernameStream,
            builder: (context, snapshot) {
              return Styles.appEditText(
                  hint: 'Enter Username',
                  animateHint: true,
                  onChanged: viewModel.profileForm.onUsernameChanged,
                  errorText:
                      snapshot.hasError ? snapshot.error.toString() : null,
                  startIcon:
                      Icon(CustomFont.username_icon, color: Colors.colorFaded),
                  drawablePadding: 8);
            }),
        SizedBox(height: 16),
        StreamBuilder(
            stream: viewModel.profileForm.passwordStream,
            builder: (context, snapshot) {
              return Styles.appEditText(
                  hint: 'Password',
                  onChanged: viewModel.profileForm.onPasswordChanged,
                  errorText: snapshot.hasError ? snapshot.error.toString() : null,
                  animateHint: true,
                  drawablePadding: 4,
                  startIcon: Icon(CustomFont.password, color: Colors.colorFaded),
                  endIcon: getPasswordToggleIcon(context),
                  isPassword: !_isPasswordVisible
              );
            }),
        SizedBox(height: 37),
        Container(
          margin: EdgeInsets.only(left: 44, right: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' Setup Mobile Transaction PIN',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.darkBlue),
              ),
              SizedBox(height: 16,),
              PinEntry()
            ],
          ),
        ),
        SizedBox(height: 46),
        Text(
            'Security Questions',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.darkBlue),
        ),
        SizedBox(height: 16),
        Text(
          'Security Question 1',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.textColorBlack),
        ),
        Spacer(),
        StreamBuilder(
          stream: viewModel.profileForm.isValid,
          initialData: false,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            return Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Styles.appButton(
                      onClick: snapshot.hasData && snapshot.data == true
                          ? () => {}
                          : null,
                      text: 'Continue'),
                ),
                Positioned(right: 16, top: 16, bottom: 16, child: SizedBox())
              ],
            );
          },
        ),
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
                    padding: EdgeInsets.only(left: 16, right: 16, top: 41, bottom: 42),
                    child: _buildMain(context)),
              ),
            ),
          );
        }));
  }

}
