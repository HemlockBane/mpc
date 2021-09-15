import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';

/// @author Paul Okeke
class AccountUpdateInfoDialog extends Dialog {

  final BuildContext context;

  AccountUpdateInfoDialog({
    required this.context,
  });

  @override
  Color? get backgroundColor =>  Colors.transparent;

  @override
  EdgeInsets? get insetPadding => EdgeInsets.symmetric(horizontal: 16, vertical: 24);

  @override
  Widget? get child => _contentView();

  Widget _contentView() {
    return BottomSheets.makeAppBottomSheet2(
      curveBackgroundColor: Colors.white,
      centerBackgroundPadding: 15,
      centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
      contentBackgroundColor: Colors.white,
      dialogIcon: Container(
        height:46,
        width: 46,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.primaryColor
        ),
        child: SvgPicture.asset('res/drawables/ic_info_italic.svg', color: Colors.white,),
      ),
      content: ScrollView(
        maxHeight: 400,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 27, vertical: 0),
          child: Column(
            children: [
              SizedBox(height: 26),
              Center(
                child: Text('Before you begin...',
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.textColorBlack)),
              ),
              SizedBox(height: 29,),
              Text(
                'To completely upgrade your account, you \nwill need to provide the following \ndocuments:',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.textColorBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.normal
                ),
              ),
              SizedBox(height: 26),
              _IdentificationRequirement(),
              SizedBox(height: 14,),
              _ProofOfAddressRequirement(),
              SizedBox(height: 22),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "*",
                      style: TextStyle(
                          color: Colors.colorFaded,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  SizedBox(width: 6,),
                  Flexible(
                      child: Text(
                          "All documents should be valid at the time of registration",
                          style: TextStyle(
                              color: Colors.darkBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.normal
                          )
                      )
                  )
                ],
              ),
              SizedBox(height: 29),
              SizedBox(
                width: double.infinity,
                child: Styles.appButton(
                    elevation: 0.5,
                    onClick: () => Navigator.of(context).pop(),
                    text: "Proceed"
                ),
              ),
              SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }

}

///
///
///
///
///
///
class _IdentificationRequirement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.primaryColor.withOpacity(0.1)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset("res/drawables/ic_bank_number_input.svg", color: Colors.primaryColor, width: 26, height: 21,),
          SizedBox(width: 15),
          Flexible(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Identification',
                style: TextStyle(color: Colors.textColorBlack, fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                "e.g National ID / NIN, Driver’s License, International Passport, Voter’s Card",
                style: TextStyle(
                    color: Colors.textColorBlack,
                    fontSize: 13,
                    fontWeight: FontWeight.normal
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

}

///
///
///
///
///
///
class _ProofOfAddressRequirement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.primaryColor.withOpacity(0.1)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset("res/drawables/ic_location.svg", color: Colors.primaryColor, width: 26, height: 21,),
          SizedBox(width: 15),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Proof of Address',
                style: TextStyle(color: Colors.textColorBlack, fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                "e.g Utility Bills (e.g. electricity bills), Tenency Agreements, Resident Permits",
                style: TextStyle(
                    color: Colors.textColorBlack,
                    fontSize: 13,
                    fontWeight: FontWeight.normal
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

}