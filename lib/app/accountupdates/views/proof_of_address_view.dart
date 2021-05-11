import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

class ProofOfAddressScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProofOfAddressScreen();
  }
}

class _ProofOfAddressScreen extends State<ProofOfAddressScreen> with AutomaticKeepAliveClientMixin {

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
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.primaryColor.withOpacity(0.1)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('res/drawables/ic_info.svg', width: 28, height: 28,),
                  SizedBox(width: 9),
                  Text(
                    'Acceptable documents include:\n\u2022\t\tUtility Bills (e.g. electricity bills)\n\u2022\t\tTenancy Agreements\n\u2022\t\tResident Permits',
                    style: TextStyle(color: Colors.darkBlue, fontSize: 15, fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
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