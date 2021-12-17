import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_top_up_response.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/savings_flex_topup_viewmodel.dart';
import 'package:moniepoint_flutter/app/savings/savings_success_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/amount_pill.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/core/views/user_account_selection_view.dart';
import 'package:moniepoint_flutter/main.dart';
import 'package:provider/provider.dart';

class SavingsFlexTopUpView extends StatefulWidget {

  const SavingsFlexTopUpView({
    Key? key,
    required this.flexSavingId
  }) : super(key: key);

  final int flexSavingId;

  @override
  _SavingsFlexTopUpViewState createState() => _SavingsFlexTopUpViewState();

}

class _SavingsFlexTopUpViewState extends State<SavingsFlexTopUpView> {
  late final SavingsFlexTopUpViewModel _viewModel;

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
                final amount = double.parse(_selectedAmountPill!.item.replaceAll(RegExp(r'[(a-z)|(A-Z)|(,₦)]'), ""));
                _viewModel.setAmount(amount);
              });
      })));
      if(index != amountPills.length - 1) pills.add(SizedBox(width: 8,));
    });
    return pills;
  }

  @override
  void initState() {
    _viewModel = Provider.of<SavingsFlexTopUpViewModel>(context, listen: false);
    _viewModel.setAmount(0.0);
    super.initState();
  }

  void _subscribeUiToTopUp(){
    if(_viewModel.isLoading) return;
    setState(() {_viewModel.setIsLoading(true);});

    _viewModel.topUpFlex().listen((event) {
      if(event is Loading) {
        if(_viewModel.isLoading == false) setState(() => _viewModel.setIsLoading(true));
      }
      else if(event is Success) {
        setState(() {_viewModel.setIsLoading(false);});
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => SavingsSuccessView(
              primaryText: "Top up\nSuccessful!",
              secondaryText: "Your Flex Top up was successful!",
              primaryButtonText: "Continue",
              primaryButtonAction: () {
                navigatorKey.currentState?.pushNamedAndRemoveUntil(
                    Routes.SAVINGS_FLEX_DASHBOARD, (route) {
                  print("RouteName===>${route.settings.name}");
                  return route.settings.name == Routes.FLEX_SAVINGS;
                }, arguments: {"flexSavingId": _viewModel.flexSavingAccount?.id});
              },
            ),
          ),
        );
      }
      else if(event is Error<FlexTopUpResponse>) {
        setState(() { _viewModel.setIsLoading(false); });
        showError(context, title: "Top up Failed!", message: event.message);
      }
    });
  }

  Widget _amountWidget() => Container(
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 26 ),
    decoration: BoxDecoration(
        color: Color(0xffA5C097).withOpacity(0.15),
        borderRadius: BorderRadius.all(Radius.circular(8))
    ),
    child: PaymentAmountView((_viewModel.amount! * 100).toInt(), (value){
        _viewModel.setAmount(value / 100);
      },
      currencyColor: Color(0xffC1C2C5).withOpacity(0.5),
      textColor: Colors.textColorBlack,
    ),
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
                'General Savings',
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
        body: FutureBuilder(
            future: _viewModel.getFlexSaving(widget.flexSavingId),
            builder: (ctx, AsyncSnapshot<FlexSaving?> snap) {
              final FlexSaving? flexSaving = snap.data;

              if(snap.hasData == false || flexSaving == null) return Container();

              return Container(
                color: Color(0XFFF5F5F5).withOpacity(0.7),
                padding: EdgeInsets.symmetric(horizontal: 21),
                child: ScrollView(
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
                       _amountWidget(),
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
                         selectedUserAccount: _viewModel.sourceAccount,
                         onAccountSelected: (account) => _viewModel.setSourceAccount(account),
                         titleStyle: TextStyle(
                             fontSize: 15,
                             color: Colors.textColorBlack,
                             fontWeight: FontWeight.bold
                         ),
                         listStyle: ListStyle.alternate,
                         checkBoxPadding: EdgeInsets.all(6.0),
                         checkBoxBorderColor: Color(0xffA6B6CE).withOpacity(0.95),
                         isShowTrailingWhenExpanded: false,
                       ),
                       Spacer(),
                       Styles.statefulButton(
                           buttonStyle: Styles.savingsFlexButtonStyle.copyWith(
                               textStyle: MaterialStateProperty.all(getBoldStyle(
                                   fontWeight: FontWeight.w500,
                                   fontSize: 15,
                                   color: Colors.white)
                               )
                           ),
                           isLoading: _viewModel.isLoading,
                           stream: _viewModel.isValid,
                           loadingColor: Colors.savingsPrimary.withOpacity(0.5),
                           onClick: _subscribeUiToTopUp,
                           text: 'Top Up'
                       ),
                       SizedBox(height: 32,),
                     ],
                   ),
                ),
              );
            }
        ),
      ),
    );
  }
}
