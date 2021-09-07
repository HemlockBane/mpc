import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/card_issuance_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';

class CardSerialDialog extends Dialog {

  final TextEditingController? cardSerialController;
  final BuildContext context;
  final VoidCallback onClick;
  final CardIssuanceViewModel viewModel;

  CardSerialDialog({
    required this.context,
    required this.viewModel,
    required this.onClick,
    this.cardSerialController,
  });

  @override
  EdgeInsets? get insetPadding => EdgeInsets.symmetric(horizontal: 16, vertical: 24);

  @override
  Color? get backgroundColor => Colors.transparent;

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
        child: SvgPicture.asset('res/drawables/ic_qr_code.svg'),
      ),
      content: Container(
        height: 600,
        padding: EdgeInsets.symmetric(horizontal: 27, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Center(
              child: Text('Scan QR Code',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.textColorBlack)),
            ),
            SizedBox(height: 30),
            Expanded(
                child: ScrollView(
                  maxHeight: 200,
                  child: Column(
                    children: [
                      Text(
                        'Scan the QR code on the card package.\nAlternatively, you can enter the card serial\nnumber on the card package',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.textColorBlack,
                            fontSize: 16
                        ),
                      ),
                      SizedBox(height: 26),
                      Container(
                        width: double.infinity,
                        height: 170,
                        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.primaryColor.withOpacity(0.1)
                        ),
                        child: Center(
                          child: SvgPicture.asset('res/drawables/ic_card_serial.svg'),
                        ),
                      )
                    ],
                  ),
                ),
            ),
            SizedBox(height: 24),
            Text("Enter Serial Number", textAlign: TextAlign.start,),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.7),
              child: Styles.appEditText(
                  controller: cardSerialController,
                  hint: 'XXXX-XXXX-XXXX-XXXX',
                  inputType: TextInputType.number,
                  inputFormats: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    viewModel.setCardSerial(value);
                    viewModel.onCardSerialChange(value);
                    if(viewModel.isCardSerialValid(viewModel.cardSerial)){
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  },
                  startIcon: Icon(CustomFont.numberInput, color: Colors.textFieldIcon.withOpacity(0.2), size: 22),
                  animateHint: true,
                  maxLength: 10
              ),
            ),
            SizedBox(height: 24,),
            SizedBox(
              width: double.infinity,
              child: Styles.statefulButton(
                  stream: viewModel.isCardSerialValidStream,
                  elevation: 0,
                  onClick: onClick,
                  text: 'Continue'
              ),
            ),
            SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

}