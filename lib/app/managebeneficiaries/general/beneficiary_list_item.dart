import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/managebeneficiaries/beneficiary.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:moniepoint_flutter/core/views/icon_curved_container.dart';

///@author Paul Okeke
class BeneficiaryListItem extends Container {

  final Beneficiary _beneficiary;
  final int position;
  final OnItemClickListener<Beneficiary, int>? _onItemClickListener;

  BeneficiaryListItem(this._beneficiary, this.position, this._onItemClickListener);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              width: 0.9,
              color: Color(0XFF4A7BC7).withOpacity(0.15)
          ),
          boxShadow: [
            BoxShadow(
                color: Color(0XFF0649AF).withOpacity(0.06),
                offset: Offset(0, 1),
                blurRadius: 1
            )
          ]
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.05)),
          highlightColor: Colors.primaryColor.withOpacity(0.02),
          borderRadius: BorderRadius.circular(8),
          onTap: () => _onItemClickListener?.call(_beneficiary, position),
          child: Container(
            padding: EdgeInsets.only(left: 11, right: 11, top: 14, bottom: 14),
            child: Row(
              children: [
                IconCurvedContainer(
                    width: 53,
                    height: 53,
                    backgroundColor: Colors.primaryColor.withOpacity(0.1),
                    child: Center(
                      child: Text(
                          _beneficiary.getAccountName().abbreviate(2, true),
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.primaryColor, fontSize: 20)
                      ),
                    )
                ),
                SizedBox(width: 16),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              _beneficiary.getAccountName(),
                              style: TextStyle(fontSize: 15, color: Colors.textColorBlack, fontWeight: FontWeight.bold)
                          ),
                          SizedBox(height: 3),
                          Text(
                              "${_beneficiary.getBeneficiaryProviderName()} - ${_beneficiary.getBeneficiaryDigits()}",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.textColorBlack.withOpacity(0.5),
                                  fontWeight: FontWeight.normal,
                                  fontFamily: Styles.defaultFont
                              )
                          ).colorText({"${_beneficiary.getBeneficiaryDigits()}": Tuple(Colors.deepGrey, null)}, underline: false)
                        ]
                    )),
                // SvgPicture.asset('res/drawables/ic_forward_anchor.svg', width: 13.5, height: 13.5, color: Colors.darkBlue.withOpacity(0.3),),
                SizedBox(width: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}