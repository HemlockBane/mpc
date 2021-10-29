import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/app/savings/flex/viewmodels/savings_flex_setup_viewmodel.dart';
import 'package:moniepoint_flutter/app/savings/flex/views/savings_enable_flex_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/amount_pill.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/views/transaction_account_source.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:collection/collection.dart';

import '../../savings_success_view.dart';


const savingsGreen = Color(0xffA5C097);

class FirstFlexSetupForm extends PagedForm{
  @override
  _FirstFlexSetupFormState createState() => _FirstFlexSetupFormState();

  @override
  String getTitle() => "FirstFlexSetupForm";
}

class _FirstFlexSetupFormState extends State<FirstFlexSetupForm> with AutomaticKeepAliveClientMixin{
  late final SavingsFlexSetupViewModel _viewModel;
  double _amount = 0.00;
  ListDataItem<String>? _selectedAmountPill;
  final List<ListDataItem<String>> amountPills = List.generate(4, (index) => ListDataItem((5000 * (index + 1)).formatCurrencyWithoutLeadingZero));

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

  TextStyle getBoldStyle(
    {double fontSize = 32.5,
      Color color = Colors.textColorBlack,
      FontWeight fontWeight = FontWeight.w700}) =>
    TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  final savingsFrequencies = List.of([
    ComboItem("Monthly", "Monthly", isSelected: true),
    ComboItem("Weekly",  "Weekly",),
  ]);


  @override
  void initState() {
    _viewModel = Provider.of<SavingsFlexSetupViewModel>(context, listen: false);
    if(_viewModel.userAccounts.length > 1) _viewModel.getUserAccountsBalance().listen((event) { });
    else _viewModel.getCustomerAccountBalance().listen((event) { });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "How frequently would you like to save?",
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 12),
          SelectionCombo<String>(
            savingsFrequencies.toList(), (item, index) {


          },
            checkBoxPosition: CheckBoxPosition.leading,
            shouldUseAlternateDecoration: true,
            primaryColor: Colors.solidGreen,
            backgroundColor: savingsGreen.withOpacity(0.15),
            horizontalPadding: 11 ,
          ),

          SizedBox(height: 32),
          Text(
            "How much would you like to save?",
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
          ),

          SizedBox(height: 13),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 26 ),
            decoration: BoxDecoration(
              color: savingsGreen.withOpacity(0.15),
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
            "Select your Account",
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12),
          TransactionAccountSource(_viewModel,
            primaryColor: Colors.solidGreen,
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
          SizedBox(height: 57),
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
              _viewModel.moveToNext(widget.position);
            },
            text: 'Next'),
          SizedBox(height: 20),


        ],
      ),
    );
  }
}


class SecondFlexSetupForm extends PagedForm {
  @override
  _SecondFlexSetupFormState createState() => _SecondFlexSetupFormState();

  @override
  String getTitle() => "SecondFlexSetupForm";
}

class _SecondFlexSetupFormState extends State<SecondFlexSetupForm> with AutomaticKeepAliveClientMixin {

  late final SavingsFlexSetupViewModel _viewModel;
  var startDate = "Start date";
  var endDate = "End date";


  TextStyle getBoldStyle(
    {double fontSize = 32.5,
      Color color = Colors.textColorBlack,
      FontWeight fontWeight = FontWeight.w700}) =>
    TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  TextStyle getNormalStyle(
    {double fontSize = 32.5,
      Color color = Colors.textColorBlack,
      FontWeight fontWeight = FontWeight.w500}) =>
    TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  final savingsTypes = List.of([
    ComboItem("Automatic", "Automatic", isSelected: true),
    ComboItem("Manual",  "Manual",),
  ]);


  final savingsDates = List.of([
    ComboItem("Week 1 (1st - 7th)", "Week 1;(1st - 7th)", isSelected: true),
    ComboItem("Week 2 (8th - 14th)",  "Week 2;(8th - 14th)",),
    ComboItem("Week 3 (15th - 21st)",  "Week 3;(15th - 21st)",),
    ComboItem("Week 4 (22nd - 31st)",  "Week 4;(22nd - 31st)",),
  ]);


  @override
  void initState() {
    _viewModel = Provider.of<SavingsFlexSetupViewModel>(context, listen: false);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  String getFormattedDateString(int date){
    final dateInMillis = DateTime.fromMillisecondsSinceEpoch(date);
    final formattedDate = "";//Jiffy(dateInMillis).format("do [of] MMM");
    return formattedDate;
  }


  void displayDatePicker(BuildContext context) async {
    final themeData = Theme.of(context);
    final currentDate = DateTime.now();
    // crazy hack to get last day in a month
    final lastDateInMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
    final selectedDate = await showDateRangePicker(
      helpText: 'Select Start and End Date',
      context: context,
      firstDate: DateTime(1900, 1, 1).add(Duration(days: 1)),
      lastDate: lastDateInMonth,
      builder: (ctx, child){
        return Theme(
          child: child!,
          data: themeData.copyWith(
            // check date range picker widget to know which colors to edit
            appBarTheme: themeData.appBarTheme.copyWith(backgroundColor: Colors.solidGreen),
            colorScheme: themeData.colorScheme.copyWith(primary: Colors.solidGreen)
          )
        );

      }
    );

    if(selectedDate != null ) {
      setState(() {
        final selectedStartDate = selectedDate.start.millisecondsSinceEpoch;
        final selectedEndDate = selectedDate.end.add(Duration(hours: 23)).millisecondsSinceEpoch;
        startDate = getFormattedDateString(selectedStartDate);
        endDate = getFormattedDateString(selectedEndDate);

      });
    }

  }

  Widget getDatePicker(){
    //TODO: Handle flex frequency in viewmodel
    // if flex frequency is monthly, use date range picker
    final boldStyle = TextStyle(color: Colors.textColorBlack, fontWeight: FontWeight.w600, fontSize: 16);
    return GestureDetector(
      onTap: (){
        displayDatePicker(context);
      },
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 19, top: 11.4, bottom: 11.4),
        child: Row(
          children: [
            Icon(CustomFont.calendar, color: Color(0xffA0A7AF), size: 25.5,),
            SizedBox(width: 10.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Set Date & Time", style: TextStyle(color: Colors.solidGreen, fontWeight: FontWeight.w600, fontSize: 12),),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(startDate, style: boldStyle,),
                          SizedBox(width: 3),
                          Text("to", style: TextStyle(color: Colors.textColorBlack, fontWeight: FontWeight.w400, fontSize: 16),),
                          SizedBox(width: 3),
                          Text(endDate, style: boldStyle,),

                        ],
                      ),
                      Text("Change", style: TextStyle(color: Colors.solidGreen, fontWeight: FontWeight.w700, fontSize: 13.3),)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: savingsGreen.withOpacity(0.15),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );


    // if flex frequency is weekly, use selection combo
    return SelectionCombo<String>(
      savingsDates.toList(), (item, index) {


    },
      checkBoxPosition: CheckBoxPosition.leading,
      maxDisplayValue: 4,
      shouldUseAlternateDecoration: true,
      primaryColor: Colors.solidGreen,
      backgroundColor: savingsGreen.withOpacity(0.15), horizontalPadding: 11 ,
      isColonSeparated: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final dialogContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Monthly Savings Account", style: getNormalStyle(fontSize: 15),),
        SizedBox(height: 8),
        Text("N7,000.00", style: getBoldStyle(fontSize: 20),),
        SizedBox(height: 26),
        Text("Interest rate", style: getNormalStyle(fontSize: 15)),
        SizedBox(height: 8),
        Row(
          children: [
            Text("10.25%", style: getBoldStyle(fontSize: 20),),
            SizedBox(width: 4),
            Text("p.a", style: getNormalStyle(fontSize: 18, color: Color(0xffA8ABB5)),)
          ],
        )
      ],
    );

    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  child: Text(
                    "How frequently would you like to save?",
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 12),
                SelectionCombo<String>(
                  savingsTypes.toList(), (item, index) {},
                  checkBoxPosition: CheckBoxPosition.leading,
                  shouldUseAlternateDecoration: true,
                  primaryColor: Colors.solidGreen,
                  backgroundColor: savingsGreen.withOpacity(0.15),
                  horizontalPadding: 11 ,
                ),
                SizedBox(height: 34),
                Container(
                  child: Text(
                    "When to take contribution?",
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 12),
                getDatePicker(),
                SizedBox(height: 32),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Styles.statefulButton(
                  buttonStyle: Styles.primaryButtonStyle.copyWith(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.deepGrey.withOpacity(0.3)),
                    textStyle: MaterialStateProperty.all(getBoldStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.deepGrey))),
                  stream: Stream.value(true),
                  onClick: () {
                    _viewModel.moveToPrev();
                  },
                  text: 'Back'),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: Styles.statefulButton(
                  buttonStyle: Styles.primaryButtonStyle.copyWith(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.solidGreen),
                    textStyle: MaterialStateProperty.all(getBoldStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.white))),
                  stream: Stream.value(true),
                  onClick: () {
                    showConfirmation(context,
                      primaryButtonText: "Complete Setup",
                      primaryButtonColor: Colors.solidGreen,
                      title: "Setup Confirmation",
                      content: dialogContent,
                      onPrimaryClick: (){
                        Navigator.pop(context);
                        Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => SavingsSucessView(
                            primaryText: "Setup Complete!",
                            secondaryText: loremIpsum,
                            primaryButtonText: "Continue",
                            primaryButtonAction: (){
                              Navigator.pushNamed(context, Routes.SAVINGS_FLEX_HOME);
                            },


                          ),),
                        );
                      }
                    );
                  },
                  text: 'Complete Setup'
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      )
    );
  }
}


