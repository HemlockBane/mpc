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

import '../colors.dart';
import '../payment_view_model.dart';
import '../styles.dart';
import '../tuple.dart';

class TransactionAccountSource extends StatelessWidget {

  final BaseViewModel viewModel;

  TransactionAccountSource(this.viewModel);

  Widget boxContainer(Widget child) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 24, top: 12, bottom: 12),
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
                  onItemSelected: (item, i) => (viewModel as PaymentViewModel).setSourceAccount(item),
                  titleIcon: SelectionCombo2.initialView(),
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
            child: Container(
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
            )
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
                      return Text(
                        'Balance - $balance',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.deepGrey, fontSize: 13, fontFamily: Styles.defaultFont, fontFamilyFallback: ["Roboto"]),)
                          .colorText({"$balance" : Tuple(Colors.deepGrey, null)}, underline: false);
                    })
              ],
            )
        ),
        SizedBox(width: 17,),
        Expanded(
            flex: 0,
            child: SvgPicture.asset(
                'res/drawables/ic_check_mark_round.svg',
                width: 26,
                height: 26
            )
        )
      ],
    ));
  }

}