import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';

class CardActivationCodeDialog extends StatelessWidget {

  final String activationCode;

  CardActivationCodeDialog(this.activationCode);

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet2(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerBackgroundPadding: 12,
        dialogIcon: SvgPicture.asset(
          'res/drawables/ic_info_italic.svg',
          color: Colors.primaryColor,
          width: 40,
          height: 40,
        ),
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  SizedBox(height: 7),
                  Text("Card Activation Code",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.textColorBlack)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.primaryColor.withOpacity(0.1)),
                    child: Column(
                      children: [
                        Text("Your Moniepoint card issuance code is",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.textColorBlack),
                            textAlign: TextAlign.center),
                        SizedBox(height: 10),
                        Text(activationCode,
                            style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                color: Colors.primaryColor),
                            textAlign: TextAlign.center),
                        SizedBox(height: 10),
                        Text("Show this code to your Moniepoint Agent",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.textColorBlack
                            ),
                            textAlign: TextAlign.center
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("Back to Cards",
                          style: TextStyle(
                              color: Colors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.normal)
                      )
                  ),
                  SizedBox(height: 16),
                ],
              ),
            )
          ],
        ));
  }

}