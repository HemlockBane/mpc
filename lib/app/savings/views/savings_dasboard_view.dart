import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/savings/model/data/total_savings_balance.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/views/flex_dashboard_balance_loading_shimmer.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/views/savings_flex_list_view.dart';
import 'package:moniepoint_flutter/app/savings/viewmodels/savings_dashboard_viewmodel.dart';
import 'package:moniepoint_flutter/app/savings/views/savings_product_item_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:provider/provider.dart';

import '../../dashboard/views/dashboard_top_menu.dart';


class SavingsDashboardView extends StatefulWidget  {
  static const SAVINGS_DASHBOARD  = "SAVINGS_DASHBOARD";
  static const SAFE_LOCK = "SAFE_LOCK";
  static const TARGET = "TARGET";

  SavingsDashboardView({
    Key? key,
  }) : super(key: key);


  @override
  State<StatefulWidget> createState() => _SavingsDashboardState();

}

class _SavingsDashboardState extends State<SavingsDashboardView> with AutomaticKeepAliveClientMixin{

  late final SavingsDashboardViewModel _viewModel;

  @override
  void initState() {
    _viewModel = SavingsDashboardViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return ComingSoonView(width: 100, height: 100);
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: _viewModel)],
      child: RefreshIndicator(
        displacement: 80,
        onRefresh: () async {
          _viewModel.update(DashboardState.REFRESHING);
          await for (var value in _viewModel.dashboardUpdateStream) {
            await Future.delayed(Duration(milliseconds: 100));
            if (value != DashboardState.DONE) return;
            return null;
          }
          return null;
        },
        child: Container(
          child: ListView(
            cacheExtent: 500000,
            children: [
              SizedBox(height: dashboardTopMenuHeight - 40),
              LayoutBuilder(builder: (ctx, constraints) {
                return Container(
                  width: constraints.maxWidth,
                  height: MediaQuery.of(context).size.height - 0,
                  color: Colors.transparent,
                  child: _SavingsDashboardMenu(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}

class _SavingsDashboardMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SavingsDashboardViewModel>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SavingsAccountCard(
          dashboardBalanceFn: () => viewModel.fetchAllSavingsBalance(),
          viewModel: viewModel,
        ),
        SizedBox(height: 29),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Text(
            "How would you like to save?",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
            child: GridView.builder(
                itemCount: 1,
                cacheExtent: 9991000,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 234,
                ),
                itemBuilder: (ctx, index) {
                  return SavingsProductItemView(
                      productType: SavingsProductType.FLEX,
                      viewModel: viewModel
                  );
                }))
      ],
    );
  }

}

///SavingsAccountCard
///
///
class SavingsAccountCard extends StatefulWidget {
  const SavingsAccountCard({
    Key? key,
    required this.viewModel,
    required this.dashboardBalanceFn
  }) : super(key: key);

  final SavingsDashboardViewModel viewModel;
  final Stream<Resource<TotalSavingsBalance>> Function() dashboardBalanceFn;

  @override
  State<StatefulWidget> createState() => _SavingAccountCardState();

}

class _SavingAccountCardState extends  State<SavingsAccountCard> {

  Stream<Resource<TotalSavingsBalance>> _savingsBalanceStream = Stream.empty();

  @override
  void initState() {
    _savingsBalanceStream = widget.dashboardBalanceFn.call();
    super.initState();
    widget.viewModel.dashboardUpdateStream.listen((event) {
      if(event == DashboardState.REFRESHING) {
        _savingsBalanceStream = widget.dashboardBalanceFn.call();
        if (mounted) setState(() {});
      }
    });
  }

  Widget _getAccountBalance(AsyncSnapshot<Resource<TotalSavingsBalance>> snap) {
    if (snap.data is Loading || snap.hasData == false) {
      return FlexDashboardBalanceLoadingShimmer(isLoading: true,);
    } else if (snap.data is Error<TotalSavingsBalance>) {
      return Row(
        children: [
          Text(
            "Error Loading Balance",
            style: TextStyle(
                color: Colors.textColorBlack,
                fontWeight: FontWeight.w800,
                fontSize: 16.5
            ),
          )
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Savings",
              style: TextStyle(
                  color: Colors.textColorBlack.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5
              ),
            ),
            SizedBox(height: 4),
            Text(
              "${snap.data?.data?.totalSavingBalance?.formatCurrency ?? "--"}",
              style: TextStyle(
                  color: Colors.textColorBlack,
                  fontWeight: FontWeight.w800,
                  fontSize: 23.5
              ),
            ),
          ],
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 20.02, vertical: 34),
      decoration: BoxDecoration(
          color: Color(0XFF737E74).withOpacity(0.08),
          borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: StreamBuilder(
          stream: _savingsBalanceStream,
          builder: (ctx, AsyncSnapshot<Resource<TotalSavingsBalance>> snap) {
            return _getAccountBalance(snap);
          }
      ),
    );
  }

}


///ComingSoonView
///
///
// class ComingSoonView extends StatelessWidget {
//   const ComingSoonView({
//     Key? key,
//     required this.width,
//     required this.height,
//   }) : super(key: key);
//
//   final double width;
//   final double height;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       width: width,
//       color: Color(0XFFF0FAEB),
//       child: Container(
//         height: height,
//         margin: EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           children: [
//             SizedBox(height: dashboardTopMenuHeight),
//             Expanded(
//               child: Container(
//                 // color: Colors.red,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     LayoutBuilder(
//                       builder: (ctx, constraints){
//                         return Container(
//                           // color: Colors.backgroundTwo,
//                           child: Stack(
//                             overflow: Overflow.visible,
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 26),
//                                 decoration: BoxDecoration(
//                                   color: Color(0xFF1EB12D).withOpacity(0.1),
//                                   borderRadius: BorderRadius.all(Radius.circular(17.8)),
//                                   boxShadow: [
//                                     BoxShadow(color: Color(0xff1F0E4FB).withOpacity(0.12), offset: Offset(0, 1.12), blurRadius: 2.23)
//                                   ]
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SizedBox(height: 90,),
//                                     Text('A better way\nto save money', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF1EB12D), fontWeight: FontWeight.w700, fontSize: 19.5),),
//                                     SizedBox(height: 11,),
//                                     Text('Save money with Moniepoint\n and hit your goals & targets', style: TextStyle(color: Colors.textColorBlack, fontWeight: FontWeight.w500, fontSize: 14),),
//                                     SizedBox(height: 11,),
//                                     GestureDetector(
//                                       onTap: null,
//                                       child: Container(
//                                         padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.all(Radius.circular(4.0)),
//                                           color: Color(0xff4F577A5A),
//                                         ),
//                                         child: Text("Coming Soon", textAlign: TextAlign.center,
//                                           style: TextStyle(color: Color(0xff698C6C), fontSize: 16, fontWeight: FontWeight.w500
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: 30,),
//
//                                   ],
//                                 ),
//                               ),
//                               Positioned(
//                                 top: -51, left: 0, right: 10,
//                                 child: Container(
//                                   // color: Colors.black,
//                                   child: Image.asset("res/drawables/ic_savings_target.png", height: 165, width: 165,)),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 )
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
