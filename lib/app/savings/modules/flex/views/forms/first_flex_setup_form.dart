import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving_config.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/flex_setup_viewmodel.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/amount_pill.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/views/user_account_selection_view.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

const savingsGreen = Color(0xffA5C097);

class FirstFlexSetupForm extends PagedForm{
  @override
  _FirstFlexSetupFormState createState() => _FirstFlexSetupFormState();

  @override
  String getTitle() => "FirstFlexSetupForm";
}

class _FirstFlexSetupFormState extends State<FirstFlexSetupForm> with AutomaticKeepAliveClientMixin{
  late final FlexSetupViewModel _viewModel;
  ListDataItem<String>? _selectedAmountPill;
  final List<ListDataItem<String>> amountPills = List.generate(4, (index) => ListDataItem((5000 * (index + 1)).formatCurrencyWithoutLeadingZero));
  final TextEditingController _flexSavingNameController = TextEditingController();

  final _savingModes = FlexSaveMode.values.map((e) {
    final title = describeEnum(e);
    return ComboItem(e, title.toLowerCase().capitalizeFirstOfEach);
  });

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
                  })
          ));
      if(index != amountPills.length -1) pills.add(SizedBox(width: 8,));
    });
    return pills;
  }

  TextStyle getBoldStyle(
      {double fontSize = 32.5,
        Color color = Colors.textColorBlack,
        FontWeight fontWeight = FontWeight.w700}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  @override
  void initState() {
    _viewModel = Provider.of<FlexSetupViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "Set a name for this Flex",
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 12),
          StreamBuilder(
              stream: _viewModel.savingNameStream,
              builder: (context, AsyncSnapshot<String?> snapshot) {
                return Styles.appEditText(
                    controller: _flexSavingNameController.withDefaultValueFromStream(
                        snapshot, _viewModel.flexSavingName
                    ),
                    errorText: snapshot.hasError ? snapshot.error.toString() : null,
                    onChanged: _viewModel.setFlexSavingName,
                    hint: 'Title',
                    animateHint: false,
                    fontSize: 15,
                    fillColor: Color(0XFFA5C097).withOpacity(0.15)
                );
              }),
          SizedBox(height: 32),
          Container(
            child: Text(
              "How frequently would you like to save?",
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 12),
          StreamBuilder(
            stream: _viewModel.savingModeStream,
            builder: (ctx, snapshot) {
              final modes = FlexSaveMode.values.map((e) {
                final isSelected = (_viewModel.flexSaving?.configCreated == true)
                    ? e == _viewModel.savingMode
                    : e == FlexSaveMode.MONTHLY;

                final title = describeEnum(e);
                print("Round Mode <<===>> $title");
                print("Round Mode <<===>> $isSelected");
                return ComboItem<FlexSaveMode>(
                    e,
                    title.toLowerCase().capitalizeFirstOfEach,
                  isSelected: isSelected
                );
              }).toList();
              return SelectionCombo<FlexSaveMode>(
                modes, (item, index) => _viewModel.setSavingMode(item),
                checkBoxPosition: CheckBoxPosition.leading,
                shouldUseAlternateDecoration: true,
                primaryColor: Colors.solidGreen,
                backgroundColor: savingsGreen.withOpacity(0.15),
                horizontalPadding: 11 ,
              );
            },
          ),
          SizedBox(height: 32),
          StreamBuilder(
            stream: _viewModel.savingModeStream,
            builder: (ctx, AsyncSnapshot<FlexSaveMode?> snapShot) {
              final appendString = (_viewModel.savingMode == FlexSaveMode.WEEKLY) ? " per week" :" per month";
              return Text(
                "How much would you like to save$appendString?",
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
              );
            },
          ),
          SizedBox(height: 13),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 26 ),
            decoration: BoxDecoration(
                color: savingsGreen.withOpacity(0.15),
                borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            child: PaymentAmountView(
              ((_viewModel.amount ?? 0.0) * 100).toInt(),
              (value) => _viewModel.setAmount(value / 100),
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
          UserAccountSelectionView(
            _viewModel,
            onAccountSelected: (account) => _viewModel.setSourceAccount(account),
            selectedUserAccount: _viewModel.sourceAccount,
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
              buttonStyle: Styles.savingsFlexButtonStyle.copyWith(
                textStyle: MaterialStateProperty.all(
                    getBoldStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white)
                )
              ),
              stream: _viewModel.isValid,
              onClick: () => _viewModel.moveToNext(widget.position),
              text: 'Next'
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
