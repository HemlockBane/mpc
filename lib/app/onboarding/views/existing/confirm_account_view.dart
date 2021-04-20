import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:provider/provider.dart';

class ConfirmAccountNumberScreen extends StatelessWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;

  ConfirmAccountNumberScreen(this._scaffoldKey);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.backgroundWhite,
        padding: EdgeInsets.only(left: 16, right: 16, top: 41, bottom: 44),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('We’ve found you!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.darkBlue,
                fontSize: 21,
              ),
              textAlign: TextAlign.start,
            ),
            Text('Ensure this number and name are correct.',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.textColorBlack,
                    fontSize: 14)
            ),
            SizedBox(height: 30,),
            Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3.5))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.primaryColor, width: 3)
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Row(
                    children: [
                      SizedBox(width: 17),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(viewModel.transferBeneficiary?.accountName ?? "",
                            style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.darkBlue,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          SizedBox(height: 4),
                          Text(
                              viewModel.transferBeneficiary?.accountNumber ?? "",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.textColorBlack,
                                  fontWeight: FontWeight.normal
                              )
                          )
                        ],
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Not you?'),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(Colors.primaryColor),
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 15, color: Colors.primaryColor, fontWeight: FontWeight.bold, fontFamily: Styles.defaultFont))
                        ),
                      ),
                      SizedBox(width: 32),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Spacer(),
            Styles.appButton(onClick: ()=> Navigator.of(context).pushNamed('otp-screen'), text: 'Continue'),
            SizedBox(height: 66,)
          ],
        ),
    );
  }


}