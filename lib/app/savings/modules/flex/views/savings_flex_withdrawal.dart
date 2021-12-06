import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/savings_flex_withdrawal_viewmodel.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/views/savings_flex_withdrawal_confirmation.dart';
import 'package:moniepoint_flutter/app/savings/savings_success_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/savings_notification_banner.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/amount_pill.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/core/views/user_account_selection_view.dart';
import 'package:provider/provider.dart';


class SavingsFlexWithdrawalView extends StatefulWidget {
  const SavingsFlexWithdrawalView({
    Key? key,
    required this.flexSavingId
  }) : super(key: key);

  final int flexSavingId;

  @override
  _SavingsFlexWithdrawalViewState createState() => _SavingsFlexWithdrawalViewState();
}


///_SavingsFlexWithdrawalViewState
///
///
class _SavingsFlexWithdrawalViewState extends State<SavingsFlexWithdrawalView> with SingleTickerProviderStateMixin{

  late final AnimationController _animationController;
  late final SavingsFlexWithdrawalViewModel _viewModel;

  ListDataItem<String>? _selectedAmountPill;
  final List<ListDataItem<String>> amountPills = List.generate(4, (index) => ListDataItem((5000 * (index + 1)).formatCurrencyWithoutLeadingZero));

  late final Future<FlexSaving?> _flexSavingFuture;

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
              final amount = double.parse(_selectedAmountPill!.item.replaceAll(RegExp(r'[(a-z)|(A-Z)|(,₦)]'), ""));
              _viewModel.setAmount(amount);
            });
          })));
      if (index != amountPills.length - 1)
        pills.add(SizedBox(width: 8));
    });
    return pills;
  }

  @override
  void initState() {
    _viewModel = Provider.of<SavingsFlexWithdrawalViewModel>(context, listen: false);
    _flexSavingFuture = _viewModel.getFlexSaving(widget.flexSavingId);
    this._animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000)
    );
    _viewModel.setAmount(0.0);
    super.initState();
  }

  Widget _amountWidget() => Container(
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 26),
    decoration: BoxDecoration(
        color: Color(0xffA5C097).withOpacity(0.15),
        borderRadius: BorderRadius.all(Radius.circular(8))),
    child: PaymentAmountView((_viewModel.amount! * 100).toInt(), (value) {
        _viewModel.setAmount(value / 100);
      },
      currencyColor: Color(0xffC1C2C5).withOpacity(0.5),
      textColor: Colors.textColorBlack,
    ),
  );

  void _navigateToConfirmation() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (ctx) => ChangeNotifierProvider.value(
              value: _viewModel,
              child: FlexSavingWithdrawalConfirmationView(),
          )
      )
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (ctx) =>
    //         SavingsSuccessView(
    //           primaryText: "Withdrawal Successful!",
    //           secondaryText: loremIpsum,
    //           primaryButtonText: "Continue",
    //           primaryButtonAction: () {},
    //         ),
    //   ),
    // );
  }

  Widget _displayWithdrawalNotification() {
    final count = _viewModel.flexSaving?.withdrawalCount?.count;
    if(count == null) return SizedBox();
    return SavingsNotificationBanner(
        notificationType: NotificationType.info,
        notificationString: "$count Free Withdrawals remaining this month"
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return SessionedWidget(
      context: context,
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
                    color: Colors.textColorBlack
                )
            ),
            backgroundColor: Colors.backgroundWhite,
            elevation: 0
        ),
        body: FutureBuilder(
          future: _flexSavingFuture,
          builder: (ctx, AsyncSnapshot<FlexSaving?> snap) {
            final FlexSaving? flexSaving = snap.data;

            if(snap.connectionState != ConnectionState.done) {
              _animationController.forward(from: 0);
              return ListViewUtil.defaultLoadingView(_animationController);
            }

            if(snap.hasData == false || flexSaving == null) return Container();

            _viewModel.setFlexSavingAccount(flexSaving);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 21),
              child: ScrollView(
                maxHeight: MediaQuery.of(context).size.height - (70 + bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Withdrawal",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 12),
                    _TotalSavingsView(flexSaving:  flexSaving,),
                    SizedBox(height: 33),
                    Text(
                      "How much would you like to withdraw?",
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 13),
                    _amountWidget(),
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
                      selectedUserAccount: _viewModel.sourceAccount,
                      onAccountSelected: (account) => _viewModel.setSourceAccount(account),
                      checkBoxSize: Size(40, 40),
                      listStyle: ListStyle.alternate,
                      titleStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.textColorBlack,
                          fontWeight: FontWeight.bold
                      ),
                      checkBoxPadding: EdgeInsets.all(6.0),
                      checkBoxBorderColor: Color(0xffA6B6CE).withOpacity(0.95),
                      isShowTrailingWhenExpanded: false,
                    ),
                    _displayWithdrawalNotification(),
                    SizedBox(height: 28),
                    Styles.statefulButton(
                        buttonStyle: Styles.savingsFlexButtonStyle,
                        stream: _viewModel.isValid,
                        onClick: _navigateToConfirmation,
                        text: 'Withdraw Money'
                    ),
                    SizedBox(height: 18),
                  ],
                ),
              ),
            );
          },
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

///_TotalSavingsView
///
///
class _TotalSavingsView extends StatelessWidget {

  _TotalSavingsView({
    required this.flexSaving
  });

  final FlexSaving flexSaving;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Total Amount",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.textColorBlack
                  )
              ),
              SizedBox(height: 5),
              Text(
                  '₦ 120,459.00',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 19,
                      color: Colors.textColorBlack
                  )
              ),
            ],
          ),
          _FreeWithdrawalBoxText(flexSaving: flexSaving)
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 1,
                color: Color(0xff0649AF).withOpacity(0.1)
            )
          ]
      ),
    );
  }

}


///_FreeWithdrawalBoxText
///
///
class _FreeWithdrawalBoxText extends StatelessWidget {

  _FreeWithdrawalBoxText({
    required this.flexSaving
  });

  final FlexSaving flexSaving;

  Color _freeWithdrawalColor() {
    final count = flexSaving.withdrawalCount?.count;

    if (count == null) return Colors.grey;
    if (count == 0) return Colors.red;
    else if (count == 1) return Colors.solidOrange;

    return Colors.solidGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 9, right: 9, top: 6, bottom: 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: _freeWithdrawalColor().withOpacity(.1)
      ),
      child: Column(
        children: [
          Text(
            "Free Withdrawals",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _freeWithdrawalColor()
            ),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "${flexSaving.withdrawalCount?.count ?? "--"}",
                  style: TextStyle(
                      color: Colors.textColorBlack,
                      fontSize: 16,
                      letterSpacing: 0.3,
                      fontWeight: FontWeight.w700
                  )),
              TextSpan(
                  text: " this month",
                  style: TextStyle(
                      color: Colors.solidYellow,
                      fontSize: 13,
                      letterSpacing: 0.3
                  ))
            ]),
          )
        ],
      ),
    );
  }
}