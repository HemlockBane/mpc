import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_top_up_response.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/savings_flex_withdrawal_viewmodel.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/savings_notification_banner.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/selected_transaction_recipient_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/main.dart';
import 'package:provider/provider.dart';

import '../../../../savings_success_view.dart';

class FlexSavingWithdrawalConfirmationView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _FlexSavingWithdrawalConfirmationState();

}

class _FlexSavingWithdrawalConfirmationState extends State<FlexSavingWithdrawalConfirmationView> {

  late final SavingsFlexWithdrawalViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<SavingsFlexWithdrawalViewModel>(context, listen: false);
    super.initState();
  }

  List<Widget> _buildListTiles()  {
    final titleStyle = TextStyle(
      color: Colors.textColorBlack,
      fontSize: 15,
      fontWeight: FontWeight.w500
    );

    final subTitleStyle = TextStyle(
        color: Colors.textColorBlack,
        fontSize: 20,
        fontWeight: FontWeight.w700
    );

    final currentBalance = _viewModel.flexSavingAccount?.accountBalance?.availableBalance;

    return [
      ListTile(
        contentPadding: EdgeInsets.only(left: 22, right: 22, top: 22, bottom: 14),
        title:  Padding(
          padding: EdgeInsets.only(bottom: 3.5),
          child: Text(
            "Withdrawal Amount",
            style: titleStyle,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 3.5),
          child: Text(
            "${(_viewModel.amount ?? 0).formatCurrency}",
            style: subTitleStyle,
          ),
        ),
      ),
      if(currentBalance != null)
        ListTile(
          contentPadding: EdgeInsets.only(left: 22, right: 22, top: 14, bottom: 14),
          title: Padding(
            padding: EdgeInsets.only(bottom: 3.5),
            child: Text(
              "Remaining Balance",
              style: titleStyle,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 3.5),
            child: Text(
              "${(currentBalance - (_viewModel.amount ?? 0)).formatCurrency}",
              style: subTitleStyle,
            ),
          ),
        ),
      ListTile(
        contentPadding: EdgeInsets.only(left: 22, right: 22, top: 27, bottom: 31),
        title: Padding(
          padding: EdgeInsets.only(bottom: 3.5),
          child: Text(
            "Payout Account ",
            style: titleStyle,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 3.5),
          child: SelectedTransactionRecipientView(
            recipientName: _viewModel.sourceAccount?.customerAccount?.accountName ?? "",
            recipientDigits: _viewModel.sourceAccount?.customerAccount?.accountNumber ?? "",
            providerName: _viewModel.sourceAccount?.accountProvider?.name ?? "",
            displayChange: false,
            leadingColor: Colors.solidOrange,
          ),
        ),
      )
    ];
  }

  Widget _displayWithdrawalNotification() {
    final count = _viewModel.flexSavingAccount?.withdrawalCount?.count;
    if(count == null) return SizedBox();
    return SavingsNotificationBanner(
        notificationType: NotificationType.info,
        notificationString: "${_viewModel.flexSavingAccount?.withdrawalCount?.message}"
    );
  }

  void _subscribeUiToWithdraw() {
    if(_viewModel.isLoading) return;
    setState(() {_viewModel.setIsLoading(true);});

    _viewModel.withdraw().listen((event) {
      if(event is Loading) {
        if(_viewModel.isLoading == false) setState(() => _viewModel.setIsLoading(true));
      }
      else if(event is Success) {
        setState(() {_viewModel.setIsLoading(false);});

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => SavingsSuccessView(
              primaryText: "Withdrawal\nSuccessful!",
              secondaryText: "Your Flex Withdrawal was successful!",
              primaryButtonText: "Continue",
              primaryButtonAction: () {
                navigatorKey.currentState?.pushNamedAndRemoveUntil(
                    Routes.SAVINGS_FLEX_DASHBOARD, (route) {
                  return route.settings.name == Routes.FLEX_SAVINGS;
                }, arguments: {"flexSavingId": _viewModel.flexSavingAccount?.id});
              },
            ),
            ),
        );
      }
      else if(event is Error<FlexTopUpResponse>) {
        setState(() { _viewModel.setIsLoading(false); });
        showError(context, title: "Withdrawal Failed!", message: event.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final listTiles = _buildListTiles();
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    return SessionedWidget(
      context: context,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
            centerTitle: false,
            titleSpacing: 0,
            iconTheme: IconThemeData(color: Colors.solidGreen),
            title: Text('Withdrawal Confirmation',
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
        backgroundColor: Color(0XFFF5F5F5),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 21),
          child: ScrollView(
            maxHeight: MediaQuery.of(context).size.height - (70 + bottom),//subtract the vertical padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Container(
                  height: 70,
                  width: 70,
                  padding: EdgeInsets.all(13),
                  child: SvgPicture.asset(
                    "res/drawables/ic_info_italic.svg",
                    color: Colors.solidOrange,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.solidOrange.withOpacity(0.1),
                      shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 19,),
                Text(
                    "Withdrawal Confirmation",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 23,),
                Container(
                  height: 380,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0XFF4A7BC7).withOpacity(0.15), width: 0.7),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0XFF0649AF).withOpacity(0.06),
                            offset: Offset(0, 1),
                            blurRadius: 1
                        )
                      ]
                  ),
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    separatorBuilder: (ctx, index) => Divider(
                      color: Colors.grey.withOpacity(0.4),
                      height: 0.5,
                    ),
                    itemCount: listTiles.length,
                    itemBuilder: (ctx, index) {
                      return listTiles[index];
                    },
                  ),
                ),
                SizedBox(height: 15,),
                _displayWithdrawalNotification(),
                Expanded(child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Styles.statefulButton2(
                        loadingColor: Colors.savingsPrimary.withOpacity(0.5),
                        buttonStyle: Styles.savingsFlexButtonStyle,
                        isLoading: _viewModel.isLoading,
                        isValid: true,
                        onClick: _subscribeUiToWithdraw,
                        text: 'Withdraw Money'
                    )
                )),
                SizedBox(height: 42,)
              ],
            ),
          ),
        ),
      ),
    );
  }

}