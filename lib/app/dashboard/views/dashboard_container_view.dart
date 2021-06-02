import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

class DashboardContainerView extends StatefulWidget{

  final DashboardViewModel viewModel;

  DashboardContainerView(this.viewModel);

  @override
  State<StatefulWidget> createState() {
    return _DashboardContainerView();
  }

}

class _DashboardContainerView extends State<DashboardContainerView> with WidgetsBindingObserver {

  AppLifecycleState? _lifecycleState;
  bool isLoadingBalance = true;
  bool isLoadingBalanceError = false;

  void loadAccountBalance() {
    final viewModel = widget.viewModel;
    viewModel.getCustomerAccountBalance().listen((event) {
      if(event is Loading) setState(() {
        isLoadingBalance = true;
        isLoadingBalanceError = false;
      });
      if (event is Error<AccountBalance>) {
        setState(() {
          isLoadingBalance = false;
          isLoadingBalanceError = true;
        });
      }
      if(event is Success<AccountBalance>) {
        setState(() {
          isLoadingBalance = false;
          isLoadingBalanceError = false;
        });
      }
    });
  }

  Widget displayAccountBalance () {
    final bool hideAccountBalance = PreferenceUtil.getValueForLoggedInUser(PreferenceUtil.HIDE_ACCOUNT_BAL) ?? true;
    return StreamBuilder(
        stream: widget.viewModel.balanceStream,
        builder: (BuildContext ctx, AsyncSnapshot<AccountBalance?> snapshot) {
          if(snapshot.hasData && (!isLoadingBalance && !isLoadingBalanceError)) {
            final balance = hideAccountBalance ? "****" : "N ${snapshot.data?.availableBalance!.formatCurrencyWithoutSymbolAndDividing}";
            return Text("$balance",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28, fontFamily: Styles.defaultFont)
            ).colorText({"N": Tuple(Colors.white.withOpacity(0.3), null)}, underline: false);
          }
          if(isLoadingBalanceError && !hideAccountBalance) {
            return Padding(
                padding: EdgeInsets.only(right: 8, bottom: 8),
                child: Text("Error loading balance\nplease, try again",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.darkBlue, fontSize: 21, fontFamily: Styles.defaultFont)
                ).colorText({"try again": Tuple(Colors.white, loadAccountBalance)}, underline: false)
            );
          }
          if(hideAccountBalance) {
            return Text("* ***",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28, fontFamily: Styles.defaultFont)
            );
          }
          return Shimmer.fromColors(
              period: Duration(milliseconds: 1000),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                width: 90,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.rectangle
                ),
              )),
              baseColor: Colors.white.withOpacity(0.6),
              highlightColor: Colors.deepGrey.withOpacity(0.6));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 32, top: 32, bottom: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        // boxShadow: [
        //   BoxShadow(color: Colors.primaryColor, offset: Offset.zero)
        // ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Savings and Tier number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.darkBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                child: Center(
                  child: Text('SAVINGS', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
              Text('TIER 1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
            ],
          ),
          SizedBox(height: 12,),
          //Amount
          displayAccountBalance(),
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('res/drawables/ic_moniepoint_cube.svg', width: 36, height: 36,),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Moniepoint Acc. No:', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
                  Text(widget.viewModel.accountNumber,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400, fontFamily: Styles.ocraExtended)
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () => Share.share(widget.viewModel.accountNumber, subject: 'Moniepoint'),
                child: SvgPicture.asset(
                  'res/drawables/ic_share.svg',
                  fit: BoxFit.contain,
                  width: 18,
                  height: 18,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      loadAccountBalance();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}