import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/savings/flex/views/savings_enable_flex_view.dart';
import 'package:moniepoint_flutter/app/savings/flex/views/savings_get_started_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';

import '../dashboard/views/dashboard_top_menu.dart';


const greenColor = Color(0xff0EB11E);

class SavingsView extends StatelessWidget {
  const SavingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.solidGreen,
        child: Icon(Icons.add, size: 37,),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => SavingsGetStartedView()));
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: dashboardTopMenuHeight - 40),
            SavingsAccountCard(),
            SizedBox(height: 29),
          ],
        ),
      ),
    );
  }

}

class SavingsAccountCard extends StatelessWidget {
  const SavingsAccountCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.02, vertical: 34),
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
            color: greenColor.withOpacity(0.2)
          )
        ]
      ),
    );
  }
}

class ComingSoonView extends StatelessWidget {
  const ComingSoonView({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: width,
      color: Color(0XFFF0FAEB),
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: dashboardTopMenuHeight),
            Expanded(
              child: Container(
                // color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LayoutBuilder(
                      builder: (ctx, constraints){
                        return Container(
                          // color: Colors.backgroundTwo,
                          child: Stack(
                            overflow: Overflow.visible,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 26),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1EB12D).withOpacity(0.1),
                                  borderRadius: BorderRadius.all(Radius.circular(17.8)),
                                  boxShadow: [
                                    BoxShadow(color: Color(0xff1F0E4FB).withOpacity(0.12), offset: Offset(0, 1.12), blurRadius: 2.23)
                                  ]
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 90,),
                                    Text('A better way\nto save money', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF1EB12D), fontWeight: FontWeight.w700, fontSize: 19.5),),
                                    SizedBox(height: 11,),
                                    Text('Save money with Moniepoint\n and hit your goals & targets', style: TextStyle(color: Colors.textColorBlack, fontWeight: FontWeight.w500, fontSize: 14),),
                                    SizedBox(height: 11,),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => SavingsGetStartedView()));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                          color: Color(0xff4F577A5A),
                                        ),
                                        child: Text("Coming Soon", textAlign: TextAlign.center,
                                          style: TextStyle(color: Color(0xff698C6C), fontSize: 16, fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30,),

                                  ],
                                ),
                              ),
                              Positioned(
                                top: -51, left: 0, right: 10,
                                child: Container(
                                  // color: Colors.black,
                                  child: Image.asset("res/drawables/ic_savings_target.png", height: 165, width: 165,)),
                              ),
                            ],
                          ),
                        );

                      },
                    ),
                  ],
                )
              ),
            ),
            // Spacer()

          ],
        ),
      ),
    );
  }
}
