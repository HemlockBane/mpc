import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

class InsufficientFundsDialog extends StatelessWidget {
  final String accountBalance;
  final String cardCost;

  InsufficientFundsDialog({required this.accountBalance, required this.cardCost});

  String _getMessage() {
    return "Dear Customer,"
        "\n\nYour balance of N$accountBalance is not enough to cover the cost of the card N$cardCost."
        "\n\n\nYou can fund your account by depositing at any agent location or transferring from your bank app/USSD";
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet2(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.red.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerBackgroundPadding: 12,
        dialogIcon: SvgPicture.asset(
          'res/drawables/ic_info.svg',
          color: Colors.red,
          width: 40,
          height: 40,
        ),
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Text("Insufficient Funds",
                      style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.red.withOpacity(0.1)),
                    child: Text(_getMessage(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.textColorBlack),
                    ).colorText({
                      "N$accountBalance" :  Tuple(Colors.textColorBlack, null),
                      "N$cardCost" :  Tuple(Colors.textColorBlack, null)
                    }, underline: false),
                  ),
                  SizedBox(height: 42),
                  TextButton(
                    child: Text(
                      "Try Again",
                      style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(height: 42),
                ],
              ),
            )
          ],
        ));
  }
}
