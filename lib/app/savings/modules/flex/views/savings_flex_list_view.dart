import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/app/savings/viewmodels/savings_dashboard_viewmodel.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/icon_curved_container.dart';
import 'package:moniepoint_flutter/main.dart';
import 'package:provider/provider.dart';

///@author Paul Okeke
///
class SavingsFlexListView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SavingsFlexListViewState();
}

class _SavingsFlexListViewState extends State<SavingsFlexListView> with TickerProviderStateMixin{

  late final SavingsDashboardViewModel _viewModel;
  late final AnimationController _animationController;
  final List<FlexSaving> _currentItems = [];


  @override
  void initState() {
    _viewModel = Provider.of<SavingsDashboardViewModel>(context, listen: false);
    this._animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000)
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _viewModel.getFlexSavings(),
        builder: (ctx, AsyncSnapshot<Resource<List<FlexSaving>>> snapshot) {
          return Stack(children: [
            ListViewUtil.makeListViewWithState(
              displayLocalData: true,
              context: context,
              snapshot: snapshot,
              animationController: _animationController,
              currentList: _currentItems,
              listView: (List<FlexSaving>? items) {
                return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items!.length,
                    itemBuilder: (ctx, int index) {
                      return FlexSavingListItem(flexSaving: items[index], position: index);
                    }
                );
              },
            ),
            Positioned(
              right: 18,
              bottom: 100,
              child: FloatingActionButton(
                backgroundColor: Colors.solidOrange,
                onPressed: () {
                  navigatorKey.currentState?.pushNamed(
                      Routes.SAVINGS_FLEX_ENABLE,
                      arguments: {"product": _viewModel.getFlexSavingsProduct()}
                  );
                },
                child: Text("+", style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: Colors.white
                ),),
              ),
            )
          ],);
        }
    );
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

    if(flexSaving.configCreated == false || flexSaving.flexSavingConfig == null) {
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
              SizedBox(width: 12,),
              Expanded(
                  child: Text(
                    "Flex Savings ${position + 1}",
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
            interest: flexSaving.flexSavingScheme?.interestRate ?? 0.0,
            totalSavings: 0.0,
          ),
          SizedBox(height: 13,),
          _AccountNumberView(
            accountNumber: flexSaving.cbaAccountNuban ?? "",
            onView: () {
              print("Config Created ===> ${flexSaving.configCreated}");
              if(flexSaving.configCreated == false) {
                navigatorKey.currentState?.pushNamed(
                    Routes.SAVINGS_FLEX_SETUP,
                  arguments: {"flexSavingId" : flexSaving.id}
                );
              }
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
class _InterestAndTotalSavingsView extends StatelessWidget{

  _InterestAndTotalSavingsView({
    required this.interest,
    required this.totalSavings
  });

  final num interest;
  final num totalSavings;
  
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