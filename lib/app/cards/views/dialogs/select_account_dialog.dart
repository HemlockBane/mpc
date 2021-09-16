import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/main.dart';

///@author Paul Okeke
class SelectAccountDialog extends StatelessWidget  {

  final List<UserAccount> userAccounts;
  final Stream<Resource<dynamic>> Function(UserAccount account) onItemClick;
  final ValueNotifier<Tuple<Resource<dynamic>, int>?> _notifier = ValueNotifier(null);

  SelectAccountDialog({
    required this.userAccounts,
    required this.onItemClick
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet2(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerBackgroundPadding: 18,
        dialogIcon: SvgPicture.asset(
          'res/drawables/ic_bank.svg',
          width: 40,
          height: 40,
          color: Colors.primaryColor,
        ),
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.only(left: 0, right: 0, top: 26),
              child: Column(
                children: [
                  Text("Select Account",
                      style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      )
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 300,
                    child: ListView.separated(
                      itemCount: userAccounts.length,
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Divider(color: Color(0XFFE8F0F6), height: 1, thickness: 0.5,),
                      ),
                      itemBuilder: (mContext, index) {
                        return _AccountItem(
                            userAccount: userAccounts[index],
                            onItemClick: onItemClick,
                            position: index,
                            notifier: _notifier,
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }

}

///SelectAccountDialog
///
///
///
///
class _AccountItem extends StatelessWidget {

  final UserAccount userAccount;
  final Stream<Resource<dynamic>> Function(UserAccount account) onItemClick;
  final int position;
  final ValueNotifier<Tuple<Resource<dynamic>, int>?> notifier;

  _AccountItem({
    required this.userAccount,
    required this.onItemClick,
    required this.position,
    required this.notifier
  });

  Widget initialView() {
    return Stack(
      children: [
        SvgPicture.asset(
          "res/drawables/ic_m_bg.svg",
          fit: BoxFit.cover,
          height: 54,
          width: 54,
          color: Colors.primaryColor.withOpacity(0.11),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: Text(
                userAccount.customerAccount?.accountName?.abbreviate(2, true, includeMidDot: false) ?? "",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.primaryColor, fontSize: 19)
            ),
          ),
        )
      ],
    );
  }

  void _onItemClick() {
    onItemClick.call(userAccount).listen((event) {
        notifier.value = Tuple(event, position);
        if(event is Success) {
          navigatorKey.currentState?.pop(Tuple(event, userAccount));
        } else if (event is Error){
          navigatorKey.currentState?.pop(Tuple(event, userAccount));
        }
    });
  }

  Widget _getTrailingIcon (Resource<dynamic>? data , int clickPosition) {
    if((data != null && clickPosition == position) && data is Loading) {
      return Lottie.asset(
          'res/drawables/progress_bar_lottie.json',
          width: 20, height: 20
      );
    }
    return SvgPicture.asset(
        'res/drawables/ic_forward_anchor.svg',
        width: 13.5,
        height: 13.5,
        color: Colors.primaryColor.withOpacity(0.9)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ValueListenableBuilder(
          valueListenable: notifier,
          builder: (a, Tuple<Resource<dynamic>, int>? tupleData, _) {
            final data = tupleData?.first;
            final clickPosition = tupleData?.second;
            return InkWell(
              onTap: tupleData == null ? _onItemClick : null,
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
                child: Row(
                  children: [
                    initialView(),
                    SizedBox(width: 16),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  userAccount.customerAccount?.accountName ?? "",
                                  style: TextStyle(fontSize: 15, color: Colors.textColorBlack, fontWeight: FontWeight.bold)
                              ),
                              SizedBox(height: 4),
                              Text(
                                  "${userAccount.accountProvider?.name} ${userAccount.customerAccount?.accountNumber}",
                                  style: TextStyle(fontSize: 14, color: Colors.textColorBlack.withOpacity(0.5), fontWeight: FontWeight.normal)
                              )
                            ]
                        )),
                    _getTrailingIcon(data, clickPosition ?? 0),
                    SizedBox(width: 2),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

}






///Helper to display multiple accounts
///
///
///
Future<dynamic> showCustomerAccounts({
  required BuildContext context,
  required List<UserAccount> userAccounts,
  required Stream<Resource<dynamic>> Function(UserAccount account) onItemClick
}) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SelectAccountDialog(
          userAccounts: userAccounts,
          onItemClick: onItemClick
      )
  );
}
