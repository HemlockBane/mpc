import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/views/selection_combo_two.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';


import '../colors.dart';
import '../payment_view_model.dart';
import '../styles.dart';
import '../tuple.dart';

class TransactionAccountSource extends StatelessWidget {

  final BaseViewModel viewModel;
  final ListStyle listStyle;
  final TextStyle? titleStyle;
  final Color? primaryColor;
  final Color? checkBoxBorderColor;
  final Size? checkBoxSize;
  final EdgeInsets? checkBoxPadding;
  final bool isShowTrailingWhenExpanded;

  TransactionAccountSource(this.viewModel, {
    this.listStyle = ListStyle.normal,
    this.primaryColor,
    this.checkBoxBorderColor,
    this.checkBoxSize,
    this.checkBoxPadding,
    this.isShowTrailingWhenExpanded = true,
    this.titleStyle
  });

  bool isDefaultStyle() =>  listStyle == ListStyle.normal;

  Widget boxContainer(Widget child) {
    final defaultPadding = EdgeInsets.only(left: 16, right: 24, top: 12, bottom: 12);
    final alternatePadding = EdgeInsets.only(
      left: 11.87, right: 19.23, top: 14.25, bottom: 14.17);


    return Container(
      padding: isDefaultStyle() ? defaultPadding : alternatePadding,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0XFF0B3175).withOpacity(0.1), width: 0.8, style: BorderStyle.solid),
          boxShadow: [
            BoxShadow(
                color: Color(0XFF0B3175).withOpacity(0.1),
                offset: Offset(0, 1),
                blurRadius: 1.2
            )
          ]
      ),
      child: child,
    );
  }


  Widget getDefaultIcon(){
    return Container(
      width: 37,
      height: 37,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.darkBlue.withOpacity(0.1)
      ),
      child: Center(
        child: SvgPicture.asset('res/drawables/ic_bank.svg', color: Colors.primaryColor,),
      ),
    );
  }


  Widget getAlternateIcon(String name){
    final color = primaryColor ?? Colors.primaryColor;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          "res/drawables/ic_m_bg.svg",
          fit: BoxFit.cover,
          height: 45,
          width: 45,
          color: color.withOpacity(0.11),
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
              MaterialStateProperty.all(color.withOpacity(0.1)),
              highlightColor: color.withOpacity(0.05),
              // onTap: () => _onItemClicked(context, beneficiary),
              child: Center(
                child: Text(
                  name.abbreviate(2, true, includeMidDot: false),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getAlternateSubtitle({required String text1, required String? tex2}){
    return Row(
      children: [
        Text(
          text1,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.textColorBlack
              .withOpacity(0.5),
            fontSize: 13),
        ),
        SizedBox(
          width: 8,
        ),
        Text("$tex2",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.textColorBlack
              .withOpacity(0.5),
            fontSize: 13,
            fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
  
  Widget getAlternateTrailingWidget(){
    return IgnorePointer(
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Change',
          style: TextStyle(
            color: primaryColor ?? Colors.solidGreen,
            fontSize: 14,
            fontWeight: FontWeight.bold),
        ),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(40, 0)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          overlayColor: MaterialStateProperty.all(
            Colors.solidGreen.withOpacity(0.2)),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 8, vertical: 7)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))),
          backgroundColor:
          MaterialStateProperty.all(Colors.transparent)),
      ),
    );

  }



  @override
  Widget build(BuildContext context) {

    if(viewModel.userAccounts.length > 1) {
      return Flexible(
          flex:0,
          child: StreamBuilder(
              stream: viewModel.accountsBalanceStream,
              builder: (BuildContext context, AsyncSnapshot<Resource<List<AccountBalance?>>> snapShot) {
                if(!snapShot.hasData || snapShot.data?.data == null) return boxContainer(Container());
                final List<AccountBalance?> accounts = snapShot.data!.data ?? [];
                final userAccounts = viewModel.userAccounts;

                final comboItems = accounts.mapIndexed((index, element) {
                  final userAccount = userAccounts[index];
                  final accountNumber = userAccount.customerAccount?.accountNumber;
                  final formattedBalance = userAccount.accountBalance?.availableBalance?.formatCurrency ?? "--";
                  return ComboItem<UserAccount>(
                      userAccount, "${userAccount.customerAccount?.accountName}",
                      subTitle: "$accountNumber - $formattedBalance",
                      isSelected: (viewModel as PaymentViewModel).sourceAccount?.id == userAccount.id
                  );
                }).toList();


                return SelectionCombo2<UserAccount>(
                  comboItems,
                  defaultTitle: "Select an Account",
                  titleStyle: titleStyle,
                  onItemSelected: (item, i) => (viewModel as PaymentViewModel).setSourceAccount(item),
                  titleIcon: SelectionCombo2.initialView(),
                  primaryColor: primaryColor ?? Colors.primaryColor,
                  checkBoxBorderColor: checkBoxBorderColor ?? Colors.primaryColor,
                  checkBoxSize: checkBoxSize,
                  checkBoxPadding: checkBoxPadding,
                  listStyle: listStyle,
                  trailingWidget: !isDefaultStyle() ? getAlternateTrailingWidget() : null,
                  isShowTrailingWhenExpanded: isShowTrailingWhenExpanded,
                );
              }
          )
      );
    }
    (viewModel as PaymentViewModel).setSourceAccount(viewModel.userAccounts.first);
    return boxContainer(Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex:0,
            child: isDefaultStyle() ? getDefaultIcon() : getAlternateIcon(viewModel.accountName)
        ),
        SizedBox(width: 17,),
        Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${viewModel.accountName}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 15, color: Colors.solidDarkBlue, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1,),
                StreamBuilder(
                    initialData: null,
                    stream: viewModel.balanceStream,
                    builder: (context, AsyncSnapshot<AccountBalance?> a) {
                      final balance = (a.hasData) ? a.data?.availableBalance?.formatCurrency : "--";
                      final defaultSubtitle = Text(
                        'Balance - $balance',
                        textAlign: TextAlign.left,
                        style: titleStyle ?? TextStyle(color: Colors.deepGrey, fontSize: 13, fontFamily: Styles.defaultFont, fontFamilyFallback: ["Roboto"]),)
                        .colorText({"$balance" : Tuple(Colors.deepGrey, null)}, underline: false);

                      return listStyle == ListStyle.normal
                        ? defaultSubtitle
                        : getAlternateSubtitle(text1: viewModel.accountNumber, tex2: balance);
                    })
              ],
            )
        ),
        SizedBox(width: 17,),
        Visibility(
          visible: listStyle == ListStyle.normal,
          child: Expanded(
              flex: 0,
              child: SvgPicture.asset(
                  'res/drawables/ic_check_mark_round.svg',
                  width: 26,
                  height: 26
              )
          ),
        )
      ],
    ));
  }

}

enum ListStyle{normal, alternate}