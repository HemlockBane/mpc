import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_menu_item.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:provider/provider.dart';

import 'dashboard_top_menu.dart';

class LoansView extends StatelessWidget {
  const LoansView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    final height =  MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      color: Color(0XFFFAF5EB),
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            DashboardTopMenu(viewModel: viewModel, title: "Loans"),
            SizedBox(height: 22,),
            SizedBox(height: height/5,),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: 50, left: width/9.5,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Color(0xFFF08922).withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(17.8)),
                        boxShadow: [
                          BoxShadow(color: Color(0xff1F0E4FB).withOpacity(0.12), offset: Offset(0, 1.12), blurRadius: 2.23)
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 90),
                          Text('Quick Cash?\nLook no further', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFF08922), fontWeight: FontWeight.w700, fontSize: 19.5),),
                          SizedBox(height: 11,),
                          Text('Save money with Moniepoint\n and hit your goals & targets', style: TextStyle(color: Colors.textColorBlack, fontWeight: FontWeight.w500, fontSize: 14),),
                          SizedBox(height: 11,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              color: Color(0xff7A6A57).withOpacity(0.31),
                            ),
                            child: Text("Coming Soon", textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xff8C7E69), fontSize: 16, fontWeight: FontWeight.w500
                              )),),
                          SizedBox(height: 30,),

                        ],
                      ),
                    ),
                  ),
                  Align(alignment: Alignment(-0.13, -1.0),
                    child: Image.asset("res/drawables/ic_loans_calendar.png", height: 165, width: 165,))
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
