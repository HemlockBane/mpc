import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';

/// @author Paul Okeke
class CardScanInfoDialog extends Dialog {

  final BuildContext context;
  final VoidCallback onEnterSerial;
  final VoidCallback onScanQR;

  CardScanInfoDialog({
    required this.context,
    required this.onEnterSerial,
    required this.onScanQR
  });

  @override
  Color? get backgroundColor =>  Colors.transparent;

  @override
  EdgeInsets? get insetPadding => EdgeInsets.symmetric(horizontal: 16, vertical: 24);

  @override
  Widget? get child => _contentView();

  Widget _contentView() {
    final screenHeight = MediaQuery.of(context).size.height;
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
      content: Wrap(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 27, vertical: 0),
            child: Column(
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
                Container(
                  height: screenHeight / 3,
                  child: ScrollView(
                    maxHeight: 200,
                    child: Column(
                      children: [
                        Text(
                          'Scan the QR code on the card package. Alternatively, you can enter the card serial number on the card package',
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
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(8),
                              color: Colors.transparent
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                  left:0,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Image.asset(
                                    "res/drawables/ic_scan_qr_card_enveloped.png",
                                    width: 200, height: 200,
                                  )
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Expanded(
                //     child:
                // ),
                SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: Styles.appButton(
                      elevation: 0,
                      onClick: onScanQR,
                      text: 'Start Scan'
                  ),
                ),
                SizedBox(height: 24),
                TextButton(
                    onPressed: onEnterSerial,
                    child: Text(
                      'Enter Serial Number Instead',
                      style: TextStyle(
                          color: Colors.primaryColor,
                          fontSize: 16, fontWeight: FontWeight.normal
                      ),
                    )
                ),
                SizedBox(height: 36,),
              ],
            ),
          )
        ],
      ),
    );
  }

}