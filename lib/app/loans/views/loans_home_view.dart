import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/scheduler.dart';
import 'package:moniepoint_flutter/app/loans/viewmodels/loans_home_viewmodel.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/loan_product_card.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

import '../../dashboard/views/dashboard_top_menu.dart';

class LoansHomeView extends StatefulWidget {
  const LoansHomeView({Key? key}) : super(key: key);

  @override
  State<LoansHomeView> createState() => _LoansHomeViewState();
}

class _LoansHomeViewState extends State<LoansHomeView> {
  late final LoansHomeViewModel _loansHomeViewModel;

  TextStyle getBoldStyle({
    double fontSize = 24.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
    TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);


  Widget _successView({required LoanProductStatus loanProductStatus}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: dashboardTopMenuHeight + 43),
        Text("Loan Product", style: getBoldStyle()),
        SizedBox(height: 30),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              if(loanProductStatus.shortTermLoanProductStatus != null)
                LoanProductCard(loanType: LoanType.shortTerm),
              if(loanProductStatus.shortTermLoanProductStatus != null)
                SizedBox(height: 23),
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
   _loansHomeViewModel =  Provider.of<LoansHomeViewModel>(context, listen: false);
   SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
     _loansHomeViewModel.getLoanProductStatus();
   });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return SessionedWidget(
      context: context,
      child: Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StreamBuilder(
            stream: _loansHomeViewModel.loanProductStatusStream,
            builder: (ctx, AsyncSnapshot<Resource<LoanProductStatus>> snapshot){


              if(!snapshot.hasData || snapshot.data is Loading){
                return Center(child: CircularProgressIndicator());
              }

              if(snapshot.data is Error){
                // Error view
              }

             final loanProductStatus = snapshot.data?.data;
             return  _successView(loanProductStatus: loanProductStatus!);


            },
          ),
        ),
      ),
    );
  }
}

class LoansComingSoonView extends StatelessWidget {
  const LoansComingSoonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; // - bottomAppBarHeight;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      color: Color(0XFFFAF5EB),
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: dashboardTopMenuHeight),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LayoutBuilder(
                    builder: (ctx, constraints) {
                      return Stack(
                        overflow: Overflow.visible,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                                color: Color(0xFFF08922).withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(17.8)),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Color(0xff1F0E4FB).withOpacity(0.12),
                                      offset: Offset(0, 1.12),
                                      blurRadius: 2.23)
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 90),
                                Text(
                                  'Quick Cash?\nLook no further',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFFF08922),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 19.5),
                                ),
                                SizedBox(
                                  height: 11,
                                ),
                                Text(
                                  'Get a loan in under 5 minutes with\nMoniepoint',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.textColorBlack,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 11,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 45, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    color: Color(0xff7A6A57).withOpacity(0.31),
                                  ),
                                  child: Text("Coming Soon",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff8C7E69),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -49,
                            left: 0,
                            right: 27,
                            child: Container(
                              child: Image.asset(
                                "res/drawables/ic_loans_calendar.png",
                                height: 165,
                                width: 165,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
