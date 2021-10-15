import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/dashboard/views/savings_views/savings_enable_flex_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';

class SavingsGetStartedView extends StatelessWidget {
  const SavingsGetStartedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    //TODO: Test this on iOS
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3.2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: Colors.solidGreen),
          title: Text('Get Started',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.textColorBlack)),
          backgroundColor: Colors.backgroundWhite,
          elevation: 0),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 21),
        child: ListView(
          children: [
            SizedBox(height: 30),
            Text(
              "What would you like\n to save for?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 23),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 23,
              mainAxisSpacing: 23,
              childAspectRatio: itemWidth / itemHeight,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(savingsItems.length, (idx) {
                final savingsItemData = savingsItems[idx];
                return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => SavingsEnableFlexView()));
                    },
                    child: SavingsItem(
                      savingsItemData: savingsItemData,
                    ));
              }),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class SavingsItem extends StatelessWidget {
  const SavingsItem({Key? key, required this.savingsItemData})
      : super(key: key);

  final SavingsItemData savingsItemData;

  @override
  Widget build(BuildContext context) {
    print("title: ${savingsItemData.color}");
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 1),
                color: Color(0xff0E4FB1).withOpacity(0.12),
                blurRadius: 2.0)
          ]),
      child: Column(
        children: [
          SizedBox(height: 28),
          Container(
            // color: Colors.red,
            child: Stack(
              children: [
                Align(
                    child: SvgPicture.asset(
                  "res/drawables/ic_savings_icon_bg.svg",
                  color: savingsItemData.color.withOpacity(0.9),
                )),
                Positioned.fill(
                  child: Align(
                    child: Container(
                        // color: Colors.solidGreen,
                        child: SvgPicture.asset(
                      savingsItemData.svgPath,
                      height: savingsItemData.iconSize.height,
                      width: savingsItemData.iconSize.width,
                    )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 21),
          Text(
            savingsItemData.title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.8,
                color: Colors.textColorBlack),
          ),
          SizedBox(height: 6),
          Text(
            'Interest: ${savingsItemData.interestRate}% p/a',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.8,
                color: Colors.textColorBlack.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}

class SavingsItemData {
  String svgPath;
  Size iconSize;
  String title;
  int interestRate;
  Color color;

  SavingsItemData(
      {required this.svgPath,
      required this.title,
      required this.interestRate,
      required this.color,
      required this.iconSize});
}

//TODO: Update the SVG paths and the titles
final savingsItems = [
  SavingsItemData(
      svgPath: "res/drawables/ic_savings_flex.svg",
      title: "Flex",
      interestRate: 5,
      color: Color(0xff1EB12D),
      iconSize: Size(36, 45)),
  SavingsItemData(
      svgPath: "res/drawables/ic_savings_safelock.svg",
      title: "Safelock",
      interestRate: 2,
      color: Color(0xff9B51E0),
      iconSize: Size(36.16, 35.37)),
  SavingsItemData(
      svgPath: "res/drawables/ic_savings_school_fees.svg",
      title: "School Fees",
      interestRate: 2,
      color: Color(0xffE05196),
      iconSize: Size(39.45, 24.13)),
  SavingsItemData(
      svgPath: "res/drawables/ic_savings_rent.svg",
      title: "Rent",
      interestRate: 2,
      color: Color(0xff1EB12D),
      iconSize: Size(49.13, 30)),
  SavingsItemData(
      svgPath: "res/drawables/ic_savings_travel.svg",
      title: "Travel",
      interestRate: 5,
      color: Color(0xff51ADE0),
      iconSize: Size(42.9, 35.31)),
  SavingsItemData(
      svgPath: "res/drawables/ic_savings_property.svg",
      title: "Buy Property",
      interestRate: 2,
      color: Color(0xff9B51E0),
      iconSize: Size(33.73, 28.08)),
  SavingsItemData(
      svgPath: "res/drawables/ic_savings_start_business.svg",
      title: "Start a Business",
      interestRate: 2,
      color: Color(0xff1EB12D),
      iconSize: Size(34.55, 30))
];
