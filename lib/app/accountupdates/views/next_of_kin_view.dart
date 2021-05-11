import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';

class NextOfKinScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _NextOfKinScreen();
  }

}

class _NextOfKinScreen extends State<NextOfKinScreen> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final states =  StateOfOrigin.fromJson({"name":"Lagos"});
    final localGovt =  LocalGovernmentArea.fromJson({"name":"Eti Osa"});
    return ScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Styles.appEditText(hint: 'First Name', fontSize: 15),
            SizedBox(height: 16),
            Styles.appEditText(hint: 'Middle Name', fontSize: 15),
            SizedBox(height: 16),
            Styles.appEditText(hint: 'Last Name', fontSize: 15),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Styles.buildDropDown(relationship, AsyncSnapshot.withData(ConnectionState.active, relationship.first), (value, i) { }),
                ),
                SizedBox(width: 16),
                Expanded(
                    child: Styles.appEditText(
                        hint: 'Date of Birth',
                        readOnly: true,
                        startIcon: Icon(CustomFont.calendar, color: Colors.colorFaded),
                        fontSize: 15
                    )
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: Styles.appEditText(
                      hint: 'House Number',
                      fontSize: 15
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                    flex: 2,
                    child: Styles.appEditText(
                        hint: 'Street Name',
                        fontSize: 15
                    )
                ),
              ],
            ),
            SizedBox(height: 16),
            Styles.appEditText(
                hint: 'City/Town',
                fontSize: 15
            ),
            SizedBox(height: 16),
            Styles.buildDropDown(List.generate(1, (index) => states), AsyncSnapshot.withData(ConnectionState.active, states), (value, i) { }),
            SizedBox(height: 16),
            Styles.buildDropDown(List.generate(1, (index) => localGovt), AsyncSnapshot.withData(ConnectionState.active, localGovt), (value, i) { }),
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