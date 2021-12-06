import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/extensions/strings.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:moniepoint_flutter/core/views/icon_curved_container.dart';

import '../colors.dart';
import '../styles.dart';
import '../tuple.dart';

class SelectedTransactionRecipientView extends StatelessWidget {

  SelectedTransactionRecipientView({
    required this.recipientName,
    required this.recipientDigits,
    required this.providerName,
    this.displayChange = true,
    this.leadingColor = Colors.primaryColor
  });

  final String recipientName;
  final String providerName;
  final String recipientDigits;
  final bool displayChange;
  final Color leadingColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 11.87, right: 8, top: 14.25, bottom: 14.17),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0XFF0B3175).withOpacity(0.1), width: 0.8, style: BorderStyle.solid),
          boxShadow: [
            BoxShadow(
                color: Color(0XFF0B3175).withOpacity(0.1),
                offset: Offset(0, 1),
                blurRadius: 1.2
            )
          ]
      ),
      child:  Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconCurvedContainer(
              width: 53,
              height: 53,
              backgroundColor: leadingColor.withOpacity(0.1),
              child: Center(
                child: Text(
                    recipientName.abbreviate(2, true, includeMidDot: false),
                    style: TextStyle(fontWeight: FontWeight.bold, color: leadingColor, fontSize: 19)
                ),
              )
          ),
          SizedBox(width: 10,),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$recipientName',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 15, color: Colors.textColorBlack, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3,),
                  Text(
                    '$providerName - $recipientDigits',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.textColorBlack.withOpacity(0.5), fontSize: 13, fontFamily: Styles.defaultFont),
                  ).colorText({"$recipientDigits" : Tuple(Colors.textColorBlack.withOpacity(0.5), null)}, underline: false)
                ],
              )
          ),
          if(displayChange)
            Expanded(
                flex: 0,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Change',
                    style: TextStyle(
                        color: Colors.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(40, 0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: MaterialStateProperty.all(
                        Colors.primaryColor.withOpacity(0.2)),
                  ),
                ))
        ],
      ),
    );
  }

}