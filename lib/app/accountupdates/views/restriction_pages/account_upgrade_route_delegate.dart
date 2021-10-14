import 'package:flutter/cupertino.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/account_upgrade_state.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/routes.dart';

class AccountUpgradeRouteDelegate {

  static Future<void> navigateToAccountUpgrade(BuildContext context, UserAccount userAccount) async {
    final routeArgs = {"userAccountId": userAccount.id};
    final accountState = userAccount.getAccountState();
    if(accountState == AccountState.BLOCKED) {
      await Navigator.of(context).pushNamed(Routes.ACCOUNT_BLOCKED_STATE, arguments: routeArgs);
    }
    else if(accountState == AccountState.PND) {
      await Navigator.of(context).pushNamed(Routes.ACCOUNT_PND_STATE, arguments: routeArgs);
    }
    else if(accountState == AccountState.REQUIRE_DOCS) {
      await Navigator.of(context).pushNamed(Routes.ACCOUNT_REGULARIZE_DOCS, arguments: routeArgs);
    }
    else if(accountState == AccountState.PENDING_VERIFICATION) {
      await Navigator.of(context).pushNamed(Routes.ACCOUNT_IN_PROGRESS_STATE, arguments: routeArgs);
    }
    else if(accountState == AccountState.IN_COMPLETE) {
      await Navigator.of(context).pushNamed(Routes.ACCOUNT_UPGRADE_REQUIRED_STATE, arguments: routeArgs);
    } else {
      return;
    }
  }
}