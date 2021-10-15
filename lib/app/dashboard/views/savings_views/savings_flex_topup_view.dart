import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/dashboard/views/savings_views/savings_enable_flex_view.dart';
import 'package:moniepoint_flutter/app/dashboard/views/savings_views/savings_success_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/amount_pill.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:collection/collection.dart';

class SavingsFlexTopupView extends StatefulWidget {
  const SavingsFlexTopupView({Key? key}) : super(key: key);

  @override
  _SavingsFlexTopupViewState createState() => _SavingsFlexTopupViewState();
}

class _SavingsFlexTopupViewState extends State<SavingsFlexTopupView> {
  double _amount = 0.00;
  ListDataItem<String>? _selectedAmountPill;
  final List<ListDataItem<String>> amountPills = List.generate(4, (index) => ListDataItem((5000 * (index + 1)).formatCurrencyWithoutLeadingZero));

  TextStyle getBoldStyle(
    {double fontSize = 32.5,
      Color color = Colors.textColorBlack,
      FontWeight fontWeight = FontWeight.w700}) =>
    TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);



  List<Widget> generateAmountPillsWidget() {
    final pills = <Widget>[];
    amountPills.forEachIndexed((index, element) {
      pills.add(
        Expanded(
          flex: 1,
          child: AmountPill(
            item: element, position: index, primaryColor: Colors.solidGreen,
            listener: (ListDataItem<String> item, position){
              setState(() {
                _selectedAmountPill?.isSelected = false;
                _selectedAmountPill = item;
                _selectedAmountPill?.isSelected = true;
                this._amount = double.parse(_selectedAmountPill!.item.replaceAll(RegExp(r'[(a-z)|(A-Z)|(,₦)]'), ""));
              });
      })));
      if(index != amountPills.length -1) pills.add(SizedBox(width: 8,));
    });
    return pills;
  }

  Widget initialView() {
    return  Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          "res/drawables/ic_m_bg.svg",
          fit: BoxFit.cover,
          height: 45,
          width: 45,
          color: Colors.solidGreen.withOpacity(0.11),
        ),
        Container(
          height: 45,
          width: 45,
          child: Material(
            borderRadius: BorderRadius.circular(17),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(17),
              overlayColor: MaterialStateProperty.all(Colors.solidGreen.withOpacity(0.1)),
              highlightColor: Colors.solidGreen.withOpacity(0.05),
              // onTap: () => _onItemClicked(context, beneficiary),
              child: Center(
                child: Text("LI",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.solidGreen
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 21),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              "Top up Flex Savings",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 26),
            Text(
              "How much would you like to save?",
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            ),

            SizedBox(height: 13),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 26 ),
              decoration: BoxDecoration(
                color: Color(0xffA5C097).withOpacity(0.15),
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: PaymentAmountView((_amount * 100).toInt(), (value){},
                currencyColor: Color(0xffC1C2C5).withOpacity(0.5),
                textColor: Colors.textColorBlack,
                ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: generateAmountPillsWidget(),
            ),
            SizedBox(height: 26),
            Text(
              "Top up from?",
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.only(left: 11.87, right: 19.23, top: 14.25, bottom: 14.17),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  initialView(),
                  SizedBox(width: 17,),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Leslie Tobechukwu Isah',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 15, color: Colors.textColorBlack, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 1,),
                        Row(
                          children: [
                            Text(
                              '0011357716',
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.textColorBlack.withOpacity(0.5), fontSize: 13),
                            ),
                            SizedBox(width: 8,),
                            Text(
                              '₦ 120,459.00',
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.textColorBlack.withOpacity(0.5), fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ],
                    )
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Change',
                      style: TextStyle(color: Colors.solidGreen, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(40, 0)),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      overlayColor: MaterialStateProperty.all(Colors.solidGreen.withOpacity(0.2)),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 8, vertical: 7)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent)
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 1,
                    color: Color(0xff0649AF).withOpacity(0.1)
                  )
                ]
              ),
            ),
            Spacer(),
            Styles.statefulButton(
              buttonStyle: Styles.primaryButtonStyle.copyWith(
                backgroundColor:
                MaterialStateProperty.all(Colors.solidGreen),
                textStyle: MaterialStateProperty.all(getBoldStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.white))),
              stream: Stream.value(true),
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => SavingsSucessView(
                      primaryText: "Top up Successful!",
                      secondaryText: loremIpsum,
                      primaryButtonText: "Continue",
                      primaryButtonAction: () {
                      },
                    ),
                  ),
                );
              },
              text: 'Top Up'),
            SizedBox(height: 18,),
          ],
        ),
      ),
    );
  }
}
