import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/scheduler.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_product_status.dart';
import 'package:moniepoint_flutter/app/loans/viewmodels/loans_home_viewmodel.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/loan_product_card.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/empty_list_layout_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

import '../../dashboard/views/dashboard_top_menu.dart';

class LoansHomeView extends StatefulWidget {
  const LoansHomeView({Key? key}) : super(key: key);

  @override
  State<LoansHomeView> createState() => _LoansHomeViewState();
}

class _LoansHomeViewState extends State<LoansHomeView> with TickerProviderStateMixin{

  late final LoansHomeViewModel _loansHomeViewModel;
  late final AnimationController _animationController;
  final List<dynamic> _currentItems = [];

  TextStyle getBoldStyle({
    double fontSize = 24.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) => TextStyle(
    fontWeight: fontWeight,
    fontSize: fontSize,
    color: color,
  );

  Widget makeListView(BuildContext context, AsyncSnapshot<Resource<List<dynamic>?>> snapshot){
    return ListViewUtil.makeListViewWithState(
      context: context,
      animationController: _animationController,
      displayLocalData: false,
      currentList: _currentItems,
      snapshot: snapshot,
      emptyPlaceholder: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyLayoutView(
            "There are currently no loan products."
          )
        ],
      ),

      listView: (List<dynamic>? items){
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: items?.length ?? 0,
          itemBuilder: (ctx, idx){
            final item = items![idx];
            var listItem;

            if(item is ShortTermLoanProductStatus){
              listItem = Container(
                margin: EdgeInsets.only(bottom: 20),
                child: ShortTermLoanCard(product: item),
              );
            }else{
              // Handle salary advance loan here
            }
            return listItem;
          });
      },

    );

  }

  @override
  void initState() {
   _loansHomeViewModel =  Provider.of<LoansHomeViewModel>(context, listen: false);
   _animationController = AnimationController(
     vsync: this, duration: Duration(milliseconds: 1000)
   );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoansComingSoonView();
    return SessionedWidget(
      context: context,
      child: Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StreamBuilder(
            stream: _loansHomeViewModel.getLoanProducts(),
            builder: (ctx, AsyncSnapshot<Resource<List<dynamic>?>> snapshot){
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: dashboardTopMenuHeight + 43),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Loan Product", style: getBoldStyle()),
                        Text("History", style: getBoldStyle(fontSize: 13.5, color: Colors.solidOrange)),
                      ],
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: SingleChildScrollView(
                        child: makeListView(context, snapshot),
                      ),
                    )
                  ],
                ),
              );
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
