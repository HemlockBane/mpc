import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';

class CustomerAddressScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CustomerAddressScreen();
  }

}

class _CustomerAddressScreen extends State<CustomerAddressScreen> with AutomaticKeepAliveClientMixin{
  final states =  StateOfOrigin.fromJson({"name":"Lagos"});
  final localGovt =  LocalGovernmentArea.fromJson({"name":"Eti Osa"});

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
            Styles.appEditText(hint: 'House Address', fontSize: 15),
            SizedBox(height: 16),
            Styles.appEditText(hint: 'City Town', fontSize: 15),
            SizedBox(height: 16),
            Styles.buildDropDown(List.generate(1, (index) => states), AsyncSnapshot.withData(ConnectionState.active, states), (value, i) { }),
            SizedBox(height: 16,),
            Styles.buildDropDown(List.generate(1, (index) => localGovt), AsyncSnapshot.withData(ConnectionState.active, localGovt), (value, i) { }),
            SizedBox(height: 16,),
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