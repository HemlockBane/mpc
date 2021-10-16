import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_menu_item.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:share/share.dart';

class SavingsFlexHomeView extends StatefulWidget {
  const SavingsFlexHomeView({Key? key}) : super(key: key);

  @override
  _SavingsFlexHomeViewState createState() => _SavingsFlexHomeViewState();
}

class _SavingsFlexHomeViewState extends State<SavingsFlexHomeView> {


  void onItemClick(String routeName, int position){
    Navigator.of(context).pushNamed(routeName);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  "Flex Savings",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 12),
                SavingsCard(),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DashboardMenuItem(
                      itemName: "Withdraw",
                      onItemClick: onItemClick,
                      itemIcon: SvgPicture.asset(
                        "res/drawables/ic_savings_flex_withdraw.svg",
                        width: 33,
                        height: 34,
                        color: Colors.solidGreen,
                      ),
                      routeName: Routes.SAVINGS_FLEX_WITHDRAW,
                      circleBackgroundColor: Colors.solidGreen.withOpacity(0.1),
                    ),
                    DashboardMenuItem(
                      itemName: "Top up",
                      onItemClick: onItemClick,
                      itemIcon: SvgPicture.asset(
                        "res/drawables/ic_savings_flex_top_up.svg",
                        width: 33,
                        height: 34,
                        color: Colors.solidGreen,
                      ),
                      routeName: Routes.SAVINGS_FLEX_TOP_UP,
                      circleBackgroundColor: Colors.solidGreen.withOpacity(0.1),
                    ),
                    DashboardMenuItem(
                      itemName: "Settings",
                      onItemClick: onItemClick,
                      itemIcon: SvgPicture.asset(
                        "res/drawables/ic_more_settings.svg",
                        width: 28,
                        height: 22,
                        color: Colors.solidGreen,
                      ),
                      routeName: Routes.SAVINGS_FLEX_SETTINGS,
                      circleBackgroundColor: Colors.solidGreen.withOpacity(0.1),
                    ),

                  ],
                )
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.8,
            builder: (ctx, controller){
             return Container(
               child: Stack(
                 children: [
                   ListView(
                     controller: controller,
                     shrinkWrap: true,
                     children: [
                       for (var i = 0; i < 200; i++)
                         ListTile(title: Text(i.toString()),)

                     ],
                   ),
                   IgnorePointer(
                     child: Container(
                       height: 61,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.vertical(
                           top: Radius.circular(22),
                         ),
                       ),
                     ),
                   ),
                   Positioned(
                     top: 26, left: 20, right: 0,
                     child: Text("Savings History",
                       style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700,))
                   ),
                   Positioned(
                     top: 61, left: 0, right: 0,
                     child: Divider(
                       height: 0.8,
                       thickness: 0.4,
                       color: Colors.black.withOpacity(0.1),
                     )
                   )
                 ],
               ),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.vertical(
                   top: Radius.circular(22),
                 ),
                 border: Border.all(
                   width: 1.0,
                   color: Color(0xff063A4F0D).withOpacity(0.05)),

               ),
             );
            }
          )
        ],
      ),
    );
  }
}



class SavingsCard extends StatelessWidget {
  SavingsCard({Key? key}) : super(key: key);

  void _shareReceipt() {
    // Share.share(
    //   "Moniepoint MFB\n$accountNumber\n$accountName",
    //   subject: 'Moniepoint MFB');
  }


  final accountStyle = TextStyle(
    color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600
  );

  @override
  Widget build(BuildContext context) {
    return             Container(
      padding: EdgeInsets.symmetric(vertical: 21),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Savings",
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600, fontSize: 12.5),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SvgPicture.asset(
                      "res/drawables/ic_naira.svg",
                      width: 20,
                      height: 17,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4,),
                    Text("200,394.00",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 23.5),

                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Divider(color: Colors.white.withOpacity(0.5),),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Account Number", style: accountStyle,),
                    SizedBox(width: 4),
                    Text("0011357716", style: accountStyle.copyWith(fontWeight: FontWeight.w700),)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Styles.imageButton(
                    padding: EdgeInsets.all(9),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    onClick: _shareReceipt,
                    image: SvgPicture.asset(
                      'res/drawables/ic_share.svg',
                      fit: BoxFit.contain,
                      width: 20,
                      height: 21,
                      color: Colors.white.withOpacity(0.31),
                    ),
                  )),
              ],
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.solidGreen,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 13),
            blurRadius: 21,
            color: Color(0xff0EB11E).withOpacity(0.3)
          )
        ]
      ),
    );
  }
}
