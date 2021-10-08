import 'package:flutter/material.dart' hide Card;
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/account_transaction_detail_view_model.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/transaction_list_view_model.dart';
import 'package:moniepoint_flutter/app/accounts/views/account_transaction_detailed_view.dart';
import 'package:moniepoint_flutter/app/accounts/views/account_transactions_view.dart';
import 'package:moniepoint_flutter/app/accounts/views/block_account_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/account_status_screen.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/account_update_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_blocked_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_restriction_screen.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_status_regularize_documents.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_upgrade_info_screen.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_upgrade_progress_screen.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/airtime_history_detail_view_model.dart';
import 'package:moniepoint_flutter/app/airtime/views/airtime_history_detailed_view.dart';
import 'package:moniepoint_flutter/app/airtime/views/airtime_view.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_history_detail_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_history_detailed_view.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_view.dart';
import 'package:moniepoint_flutter/app/branches/branch_search_view.dart';
import 'package:moniepoint_flutter/app/branches/branches_view.dart';
import 'package:moniepoint_flutter/app/branches/viewmodels/branch_view_model.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/card_activation_view_model.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/card_issuance_view_model.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/app/cards/views/card_detailed_view.dart';
import 'package:moniepoint_flutter/app/cards/views/card_view.dart';
import 'package:moniepoint_flutter/app/cards/views/manage_card_channels_view.dart';
import 'package:moniepoint_flutter/app/cards/views/issuance/card_activation_view.dart';
import 'package:moniepoint_flutter/app/cards/views/issuance/card_qr_code_scanner_view.dart';
import 'package:moniepoint_flutter/app/cards/views/unblock_debit_card_view.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_view.dart';
import 'package:moniepoint_flutter/app/devicemanagement/viewmodels/user_device_view_model.dart';
import 'package:moniepoint_flutter/app/devicemanagement/views/user_device_list_view.dart';
import 'package:moniepoint_flutter/app/liveliness/liveliness_verification.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'package:moniepoint_flutter/app/login/views/login_view.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/app/login/views/support_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/views/airtime_select_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/views/bill_select_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/managed_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/views/transfer_select_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/signup_account_view.dart';
import 'package:moniepoint_flutter/app/settings/settings_view.dart';
import 'package:moniepoint_flutter/app/transfers/viewmodels/transfer_detail_view_model.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_detailed_view.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_view.dart';
import 'package:moniepoint_flutter/core/models/TransactionRequestContract.dart';
import 'package:moniepoint_flutter/core/viewmodels/contacts_view_model.dart';
import 'package:moniepoint_flutter/core/viewmodels/system_configuration_view_model.dart';
import 'package:moniepoint_flutter/core/views/contacts_view.dart';
import 'package:provider/provider.dart';

class Routes {
  static const LOGIN  = "/login";
  static const SIGN_UP  = "/sign-up";
  static const REGISTER_NEW_ACCOUNT  = "REGISTER_NEW_ACCOUNT";
  static const ACCOUNT_RECOVERY  = "ACCOUNT_RECOVERY";
  static const DASHBOARD  = "DASHBOARD";
  static const LIVELINESS  = "LIVELINESS";
  static const TRANSFER  = "TRANSFER";
  static const AIRTIME  = "AIRTIME";
  static const AIRTIME_DETAIL  = "AIRTIME_DETAIL";
  static const BILL  = "BILL";
  static const BILL_DETAIL  = "BILL_DETAIL";
  static const TRANSFER_DETAIL  = "TRANSFER_DETAIL";
  static const ACCOUNT_TRANSACTIONS  = "ACCOUNT_TRANSACTIONS";
  static const ACCOUNT_TRANSACTIONS_DETAIL  = "ACCOUNT_TRANSACTIONS_DETAIL";
  static const SETTINGS  = "SETTINGS";
  static const MANAGED_BENEFICIARIES  = "MANAGED_BENEFICIARIES";
  static const SUPPORT  = "SUPPORT";
  static const BRANCHES  = "BRANCHES";
  static const BRANCHES_SEARCH  = "BRANCHES_SEARCH";
  static const CARDS  = "CARDS";
  static const CARD_DETAIL = "CARD_DETAIL";
  static const CARD_ACTIVATION = "CARD_ACTIVATION";
  static const MANAGE_CARD_CHANNELS = "MANAGE_CARD_CHANNELS";
  static const CARD_QR_SCANNER = "CARD_QR_SCANNER";
  static const CONTACTS  = "CONTACTS";
  static const SELECT_AIRTIME_BENEFICIARY  = "SELECT_AIRTIME_BENEFICIARY";
  static const SELECT_TRANSFER_BENEFICIARY  = "SELECT_TRANSFER_BENEFICIARY";
  static const SELECT_BILL_BENEFICIARY  = "SELECT_BILL_BENEFICIARY";
  static const BLOCK_ACCOUNT  = "BLOCK_ACCOUNT";
  static const UNBLOCK_DEBIT_CARD = "UNBLOCK_DEBIT_CARD";
  static const REGISTERED_DEVICES = "REGISTERED_DEVICES";
  static const LIVELINESS_DETECTION = "LIVELINESS_DETECTION";

  static const ACCOUNT_UPDATE  = "ACCOUNT_UPDATE";
  static const ACCOUNT_PND_STATE  = "ACCOUNT_PND_STATE";
  static const ACCOUNT_BLOCKED_STATE  = "ACCOUNT_BLOCKED_STATE";
  static const ACCOUNT_REGULARIZE_DOCS  = "ACCOUNT_REGULARIZE_DOCS";
  static const ACCOUNT_IN_PROGRESS_STATE  = "ACCOUNT_IN_PROGRESS_STATE";
  static const ACCOUNT_UPGRADE_REQUIRED_STATE  = "ACCOUNT_UPGRADE_REQUIRED_STATE";
  static const ACCOUNT_STATUS  = "ACCOUNT_STATUS";


  static Map<String, WidgetBuilder> buildRouteMap(SystemConfigurationViewModel systemConfigurationViewModel) {
    return {
      '/login': (BuildContext context) => LoginScreen(),
      '/sign-up': (BuildContext context) => SignUpAccountScreen(),
      Routes.REGISTER_NEW_ACCOUNT: (BuildContext context) => Scaffold(body: SignUpAccountScreen()),
      Routes.ACCOUNT_RECOVERY: (BuildContext context) => Scaffold(body: RecoveryControllerScreen()),
      Routes.DASHBOARD: (BuildContext context) => DashboardScreen(),
      Routes.ACCOUNT_UPDATE: (BuildContext context) => Scaffold(body: AccountUpdateScreen()),
      Routes.TRANSFER_DETAIL: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => TransferDetailViewModel(),
        child: TransferDetailedView(),
      ),
      Routes.AIRTIME_DETAIL: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => AirtimeHistoryDetailViewModel(),
        child: AirtimeHistoryDetailedView(),
      ),
      Routes.CONTACTS: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => ContactsViewModel(),
        child: ContactScreen(),
      ),
      Routes.BILL: (BuildContext context) => BillScreen(),
      Routes.BILL_DETAIL: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => BillHistoryDetailViewModel(),
        child: BillHistoryDetailedView(),
      ),
      Routes.ACCOUNT_TRANSACTIONS_DETAIL: (BuildContext context) =>
          ChangeNotifierProvider(
            create: (_) => AccountTransactionDetailViewModel(),
            child: AccountTransactionDetailedView(),
          ),

      Routes.SETTINGS: (BuildContext context) => SettingsScreen(),
      Routes.MANAGED_BENEFICIARIES: (BuildContext context) => ManagedBeneficiaryScreen(),
      Routes.SUPPORT: (BuildContext context) => ChangeNotifierProvider.value(
        value: systemConfigurationViewModel,
        child: SupportScreen(),
      ),
      Routes.BRANCHES: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => BranchViewModel(),
        child: BranchScreen(),
      ),
      Routes.BRANCHES_SEARCH: (BuildContext context) => ChangeNotifierProvider(
            create: (_) => BranchViewModel(),
            child: BranchSearchScreen(),
      ),
      Routes.CARDS: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => SingleCardViewModel(),
        child: CardScreen(),
      ),
      Routes.SELECT_AIRTIME_BENEFICIARY: (BuildContext context) => AirtimeSelectBeneficiaryScreen(),
      Routes.SELECT_TRANSFER_BENEFICIARY: (BuildContext context) => TransferSelectBeneficiaryScreen(),
      Routes.SELECT_BILL_BENEFICIARY: (BuildContext context) => BillSelectBeneficiaryScreen(),
      Routes.BLOCK_ACCOUNT: (BuildContext context) => BlockAccountScreen(),
      Routes.UNBLOCK_DEBIT_CARD: (BuildContext context) => UnblockDebitCardScreen(),
      Routes.REGISTERED_DEVICES: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => UserDeviceViewModel(),
        child: UserDeviceListView(),
      ),
    };
  }

  static MaterialPageRoute? generateRouteWithSettings(RouteSettings settings) {
    switch (settings.name) {
      case Routes.ACCOUNT_TRANSACTIONS:
        final userAccountId = (settings.arguments as Map?)?["userAccountId"];
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => TransactionHistoryViewModel(),
              child: AccountTransactionScreen(
                userAccountId: userAccountId,
              ),
            ),
        );
      case Routes.TRANSFER:
        final contract = (settings.arguments is TransactionRequestContract)
            ? settings.arguments as TransactionRequestContract?
            : null;
        return MaterialPageRoute(
            builder: (_) => TransferScreen(transactionRequestContract: contract)
        );
      case Routes.AIRTIME:
        final contract = (settings.arguments is TransactionRequestContract)
            ? settings.arguments as TransactionRequestContract?
            : null;
        return MaterialPageRoute(
            builder: (_) => AirtimeScreen(transactionRequestContract: contract)
        );
      case Routes.LIVELINESS_DETECTION:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => LivelinessVerificationViewModel(),
              child: LivelinessVerification(
                  settings.arguments as Map<String, dynamic>),
            ));
      case Routes.CARD_DETAIL:
        final args = settings.arguments as Map<dynamic, dynamic>;
        final cardId = args["id"] as num;
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => SingleCardViewModel(),
              child: CardDetailedView(cardId),
            )
        );
      case Routes.MANAGE_CARD_CHANNELS:
        final args = settings.arguments as Map<dynamic, dynamic>;
        final cardId = args["id"] as num;
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => SingleCardViewModel(),
              child: ManageCardChannelView(cardId),
            )
        );
      case Routes.CARD_ACTIVATION:
        final args = settings.arguments as Map<dynamic, dynamic>;
        final cardId = args["id"] as num;
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => CardActivationViewModel(),
              child: CardActivationView(cardId),
            )
        );
        case Routes.CARD_QR_SCANNER:
          final args = settings.arguments as Map<dynamic, dynamic>;
          final customerAccountId = args["customerAccountId"] as num;
          return MaterialPageRoute(
            builder: (BuildContext context) => ChangeNotifierProvider(
              create: (_) => CardIssuanceViewModel(),
              child: CardQRCodeScannerView(customerAccountId),
        ));
      case Routes.ACCOUNT_PND_STATE:
        final args = settings.arguments as Map<dynamic, dynamic>;
        final userAccountId = args["userAccountId"] as int;
        return MaterialPageRoute(
            builder: (BuildContext context) => AccountRestrictionScreen(
                userAccountId: userAccountId
            )
        );
      case Routes.ACCOUNT_BLOCKED_STATE:
        final args = settings.arguments as Map<dynamic, dynamic>;
        final userAccountId = args["userAccountId"] as int;
        return MaterialPageRoute(
            builder: (BuildContext context) => AccountBlockedView(
                userAccountId: userAccountId
            )
        );
      case Routes.ACCOUNT_IN_PROGRESS_STATE:
        final args = settings.arguments as Map<dynamic, dynamic>;
        final userAccountId = args["userAccountId"] as int;
        return MaterialPageRoute(
            builder: (BuildContext context) => AccountUpgradeProgressScreen(
                userAccountId: userAccountId
            )
        );
      case Routes.ACCOUNT_UPGRADE_REQUIRED_STATE:
        final args = settings.arguments as Map<dynamic, dynamic>;
        final userAccountId = args["userAccountId"] as int;
        return MaterialPageRoute(
            builder: (BuildContext context) => AccountUpgradeInfoScreen(
                userAccountId: userAccountId
            )
        );
      case Routes.ACCOUNT_REGULARIZE_DOCS:
        final args = settings.arguments as Map<dynamic, dynamic>;
        final userAccountId = args["userAccountId"] as int;
        return MaterialPageRoute(
            builder: (BuildContext context) => AccountStatusRegularizeDocumentScreen(
                userAccountId: userAccountId
            )
        );
      case Routes.ACCOUNT_STATUS:
        return MaterialPageRoute(
            builder: (BuildContext context) => ChangeNotifierProvider(
                create: (_) => AccountUpdateViewModel(),
                child: AccountStatusScreen(),
            )
        );
    }
    return null;
  }
}
