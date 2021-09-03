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
      centerBackgroundPadding: 14,
      centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
      contentBackgroundColor: Colors.white,
      dialogIcon: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.primaryColor
        ),
        child: SvgPicture.asset('res/drawables/ic_info_italic.svg'),
      ),
      content: ScrollView(
        maxHeight: 400,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 27, vertical: 0),
          child: Column(
            children: [
              SizedBox(height: 24),
              Center(
                child: Text('Before you begin...',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.textColorBlack)),
              ),
              SizedBox(height: 30,),
              Text(
                'To completely upgrade your account, you \nwill need to provide the following \ndocuments:',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.textColorBlack,
                    fontSize: 16
                ),
              ),
              SizedBox(height: 26),
              Container(
                width: double.infinity,
                height: 200,
                padding: EdgeInsets.all(35),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.primaryColor.withOpacity(0.1)
                ),
                child: Row(
                  children: [
                    SvgPicture.asset("res/drawables/ic_bank_number_input.svg"),
                    SizedBox(height: 15),
                    Column(
                      children: [
                        Text(
                          'Identification',
                          style: TextStyle(color: Colors.textColorBlack, fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '\u2022\t\tUtility Bills (e.g. electricity bills)\n\u2022\t\tTenancy Agreements\n\u2022\t\tResident Permits',
                          style: TextStyle(color: Colors.textColorBlack, fontSize: 13, fontWeight: FontWeight.w400),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

}