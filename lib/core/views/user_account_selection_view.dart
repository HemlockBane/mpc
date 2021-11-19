
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/views/selection_combo_two.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';


import '../colors.dart';
import '../styles.dart';
import '../tuple.dart';
import 'icon_curved_container.dart';

class UserAccountSelectionView extends StatefulWidget {

  final BaseViewModel viewModel;
  final ListStyle listStyle;
  final TextStyle? titleStyle;
  final Color? primaryColor;
  final Color? checkBoxBorderColor;
  final Size? checkBoxSize;
  final EdgeInsets? checkBoxPadding;
  final bool isShowTrailingWhenExpanded;
  final ValueChanged<UserAccount?> onAccountSelected;
  final UserAccount? selectedUserAccount;
  final bool isExpanded;


  UserAccountSelectionView(this.viewModel, {
    this.listStyle = ListStyle.normal,
    required this.onAccountSelected,
    this.primaryColor,
    this.checkBoxBorderColor,
    this.checkBoxSize,
    this.checkBoxPadding,
    this.isShowTrailingWhenExpanded = true,
    this.titleStyle = const TextStyle(color: Colors.textColorBlack, fontWeight: FontWeight.w700, fontSize: 15),
    this.selectedUserAccount,
    this.isExpanded = true
  });

  @override
  State<UserAccountSelectionView> createState() => _UserAccountSelectionViewState();
}

class _UserAccountSelectionViewState extends State<UserAccountSelectionView> {
  bool isDefaultStyle() =>  widget.listStyle == ListStyle.normal;

  Widget boxContainer(Widget child) {
    final defaultPadding = EdgeInsets.only(left: 11.87, right: 19.23, top: 14.25, bottom: 14.17);
    return Container(
      padding: defaultPadding,
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

  Widget getAlternateIcon(String? name){
    if (name == null) return getDefaultIcon();
    final color = widget.primaryColor ?? Colors.primaryColor;
    return IconCurvedContainer(
      width: 53,
      height: 53,
      backgroundColor: color.withOpacity(0.1),
      child: Center(
        child: Text(
          name.abbreviate(2, true, includeMidDot: false),
          style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: color
          ),
        ),
      ),
    );
  }

  Widget getAlternateSubtitle({required String text1, required String? tex2}){
    return Row(
      children: [
        Text(
          text1,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.textColorBlack.withOpacity(0.5),
              fontSize: 13
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Text("$tex2",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.textColorBlack.withOpacity(0.5),
              fontSize: 13,
              fontWeight: FontWeight.w600
          ),
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
              color: widget.primaryColor ?? Colors.solidGreen,
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.viewModel.userAccounts.length > 1) {
      return Flexible(
          flex:0,
          child: StreamBuilder(
              stream: widget.viewModel.getUserAccountsBalance().map((event) {
                if(event.data == null) return <AccountBalance>[];
                return event.data!.map((e) => e.accountBalance).toList();
              }),
              builder: (BuildContext context, AsyncSnapshot<List<AccountBalance?>> snapShot) {
                if(!snapShot.hasData || snapShot.data == null){
                  return SizedBox();
                }

                final List<AccountBalance?> accounts = snapShot.data ?? [];
                final userAccounts = widget.viewModel.userAccounts;

                final comboItems = accounts.mapIndexed((index, element) {
                  final userAccount = userAccounts[index];
                  final accountNumber = userAccount.customerAccount?.accountNumber;
                  final formattedBalance = userAccount.accountBalance?.availableBalance?.formatCurrency ?? "--";
                  return ComboItem<UserAccount>(
                      userAccount, "${userAccount.customerAccount?.accountName}",
                      subTitle: "$accountNumber - $formattedBalance",
                      isSelected: widget.selectedUserAccount?.id == userAccount.id
                  );
                }).toList();

                return SelectionCombo2<UserAccount>(
                  comboItems,
                  defaultTitle: "Select an Account",
                  titleStyle: widget.titleStyle,
                  onItemSelected: (item, i) => widget.onAccountSelected(item),
                  titleIcon: (a) => getAlternateIcon(a?.customerAccount?.accountName),
                  primaryColor: widget.primaryColor ?? Colors.primaryColor,
                  checkBoxBorderColor: widget.checkBoxBorderColor ?? Colors.primaryColor,
                  checkBoxSize: widget.checkBoxSize,
                  checkBoxPadding: widget.checkBoxPadding,
                  listStyle: widget.listStyle,
                  trailingWidget: !isDefaultStyle() ? getAlternateTrailingWidget() : null,
                  isShowTrailingWhenExpanded: widget.isShowTrailingWhenExpanded,
                  isExpanded: widget.isExpanded,
                );
              }
          )
      );
    }
    this.widget.onAccountSelected.call(widget.viewModel.userAccounts.first);
    return boxContainer(Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex:0,
            child: getAlternateIcon(widget.viewModel.accountName)
        ),
        SizedBox(width: 17,),
        Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.viewModel.accountName}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 15, color: Colors.solidDarkBlue, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1),
                StreamBuilder(
                    stream: widget.viewModel.getUserAccountsBalance().map((event) {
                      if(event.data == null) return <AccountBalance>[];
                      return event.data!.map((e) => e.accountBalance).toList();
                    }),
                    builder: (context, AsyncSnapshot<List<AccountBalance?>> a) {
                      final balance = (a.hasData) ? a.data?.firstOrNull?.availableBalance?.formatCurrency : "--";
                      final defaultSubtitle = Text(
                        '${widget.viewModel.accountNumber} - $balance',
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.textColorBlack.withOpacity(0.5),
                            fontSize: 13,
                            fontFamily: Styles.defaultFont, fontFamilyFallback: ["Roboto"]
                        )
                      ).colorText({"$balance" : Tuple(Colors.textColorBlack.withOpacity(0.5), null)}, underline: false);
                      return defaultSubtitle;
                    })
              ],
            )
        ),
        SizedBox(width: 17,),
        Visibility(
          visible: widget.listStyle == ListStyle.normal,
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

  @override
  void dispose() {
    super.dispose();
  }
}

enum ListStyle{normal, alternate}
