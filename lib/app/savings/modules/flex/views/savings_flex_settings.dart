import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';

class SavingsFlexSettingsView extends StatefulWidget {
  const SavingsFlexSettingsView({Key? key}) : super(key: key);

  @override
  _SavingsFlexSettingsViewState createState() => _SavingsFlexSettingsViewState();
}

class _SavingsFlexSettingsViewState extends State<SavingsFlexSettingsView> {


  final boldStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.textColorBlack);
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: Colors.solidGreen),
        title: Text('General Savings',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.textColorBlack)),
        backgroundColor: Colors.backgroundWhite,
        elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              "Settings",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(vertical: 26),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text("Autosave", style: boldStyle),
                    subtitle: Text("Enabled", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: Colors.deepGrey)),
                    value: _isSelected,
                    onChanged: (value){
                      setState(() {
                        _isSelected = value;
                      });
                    },
                    activeColor: Colors.solidGreen,
                    inactiveThumbColor: Colors.white,
                  ),
                  Divider(thickness: 1, color: Color(0xffE8F0F6),),
                  ListTile(
                    title: Text("Flex Savings Settings", style: boldStyle,),
                    trailing: IconButton(
                      icon: Icon(Icons.chevron_right, color: Colors.solidGreen, size: 24,),
                      onPressed: () {
                      },
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: Color(0xff005709).withOpacity(0.14)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Color(0xff0E4FB1).withOpacity(0.12)
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
