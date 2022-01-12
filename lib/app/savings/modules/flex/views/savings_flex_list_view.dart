import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/savings/model/data/savings_product.dart';
import 'package:moniepoint_flutter/app/savings/model/data/total_savings_balance.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/flex_savings_list_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/icon_curved_container.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/main.dart';
import 'package:provider/provider.dart';

import 'flex_dashboard_balance_loading_shimmer.dart';

///@author Paul Okeke
///
class SavingsFlexListView extends StatefulWidget {

  SavingsFlexListView({
    required this.savingProduct
  });

  final SavingsProduct savingProduct;

  @override
  State<StatefulWidget> createState() => _SavingsFlexListViewState();
}

class _SavingsFlexListViewState extends State<SavingsFlexListView> with TickerProviderStateMixin{

  late final FlexSavingsListViewModel _viewModel;
  late final AnimationController _animationController;
  final List<FlexSaving> _currentItems = [];
  Stream<Resource<List<FlexSaving>>> _flexSavingStream = Stream.empty();


  @override
  void initState() {
    _viewModel = Provider.of<FlexSavingsListViewModel>(context, listen: false);
    _viewModel.setSavingsProduct(widget.savingProduct);
    _flexSavingStream = _viewModel.getFlexSavings();

    this._animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000)
    );
    super.initState();
  }

  Widget _makeListView() => StreamBuilder(
          stream: _flexSavingStream,
          builder: (ctx, AsyncSnapshot<Resource<List<FlexSaving>>> snapshot) {
            return Stack(children: [
              ListViewUtil.makeListViewWithState(
                displayLocalData: true,
                context: context,
                snapshot: snapshot,
                animationController: _animationController,
                currentList: _currentItems,
                listView: (List<FlexSaving>? items) {
                  return ListView.separated(
                    padding: EdgeInsets.only(bottom: 32),
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: EdgeInsets.only(top: 6.5, bottom: 6.5));
                    },
                    itemCount: items!.length,
                    itemBuilder: (ctx, int index) {
                      return FlexSavingListItem(
                          flexSaving: items[index],
                          position: index
                      );
                    },
                  );
                },
              ),
              Positioned(
                right: 18,
                bottom: 62,
                child: FloatingActionButton(
                  backgroundColor: Colors.solidOrange,
                  onPressed: () {
                    navigatorKey.currentState?.pushNamed(
                        Routes.SAVINGS_FLEX_ENABLE,
                        arguments: {"product": _viewModel.flexSavingsProduct}
                    ).then((value) {
                      print("We Are back !!!");
                    });
                  },
                  child: Text("+", style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: Colors.white
                  )),
                ),
              )
            ],);
          }
      );

  @override
  Widget build(BuildContext context) {
    return SessionedWidget(
      context: context,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: false,
            titleSpacing: 0,
            iconTheme: IconThemeData(color: Colors.solidGreen),
            title: Text(
                'Flex Savings',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.textColorBlack
                )
            ),
            backgroundColor: Color(0XFFF5F5F5).withOpacity(0.7),
            elevation: 0
        ),
        body: Container(
          color: Color(0XFFF5F5F5).withOpacity(0.7),
          child: Column(
            children: [
              SizedBox(height: 22,),
              FlexSavingsAccountCard(dashboardBalanceFn: () => _viewModel.fetchAllSavingsBalance()),
              SizedBox(height: 22,),
              Expanded(child:  _makeListView())
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

///FlexSavingListItem
///
///
class FlexSavingListItem extends StatelessWidget {

  FlexSavingListItem({
    required this.flexSaving,
    required this.position,
  });

  final FlexSaving flexSaving;
  final int position;

  Widget _statusView() {
    String status = "Active";
    Color bgColor = Colors.savingsPrimary.withOpacity(0.15);
    Color textColor = Colors.savingsPrimary;

    if(flexSaving.configCreated == false) {
      status = "Pending Setup";
      bgColor = Color(0XFF9BA6B9).withOpacity(0.15);
      textColor = Color(0XFF9BA6B9);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: bgColor.withOpacity(0.14),
          borderRadius: BorderRadius.circular(4)
      ),
      child: Center(
        child: Text(
          status,
          style: TextStyle(
              fontSize: 10,
              color: textColor,
              fontWeight: FontWeight.w700
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      margin: EdgeInsets.only(left: 20, right: 20),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0XFFB1881E).withOpacity(0.1), width: 0.7),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Color(0XFF165B1D).withOpacity(0.14)
          )
        ]
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 16,),
              IconCurvedContainer(
                  backgroundColor: Colors.savingsPrimary.withOpacity(0.1),
                  child: SvgPicture.asset("res/drawables/ic_savings_flex_2.svg", width: 24, height: 30,)
              ),
              SizedBox(width: 12),
              Expanded(
                  child: Text(
                    "${flexSaving.name ?? "--"}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.textColorBlack
                    ),
                  )
              ),
              _statusView(),
              SizedBox(width: 16,),
            ],
          ),
          SizedBox(height: 9,),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Divider(color: Color(0XFF966C2E).withOpacity(0.12), height: 0.8,),
          ),
          SizedBox(height: 16,),
          _InterestAndTotalSavingsView(
            interest: flexSaving.flexSavingInterestProfile?.interestRate ?? 0.0,
            totalSavings: flexSaving.accountBalance?.availableBalance ?? 0.0,
          ),
          SizedBox(height: 13,),
          _AccountNumberView(
            accountNumber: flexSaving.cbaAccountNuban ?? "",
            onView: () {
              navigatorKey.currentState?.pushNamed(
                  Routes.SAVINGS_FLEX_DASHBOARD,
                  arguments: {"flexSavingId" : flexSaving.id}
              ).then((value) {
                print("Sometimes we are faced with greater problems!!!");
              });
            },
          )
        ],
      ),
    );
  }

}

///_AccountNumberView
///
///
///
class _AccountNumberView extends StatelessWidget {

  _AccountNumberView({
    required this.accountNumber,
    this.onView
  });

  final String accountNumber;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 18, right: 18, top: 13, bottom: 17),
      decoration: BoxDecoration(
        color: Colors.savingsPrimary.withOpacity(0.1),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 13, right: 8, top: 0, bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.savingsPrimary.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Account Number  $accountNumber",
              style: TextStyle(
                  color: Colors.textColorBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: 12
              ),
            ).colorText({"$accountNumber" : Tuple(Colors.textColorBlack, null)}, underline: false),
            TextButton(
                onPressed: this.onView,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(10, 0)),
                  padding: MaterialStateProperty.all(EdgeInsets.only(top: 10, bottom: 10, left: 6, right: 6)),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  overlayColor: MaterialStateProperty.all(Colors.savingsPrimary.withOpacity(0.2)),
                ),
                child: Text(
                  "View",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.savingsPrimary,
                    fontWeight: FontWeight.w600
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

}

///_InterestAndTotalSavingsView
///
///
///
class _InterestAndTotalSavingsView extends StatelessWidget {

  _InterestAndTotalSavingsView({
    required this.interest,
    required this.totalSavings
  });

  final num interest;
  final double totalSavings;
  
  Widget _label(String value) {
    return Text(
      value,
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.dividerColor2
      ),
    );
  }

  Widget _value(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        overflow: TextOverflow.ellipsis,
        color: Colors.textColorBlack
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Interest p.a"),
            SizedBox(height: 4,),
            _value("$interest%")
          ],
        ),
        SizedBox(width: 27),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Total Savings"),
            SizedBox(height: 4,),
            _value("${totalSavings.formatCurrency}")
          ],
        ),
        SizedBox(width: 16),
      ],
    );
  }

}

class FlexSavingsAccountCard extends StatelessWidget {

  const FlexSavingsAccountCard({
    Key? key,
    required this.dashboardBalanceFn
  }) : super(key: key);

  final Stream<Resource<TotalSavingsBalance>> Function() dashboardBalanceFn;

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
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5
              ),
            ),
            SizedBox(height: 4),
            Text(
              "${snap.data?.data?.totalFlexSavingBalance?.formatCurrency ?? "--"}",
              style: TextStyle(
                  color: Colors.white,
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
            color: Colors.solidGreen,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 13),
                  blurRadius: 21,
                  color: Colors.savingsPrimaryShadow.withOpacity(0.2)
              )
            ]
        ),
        child: StreamBuilder(
            stream: dashboardBalanceFn.call(),
            builder: (ctx, AsyncSnapshot<Resource<TotalSavingsBalance>> snap) {
              return _getAccountBalance(snap);
            }
        ),
    );
  }
}
