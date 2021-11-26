import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/savings_flex_withdrawal_viewmodel.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/views/savings_enable_flex_view.dart';
import 'package:moniepoint_flutter/app/savings/savings_success_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/views/pnd_notification_banner.dart';
import 'package:moniepoint_flutter/core/views/savings_account_item.dart';
import 'package:moniepoint_flutter/core/views/savings_notification_banner.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/amount_pill.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/views/user_account_selection_view.dart';
import 'package:provider/provider.dart';

class SavingsFlexWithdrawalView extends StatefulWidget {
  const SavingsFlexWithdrawalView({Key? key}) : super(key: key);

  @override
  _SavingsFlexWithdrawalViewState createState() =>
    _SavingsFlexWithdrawalViewState();
}

class _SavingsFlexWithdrawalViewState extends State<SavingsFlexWithdrawalView> {
  late final SavingsFlexWithdrawalViewModel _viewModel;


  double _amount = 0.00;
  ListDataItem<String>? _selectedAmountPill;
  final List<ListDataItem<String>> amountPills = List.generate(
    4,
      (index) =>
      ListDataItem((5000 * (index + 1)).formatCurrencyWithoutLeadingZero));

  TextStyle getBoldStyle({double fontSize = 32.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w700}) =>
    TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  TextStyle getNormalStyle({double fontSize = 12,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w400}) =>
    TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  List<Widget> generateAmountPillsWidget() {
    final pills = <Widget>[];
    amountPills.forEachIndexed((index, element) {
      pills.add(Expanded(
        flex: 1,
        child: AmountPill(
          item: element,
          position: index,
          primaryColor: Colors.solidGreen,
          listener: (ListDataItem<String> item, position) {
            setState(() {
              _selectedAmountPill?.isSelected = false;
              _selectedAmountPill = item;
              _selectedAmountPill?.isSelected = true;
              this._amount = double.parse(_selectedAmountPill!.item
                .replaceAll(RegExp(r'[(a-z)|(A-Z)|(,₦)]'), ""));
            });
          })));
      if (index != amountPills.length - 1)
        pills.add(SizedBox(
          width: 8,
        ));
    });
    return pills;
  }

  Widget initialView() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          "res/drawables/ic_m_bg.svg",
          fit: BoxFit.cover,
          height: 45,
          width: 45,
          color: Colors.solidGreen.withOpacity(0.11),
        ),
        Container(
          height: 45,
          width: 45,
          child: Material(
            borderRadius: BorderRadius.circular(17),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(17),
              overlayColor:
              MaterialStateProperty.all(Colors.solidGreen.withOpacity(0.1)),
              highlightColor: Colors.solidGreen.withOpacity(0.05),
              // onTap: () => _onItemClicked(context, beneficiary),
              child: Center(
                child: Text(
                  "LI",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.solidGreen),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  final warningText =
    "You have used up all your free withdrawals!\nYour interest for the month will be forfeited if you complete this withdrawal.";


  @override
  void initState() {
    _viewModel = SavingsFlexWithdrawalViewModel();
    if(_viewModel.userAccounts.length > 1) _viewModel.getUserAccountsBalance().listen((event) { });
    else _viewModel.getCustomerAccountBalance().listen((event) { });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final infoText = RichText(
      text: TextSpan(children: [
        TextSpan(
          text: "2 Free Withdrawals",
          style: getBoldStyle(color: Colors.solidYellow, fontSize: 12.6)
            .copyWith(letterSpacing: 0.3)),
        TextSpan(
          text: " remaining this month",
          style:
          getNormalStyle(color: Colors.solidYellow, fontSize: 12.6)
            .copyWith(letterSpacing: 0.3))
      ]),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _viewModel),
      ],
      child: Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: Colors.solidGreen),
          title: Text('General Savings',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.textColorBlack)),
          backgroundColor: Colors.backgroundWhite,
          elevation: 0),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 21),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  "Withdrawal",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Amount",
                        style: getBoldStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5),
                      Text('₦ 120,459.00',
                        textAlign: TextAlign.left,
                        style: getBoldStyle(
                          fontWeight: FontWeight.w700, fontSize: 19)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child:
                            Text("Accrued Interest", style: getNormalStyle()),
                          ),
                          Expanded(
                            child:
                            Text("Free Withdrawal", style: getNormalStyle()),
                          )
                        ],
                      ),
                      SizedBox(height: 3),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "₦ 18,550.00",
                              style: getBoldStyle(fontSize: 14),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Text("0", style: getBoldStyle(fontSize: 14, color: Colors.textColorBlack),),
                                SizedBox(width: 10),
                                Text('What is this?', style: getNormalStyle(fontSize: 12, color: Colors.solidGreen),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 1,
                        color: Color(0xff0649AF).withOpacity(0.1))
                    ]),
                ),
                SizedBox(height: 33),
                Text(
                  "How much would you like to withdraw?",
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 13),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 26),
                  decoration: BoxDecoration(
                    color: Color(0xffA5C097).withOpacity(0.15),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: PaymentAmountView(
                    (_amount * 100).toInt(),
                      (value) {},
                    currencyColor: Color(0xffC1C2C5).withOpacity(0.5),
                    textColor: Colors.textColorBlack,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: generateAmountPillsWidget(),
                ),
                SizedBox(height: 26),
                Text(
                  "Withdraw to?",
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                UserAccountSelectionView(_viewModel,
                  primaryColor: Colors.solidGreen,
                  onAccountSelected: (account) => _viewModel.setSourceAccount(account),
                  checkBoxSize: Size(40, 40),
                  listStyle: ListStyle.alternate,
                  titleStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.textColorBlack,
                    fontWeight: FontWeight.bold),
                  checkBoxPadding: EdgeInsets.all(6.0),
                  checkBoxBorderColor: Color(0xffA6B6CE).withOpacity(0.95),
                  isShowTrailingWhenExpanded: false,
                ),
                SavingsNotificationBanner(notificationString: warningText),
                SizedBox(height: 28),
                Styles.statefulButton(
                  buttonStyle: Styles.primaryButtonStyle.copyWith(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.solidGreen),
                    textStyle: MaterialStateProperty.all(getBoldStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.white))),
                  stream: Stream.value(true),
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>
                          SavingsSuccessView(
                            primaryText: "Withdrawal Successful!",
                            secondaryText: loremIpsum,
                            primaryButtonText: "Continue",
                            primaryButtonAction: () {},
                          ),
                      ),
                    );
                  },
                  text: 'Withdraw Money'),
                SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Container _getWithdrawalNotification(
    {NotificationType type = NotificationType.warning }) {
    final color = type == NotificationType.warning ? Colors.red : Colors.solidYellow;
    final warningText = "You have used up all your free withdrawals!\nYour interest for the month will be forfeited if you complete this withdrawal.";

    final warning = Text(warningText,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 12.6,
        color: color,
        fontWeight: FontWeight.w500));

    final info = RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "2 Free Withdrawals", style: getBoldStyle(color: Colors.solidYellow, fontSize: 12.6).copyWith(letterSpacing: 0.3)),
          TextSpan(text: " remaining this month", style: getNormalStyle(color: Colors.solidYellow, fontSize: 12.6).copyWith(letterSpacing: 0.3))
        ]
      ),
    );

    final warningIcon = SvgPicture.asset('res/drawables/ic_info.svg',
      width: 27, height: 27, color: color
    );

    final infoIcon = SvgPicture.asset('res/drawables/ic_info_italic.svg',
      width: 24, height: 24, color: color);


    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.all(Radius.circular(9)),),
      margin: EdgeInsets.only(top: 20, bottom: 2),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          highlightColor: Colors.primaryColor.withOpacity(0.02),
          overlayColor:
          MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.05)),
          borderRadius: BorderRadius.all(Radius.circular(13)),
          onTap: null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 9),
            child: Row(
              crossAxisAlignment: type == NotificationType.warning ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 19,
                  height: 19,
                  padding: EdgeInsets.all(0),
                  child: Center(
                    child: type == NotificationType.warning ? warningIcon : infoIcon
                    ),
                ),
                SizedBox(width: 8),
                Expanded(child: type == NotificationType.warning ? warning : info),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


enum NotificationType {
  info,
  warning
}
