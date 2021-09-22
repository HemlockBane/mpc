import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';

class AccountSettingsDialog extends StatefulWidget {
  final Tier qualifiedTier;

  AccountSettingsDialog(this.qualifiedTier);

  @override
  State<StatefulWidget> createState() => _AccountSettingsDialog();
}


class _AccountSettingsDialog extends State<AccountSettingsDialog> {

  void _blockAccount() {
    Navigator.of(context).pop("block");
  }

  @override
  Widget build(BuildContext context) {
    final qualifiedTierName = widget.qualifiedTier.name?.replaceAll("Customers ", "");

    return BottomSheets.makeAppBottomSheet(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_settings.svg',
        centerImageColor: Colors.primaryColor,
        centerBackgroundPadding: 12,
        centerImageHeight: 42,
        centerImageWidth: 42,
        content: Wrap(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(height: 16,),
                  Center(
                    child: Text('Settings',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.colorPrimaryDark)),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 16, right: 16),
                    padding: EdgeInsets.only(top: 7, bottom: 7),
                    decoration: BoxDecoration(
                      color: Colors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Center(
                      child: Text('Account Tier: $qualifiedTierName', style: TextStyle(color: Colors.colorPrimaryDark, fontFamily: Styles.defaultFont),)
                          .colorText({"$qualifiedTierName": Tuple(Colors.colorPrimaryDark, null)}, underline: false),
                    )
                  ),
                  SizedBox(height: 21),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _blockAccount,
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.withOpacity(0.1)
                          ),
                          child: SvgPicture.asset('res/drawables/ic_block.svg'),
                        ),
                        title: Text(
                            'Block Account',
                            style: TextStyle(color: Colors.colorPrimaryDark)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            )
          ],
        )
    );
  }

}