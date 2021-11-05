import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/savings_flex_topup_viewmodel.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/views/savings_enable_flex_view.dart';
import 'package:moniepoint_flutter/app/savings/savings_success_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/savings_account_item.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/amount_pill.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/views/user_account_selection_view.dart';
import 'package:provider/provider.dart';

class SavingsFlexTopupView extends StatefulWidget {
  const SavingsFlexTopupView({Key? key}) : super(key: key);

  @override
  _SavingsFlexTopupViewState createState() => _SavingsFlexTopupViewState();
}

class _SavingsFlexTopupViewState extends State<SavingsFlexTopupView> {
  late final SavingsFlexTopupViewModel _viewModel;

  double _amount = 0.00;
  ListDataItem<String>? _selectedAmountPill;
  final List<ListDataItem<String>> amountPills = List.generate(4, (index) => ListDataItem((5000 * (index + 1)).formatCurrencyWithoutLeadingZero));

  TextStyle getBoldStyle(
    {double fontSize = 32.5,
      Color color = Colors.textColorBlack,
      FontWeight fontWeight = FontWeight.w700}) =>
    TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);



  List<Widget> generateAmountPillsWidget() {
    final pills = <Widget>[];
    amountPills.forEachIndexed((index, element) {
      pills.add(
        Expanded(
          flex: 1,
          child: AmountPill(
            item: element, position: index, primaryColor: Colors.solidGreen,
            listener: (ListDataItem<String> item, position){
              setState(() {
                _selectedAmountPill?.isSelected = false;
                _selectedAmountPill = item;
                _selectedAmountPill?.isSelected = true;
                this._amount = double.parse(_selectedAmountPill!.item.replaceAll(RegExp(r'[(a-z)|(A-Z)|(,₦)]'), ""));
              });
      })));
      if(index != amountPills.length -1) pills.add(SizedBox(width: 8,));
    });
    return pills;
  }

  Widget initialView() {
    return  Stack(
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
              overlayColor: MaterialStateProperty.all(Colors.solidGreen.withOpacity(0.1)),
              highlightColor: Colors.solidGreen.withOpacity(0.05),
              // onTap: () => _onItemClicked(context, beneficiary),
              child: Center(
                child: Text("LI",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.solidGreen
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  @override
  void initState() {
    _viewModel = SavingsFlexTopupViewModel();
    // if(_viewModel.userAccounts.length > 1) _viewModel.getUserAccountsBalance().listen((event) { });
    // else _viewModel.getCustomerAccountBalance().listen((event) { });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                "Top up Flex Savings",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 26),
              Text(
                "How much would you like to save?",
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
              ),

              SizedBox(height: 13),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 26 ),
                decoration: BoxDecoration(
                  color: Color(0xffA5C097).withOpacity(0.15),
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                child: PaymentAmountView((_amount * 100).toInt(), (value){},
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
                "Top up from?",
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 12),
              UserAccountSelectionView(_viewModel,
                primaryColor: Colors.solidGreen,
                checkBoxSize: Size(40, 40),
                //TODO modify
                onAccountSelected: (account) => _viewModel.setSourceAccount(account),
                titleStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.textColorBlack,
                  fontWeight: FontWeight.bold),
                listStyle: ListStyle.alternate,
                checkBoxPadding: EdgeInsets.all(6.0),
                checkBoxBorderColor: Color(0xffA6B6CE).withOpacity(0.95),
                isShowTrailingWhenExpanded: false,
              ),
              Spacer(),
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
                      builder: (ctx) => SavingsSucessView(
                        primaryText: "Top up Successful!",
                        secondaryText: loremIpsum,
                        primaryButtonText: "Continue",
                        primaryButtonAction: () {
                        },
                      ),
                    ),
                  );
                },
                text: 'Top Up'),
              SizedBox(height: 18,),
            ],
          ),
        ),
      ),
    );
  }
}
