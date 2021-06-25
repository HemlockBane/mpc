import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

class DashboardContainerView extends StatefulWidget{

  final DashboardViewModel viewModel;

  DashboardContainerView(Key key, this.viewModel):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DashboardContainerViewState();
  }

}

class DashboardContainerViewState extends State<DashboardContainerView> with WidgetsBindingObserver {

  bool _isLoadingBalance = true;
  bool _isLoadingBalanceError = false;

  void loadAccountBalance() {
    final viewModel = widget.viewModel;
    viewModel.getCustomerAccountBalance(useLocal: false).listen((event) {
      if(event is Loading) setState(() {
        _isLoadingBalance = true;
        _isLoadingBalanceError = false;
      });
      if (event is Error<AccountBalance>) {
        setState(() {
          _isLoadingBalance = false;
          _isLoadingBalanceError = true;
        });
      }
      if(event is Success<AccountBalance>) {
        setState(() {
          _isLoadingBalance = false;
          _isLoadingBalanceError = false;
        });
      }
    });
  }

  Widget _displayAccountBalance () {
    final bool hideAccountBalance = PreferenceUtil.getValueForLoggedInUser(PreferenceUtil.HIDE_ACCOUNT_BAL) ?? false;
    return StreamBuilder(
        stream: widget.viewModel.balanceStream,
        builder: (BuildContext ctx, AsyncSnapshot<AccountBalance?> snapshot) {
          if(snapshot.hasData && (!_isLoadingBalance && !_isLoadingBalanceError)) {
            final balance = hideAccountBalance ? "****" : "N ${snapshot.data?.availableBalance!.formatCurrencyWithoutSymbolAndDividing}";
            return Text("$balance",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28, fontFamily: Styles.defaultFont)
            ).colorText({"N": Tuple(Colors.white.withOpacity(0.3), null)}, underline: false);
          }
          if(_isLoadingBalanceError && !hideAccountBalance) {
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

  Widget _getCardGradientBackground() {
    if (UserInstance().accountStatus?.postNoDebit != true) {
      return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: Container(
                color: Color(0XFF186cf3),
                child: SvgPicture.asset(
                  'res/drawables/ic_dashboard_card_gradient.svg',
                  fit: BoxFit.cover,
                )),
          ));
    }
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        top: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: Container(
              color: Color(0XFF98A9C5)
          ),
        ),
    );
  }

  Widget _displayOnPostNoDebit() {
    if(UserInstance().accountStatus?.postNoDebit != true) return SizedBox();
    return Container(
      height: 230,
      child: Stack(
        children: [
          Positioned(
              top: 32,
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.only(left: 24, right: 24, top: 48, bottom: 24),
                decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text('A Post-No-Debit order has been placed on this account!',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 16),
                    Styles.appButton(
                        elevation: 0,
                        buttonStyle: Styles.redButtonStyle2.copyWith(
                          backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.19))
                        ),
                        onClick: () {
                          Navigator.of(context).pushNamed(Routes.ACCOUNT_UPDATE);
                        },
                        text: 'Tap to Fix This'
                    )
                  ],
                ),
              )
          ),
          Positioned(
              top: 4,
              right: 0,
              left: 0,
              child: Container(
                width: 60,
                height: 60,
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white
                ),
                child: SvgPicture.asset('res/drawables/ic_warning.svg', color: Colors.red,),
              )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _getCardGradientBackground(),
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),

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
                  Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Text('', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  )
                ],
              ),
              SizedBox(height: 12,),
              //Amount
              _displayAccountBalance(),
              _displayOnPostNoDebit(),
              Spacer(),
              Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            (UserInstance().accountStatus?.postNoDebit == true)
                                ? 'res/drawables/ic_pnd_moniepoint_cube.svg'
                                : 'res/drawables/ic_moniepoint_cube.svg',
                            width: 36, height: 36
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Moniepoint Acc. No:', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
                            Text(widget.viewModel.accountNumber,
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400, fontFamily: Styles.ocraExtended)
                            ),
                          ],
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Styles.imageButton(
                              padding: EdgeInsets.all(8),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              onClick: () => Share.share(widget.viewModel.accountNumber, subject: 'Moniepoint'),
                              image: SvgPicture.asset(
                                'res/drawables/ic_share.svg',
                                fit: BoxFit.contain,
                                width: 18,
                                height: 18,
                              )
                          ),
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
        )
      ],
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
  void didUpdateWidget(covariant DashboardContainerView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}