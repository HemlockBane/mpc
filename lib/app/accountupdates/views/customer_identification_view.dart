import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';


class CustomerIdentificationScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CustomerIdentificationScreen();
  }

}

class _CustomerIdentificationScreen extends State<CustomerIdentificationScreen>  with AutomaticKeepAliveClientMixin{

  Map<String, Tuple<Color, VoidCallback?>> getColoredTier() {
    return {
      "Tier 2": Tuple(Colors.primaryColor, null),
      "Tier 3": Tuple(Colors.primaryColor, null),
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Styles.buildDropDown(identificationTypes, AsyncSnapshot.withData(ConnectionState.active, identificationTypes.first), (value, i) { }),
            SizedBox(height: 16),
            Styles.appEditText(hint: 'ID Number', fontSize: 15),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: Styles.appEditText(
                    hint: 'Issue Date',
                    readOnly: true,
                    startIcon: Icon(CustomFont.calendar, color: Colors.colorFaded),
                    fontSize: 15
                )),
                SizedBox(width: 16),
                Expanded(child: Styles.appEditText(
                    hint: 'Expiry Date',
                    readOnly: true,
                    startIcon: Icon(CustomFont.calendar, color: Colors.colorFaded),
                    fontSize: 15
                )),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3.4),
                  border: Border.all(color: Colors.colorFaded, width: 0.5)
              ),
              child: Row(
                children: [
                  SvgPicture.asset('res/drawables/ic_file.svg', width: 26, height: 26,),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload International Passport',
                        style: TextStyle(color: Colors.textColorBlack, fontSize: 15, fontWeight: FontWeight.bold),),
                      SizedBox(height: 1),
                      Text('Required for Tier 2,  Tier 3', style: TextStyle(color: Colors.deepGrey, fontFamily: Styles.defaultFont, fontSize: 12),)
                          .colorText(getColoredTier()),
                    ],
                  ),
                  SizedBox(width: 8),
                  Spacer(),
                  TextButton(
                    onPressed: ()=>null,
                    child: Text('UPLOAD',  style: TextStyle(color: Colors.primaryColor, fontWeight: FontWeight.bold))
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
                'File should not be larger than 2MB',
                style: TextStyle(color: Colors.colorFaded, fontSize: 14),
            ),
            SizedBox(height: 32),
            Expanded(child: Row(
              children: [
                Flexible(child: Container()),
                Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: double.infinity,
                        child: Styles.appButton(onClick: ()=>null, text: 'Next'),
                      ),
                    )
                )
              ],
            )),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}