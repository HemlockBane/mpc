import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_bottom_menu.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_menu_item.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:provider/provider.dart';

import 'dashboard_top_menu.dart';

class SavingsView extends StatelessWidget {
  const SavingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height =  MediaQuery.of(context).size.height - bottomAppBarHeight;
    final width = MediaQuery.of(context).size.width;
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
                child: LayoutBuilder(
                  builder: (ctx, constraints){
                    return Stack(
                      children: [
                        Align(
                          child: Container(
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
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    color: Color(0xff4F577A5A),
                                  ),
                                  child: Text("Coming Soon", textAlign: TextAlign.center,
                                    style: TextStyle(color: Color(0xff698C6C), fontSize: 16, fontWeight: FontWeight.w500
                                    )),),
                                SizedBox(height: 30,),

                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: (constraints.maxHeight/2.5) - 110,
                          left: constraints.maxWidth/4.2,
                          child: Container(
                            // color: Colors.red,
                            child: Image.asset("res/drawables/ic_savings_target.png", height: 165, width: 165,)),
                        ),
                      ],
                    );

                  },
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
