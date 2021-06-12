import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

class AccountUpdateDialog extends StatefulWidget {

  final Tier tier;

  AccountUpdateDialog(this.tier);

  @override
  State<StatefulWidget> createState() => _AccountUpdateDialog();
}


class _AccountUpdateDialog extends State<AccountUpdateDialog> {

  bool _isLoading = false;

  void _subscribeToUpgradeAccount(AccountUpdateViewModel viewModel) {
    viewModel.updateAccount().listen((event) {
      if(event is Loading) {
        setState(() {_isLoading = true;});
      }
      else if(event is Success) {
        setState(() {_isLoading = false;});
        Navigator.of(context).pop(event.data);
      }
      else if(event is Error<Tier>) {
        setState(() {_isLoading = false;});
        Navigator.of(context).pop(event);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);

    return BottomSheets.makeAppBottomSheet(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_bank.svg',
        centerImageColor: Colors.primaryColor,
        content: Wrap(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20,),
                  Text(
                    'Based on information provided,\nYou will be upgraded to',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0XFF4F4F4F)),
                  ),
                  SizedBox(height: 8,),
                  Text(
                    '${widget.tier.name?.replaceAll("Customers", "")}',
                    style: TextStyle(color: Colors.darkBlue, fontSize: 18,fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 24,),
                  Container(
                    margin: EdgeInsets.only(left: 16,right: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 50, left: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Daily Debit Limit:',
                                  style: TextStyle(color: Color(0XFF4F4F4F), fontSize: 16)
                              ),
                              Text("${widget.tier.maximumDailyDebit?.formatCurrency}",
                                  style: TextStyle(
                                      color: Color(0XFF4F4F4F),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  )
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 8,),
                        Divider(height: 1, color: Colors.primaryColor.withOpacity(0.2), thickness: 0.5,),
                        SizedBox(height: 8,),
                        Container(
                          padding: EdgeInsets.only(right: 50, left: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Balance Limit: ', style: TextStyle(color: Color(0XFF4F4F4F),fontSize: 16),),
                              Text("${widget.tier.maximumCumulativeBalance?.formatCurrency}", style: TextStyle(
                                  color: Color(0XFF4F4F4F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24,),
                  Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                    child: Styles.statefulButton2(
                        isValid: true,
                        onClick: () => _subscribeToUpgradeAccount(viewModel),
                        isLoading: _isLoading,
                        text: 'Upgrade Account'
                    ),
                  ),
                  SizedBox(height: 26,),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Dismiss',
                        style: TextStyle(color: Colors.primaryColor, fontSize: 14, fontWeight: FontWeight.bold)
                      )
                  ),
                  SizedBox(height: 26,),
                ],
              ),
            )
          ],
        )
    );
  }

}