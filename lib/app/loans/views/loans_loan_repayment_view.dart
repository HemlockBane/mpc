import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_details.dart';
import 'package:moniepoint_flutter/app/loans/viewmodels/loan_repayment_view_model.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_advert_details_view.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_repayment_confirmation_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/views/amount_pill.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/core/views/user_account_selection_view.dart';
import 'package:provider/provider.dart';

class LoanRepaymentView extends StatefulWidget {
  const LoanRepaymentView({Key? key, required this.loanDetails}) : super(key: key);

final ShortTermLoanDetails? loanDetails;

  @override
  _LoanRepaymentViewState createState() => _LoanRepaymentViewState();
}

class _LoanRepaymentViewState extends State<LoanRepaymentView> {

  late final LoanRepaymentViewModel _viewModel;

  double _amount = 0.00;
  ListDataItem<String>? _selectedAmountPill;
  late List<ListDataItem<String>> amountPills;


  double getNearestThousand(double amount) {
    return (amount / 1000).round().toDouble() * 1000;
  }

  List<ListDataItem<String>> getAmountPills(){
    return List.generate(4, (index) {
      final amount = getNearestThousand(widget.loanDetails!.outstandingAmount! * (index + 1) * 0.25);
      return ListDataItem(amount
      .formatCurrencyWithoutLeadingZero);
    });
  }

  List<Widget> generateAmountPillsWidget() {
    final viewModel = Provider.of<LoanRepaymentViewModel>(context, listen: false);
    final pills = <Widget>[];
    amountPills.forEachIndexed((index, element) {
      pills.add(
        Expanded(
          flex: 1,
          child: AmountPill(
            item: element, position: index, primaryColor: Colors.solidOrange,
            listener: (ListDataItem<String> item, position){
              setState(() {
                _selectedAmountPill?.isSelected = false;
                _selectedAmountPill = item;
                _selectedAmountPill?.isSelected = true;
                this._amount = double.parse(_selectedAmountPill!.item.replaceAll(RegExp(r'[(a-z)|(A-Z)|(,₦)]'), ""));
                viewModel.setAmount(this._amount);
              });
            })));
      if(index != amountPills.length -1) pills.add(SizedBox(width: 8,));
    });
    return pills;
  }

  Widget amountWidget(){
    final viewModel = Provider.of<LoanRepaymentViewModel>(context, listen: false);
    viewModel.setAmount(this._amount);
    return  Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 26, bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xffE9ECF0),
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: PaymentAmountView((_amount * 100).toInt(), (value){
        this._amount = value / 100;
        viewModel.setAmount(_amount);
      },
        currencyColor: Color(0xffC1C2C5).withOpacity(0.5),
        textColor: Colors.textColorBlack,
      ),
    );
  }


  TextStyle getBoldStyle({
    double fontSize = 24.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  TextStyle getNormalStyle({
    double fontSize = 11.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w500,
  }) =>
      TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  Widget _smallTile({required String text1, required String text2}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text1, style: getNormalStyle(fontSize: 11.5, color: Color(0xffA9AFA5))),
          SizedBox(height: 5),
          Text(text2, style: getBoldStyle(fontSize: 14.5))
        ],
      );


  @override
  void initState() {
    _viewModel =  Provider.of<LoanRepaymentViewModel>(context, listen: false);
    // if(_viewModel.userAccounts.length > 1) _viewModel.getUserAccountsBalance().listen((event) { });
    // else _viewModel.getCustomerAccountBalance().listen((event) { });
    amountPills = getAmountPills();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SessionedWidget(
      context: context,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: Colors.solidOrange),
          title: Text(
            'Loans',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.textColorBlack,
            ),
          ),
          backgroundColor: Colors.backgroundWhite,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 21.34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 35),
                Text("Repay Loan", style: getBoldStyle(fontSize: 23)),
                SizedBox(height: 29),
                Container(
                  padding: EdgeInsets.fromLTRB(18, 16, 70, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Outstanding Amount", style: getNormalStyle(fontWeight: FontWeight.w500, fontSize: 14.5)),
                      SizedBox(height: 7),
                      Text("${widget.loanDetails?.outstandingAmount?.formatCurrency}", style: getBoldStyle(fontSize: 19.5),),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _smallTile(text1: "Amount Loaned", text2: "${widget.loanDetails?.loanAmount?.formatCurrency}"),
                          _smallTile(text1: "Interest Rate", text2: "${widget.loanDetails?.interestRate}%"),
                          // SizedBox(width: 0)
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                          width: 0.7, color: Color(0xff1EB12D).withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.loanCardShadowColor.withOpacity(0.1))
                      ]),
                ),
                SizedBox(height: 32),
                Text(
                  "How much would you like to pay?",
                  style: getNormalStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.textColorMainBlack,
                  ),
                ),
                SizedBox(height: 13),
                amountWidget(),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: generateAmountPillsWidget(),
                ),
                SizedBox(height: 32),
                Text(
                  "Select repayment account",
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                UserAccountSelectionView(_viewModel,
                  primaryColor: Colors.solidOrange,
                  //TODO modify for loans
                  selectedUserAccount: _viewModel.repaymentAccount,
                  onAccountSelected: (account) => _viewModel.setRepaymentAccount(account),
                  titleStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.textColorBlack,
                    fontWeight: FontWeight.bold
                  ),
                  checkBoxSize: Size(40, 40),
                  listStyle: ListStyle.alternate,
                  checkBoxPadding: EdgeInsets.all(6.0),
                  checkBoxBorderColor: Color(0xffA6B6CE).withOpacity(0.95),
                  isShowTrailingWhenExpanded: false,
                ),
                SizedBox(height: 148),
                Styles.statefulButton(
                  buttonStyle: loanButtonStyle(),
                  stream: _viewModel.isValid,
                  onClick: () {
                    if(widget.loanDetails == null) return;

                    final repaymentConfirmation = _viewModel.getRepaymentConfirmation(loanDetails: widget.loanDetails!);
                    final args = {"confirmation": repaymentConfirmation};
                    Navigator.pushNamed(context, Routes.LOAN_REPAYMENT_CONFIRMATION, arguments: args);
                  },
                  text: 'Repay Loan'),
                SizedBox(height: 38 + 31.5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
