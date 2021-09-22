import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/beneficiary.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';

///@author Paul Okeke
class BeneficiaryListItem extends Container {

  final Beneficiary _beneficiary;
  final int position;
  final OnItemClickListener<Beneficiary, int>? _onItemClickListener;

  BeneficiaryListItem(this._beneficiary, this.position, this._onItemClickListener);

  Widget initialView() {
    return Container(
      width: 38,
      height: 38,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.darkBlue.withOpacity(0.1)
      ),
      child: Center(
        child: Text(
          _beneficiary.getAccountName().abbreviate(2, true),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.darkBlue, fontSize: 13)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () => _onItemClickListener?.call(_beneficiary, position),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
        child: Row(
          children: [
            initialView(),
            SizedBox(width: 16),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          _beneficiary.getAccountName(),
                          style: TextStyle(fontSize: 16, color: Colors.darkBlue, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(height: 2),
                      Text(
                          "${_beneficiary.getBeneficiaryProviderName()} - ${_beneficiary.getBeneficiaryDigits()}",
                          style: TextStyle(fontSize: 12, color: Colors.deepGrey, fontWeight: FontWeight.normal, fontFamily: Styles.defaultFont)
                      ).colorText({"${_beneficiary.getBeneficiaryDigits()}": Tuple(Colors.deepGrey, null)}, underline: false)
                    ]
                )),
            SvgPicture.asset('res/drawables/ic_forward_anchor.svg', width: 13.5, height: 13.5, color: Colors.darkBlue.withOpacity(0.3),),
            SizedBox(width: 2),
          ],
        ),
      ),
    ),
  );
}