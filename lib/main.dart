import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/account_transaction_detail_view_model.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/transaction_list_view_model.dart';
import 'package:moniepoint_flutter/app/accounts/views/account_transaction_detailed_view.dart';
import 'package:moniepoint_flutter/app/accounts/views/account_transactions_view.dart';
import 'package:moniepoint_flutter/app/accounts/views/block_account_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/account_update_view.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/airtime_history_detail_view_model.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/service_provider_view_model.dart';
import 'package:moniepoint_flutter/app/airtime/views/airtime_history_detailed_view.dart';
import 'package:moniepoint_flutter/app/airtime/views/airtime_view.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_history_detail_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_history_detailed_view.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_view.dart';
import 'package:moniepoint_flutter/app/branches/branch_search_view.dart';
import 'package:moniepoint_flutter/app/branches/branch_search_view_old.dart';
import 'package:moniepoint_flutter/app/branches/branches_view.dart';
import 'package:moniepoint_flutter/app/branches/branches_view_old.dart';
import 'package:moniepoint_flutter/app/branches/viewmodels/branch_view_model.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/app/cards/views/card_view.dart';
import 'package:moniepoint_flutter/app/cards/views/unblock_debit_card_view.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_view.dart';
import 'package:moniepoint_flutter/app/devicemanagement/viewmodels/user_device_view_model.dart';
import 'package:moniepoint_flutter/app/devicemanagement/views/user_device_list_view.dart';
import 'package:moniepoint_flutter/app/liveliness/liveliness_verification.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/login_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/login_view.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/app/login/views/support_view.dart';
import 'package:moniepoint_flutter/app/login/views/support_view_old.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/views/airtime_select_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/views/bill_select_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/managed_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/views/transfer_select_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/onboarding/views/existing/existing_account_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/liveliness_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/signup_account_view.dart';
import 'package:moniepoint_flutter/app/transfers/viewmodels/transfer_detail_view_model.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_detailed_view.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/di/service_module.dart';
import 'package:moniepoint_flutter/core/di/db_module.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/contacts_view_model.dart';
import 'package:moniepoint_flutter/core/viewmodels/system_configuration_view_model.dart';
import 'package:moniepoint_flutter/core/views/contacts_view.dart';
import 'package:provider/provider.dart';

import 'app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'app/settings/settings_view.dart';

//We need to move this to some where else
final defaultAppTheme = ThemeData(
    disabledColor: Colors.primaryColor.withOpacity(0.5),
    primaryColor: Colors.primaryColor,
    backgroundColor: Colors.backgroundWhite,
    fontFamily: Styles.defaultFont,
    textTheme: TextTheme(
        bodyText2: TextStyle(
            fontFamily: Styles.defaultFont, fontFamilyFallback: ["Roboto"])));

class MoniepointApp extends StatelessWidget {
  // This widget is the root of your application
  void _loadSystemConfigurations(SystemConfigurationViewModel viewModel) {
    viewModel.getSystemConfigurations().listen((event) {
      print('Getting SystemConfiguration in main');
    });

    viewModel.getUSSDConfiguration().listen((event) {
      print('Getting USSDConfiguration in main');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    }

    final systemConfigViewModel = SystemConfigurationViewModel();
    _loadSystemConfigurations(systemConfigViewModel);

    String? savedUsername = PreferenceUtil.getSavedUsername();
    return MaterialApp(
      title: 'Moniepoint Customers',
      theme: defaultAppTheme,
      home: Scaffold(
        body: (savedUsername == null || savedUsername.isEmpty)
            ? SignUpAccountScreen()
            : LoginScreen(),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.ACCOUNT_TRANSACTIONS:
            final customerAccountId =
                (settings.arguments as Map?)?["customerAccountId"];
            return MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                      create: (_) => TransactionHistoryViewModel(),
                      child: AccountTransactionScreen(
                          customerAccountId: customerAccountId),
                    ));
          case Routes.LIVELINESS_DETECTION:
            // final verificationFor = (settings.arguments as Map?)?["verificationFor"] as LivelinessVerificationFor;
            return MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                      create: (_) => LivelinessVerificationViewModel(),
                      child: LivelinessVerification(
                          settings.arguments as Map<String, dynamic>),
                    ));
        }
        return null;
      },
      //TODO consider moving this to a separate file
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
        '/sign-up': (BuildContext context) => SignUpAccountScreen(),
        // Routes.ONBOARDING_PHONE_NUMBER_VALIDATION: (BuildContext context) => ChangeNotifierProvider(
        //   create: (_) => OnBoardingViewModel(),
        //   child: PhoneNumberValidationScreen(),
        // ),
        Routes.REGISTER_EXISTING_ACCOUNT: (BuildContext context) =>
            Scaffold(body: ExistingAccountView()),
        Routes.REGISTER_NEW_ACCOUNT: (BuildContext context) =>
            Scaffold(body: SignUpAccountScreen()),
        Routes.ACCOUNT_RECOVERY: (BuildContext context) =>
            Scaffold(body: RecoveryControllerScreen()),
        Routes.DASHBOARD: (BuildContext context) => ChangeNotifierProvider(
              create: (_) => ServiceProviderViewModel(),
              child: DashboardScreen(),
            ),
        Routes.ACCOUNT_UPDATE: (BuildContext context) =>
            Scaffold(body: AccountUpdateScreen()),
        Routes.LIVELINESS: (BuildContext context) =>
            Scaffold(body: LivelinessScreen()),
        Routes.TRANSFER: (BuildContext context) => TransferScreen(),
        Routes.TRANSFER_DETAIL: (BuildContext context) =>
            ChangeNotifierProvider(
              create: (_) => TransferDetailViewModel(),
              child: TransferDetailedView(),
            ),
        Routes.AIRTIME: (BuildContext context) => AirtimeScreen(),
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
        Routes.MANAGED_BENEFICIARIES: (BuildContext context) =>
            ManagedBeneficiaryScreen(),
        Routes.SUPPORT: (BuildContext context) => ChangeNotifierProvider.value(
              value: systemConfigViewModel,
              child: SupportScreen(),
            ),
        Routes.BRANCHES: (BuildContext context) => ChangeNotifierProvider(
              create: (_) => BranchViewModel(),
              child: BranchScreen(),
            ),
        Routes.BRANCHES_SEARCH: (BuildContext context) =>
            ChangeNotifierProvider(
              create: (_) => BranchViewModel(),
              child: BranchSearchScreen(),
            ),
        Routes.CARDS: (BuildContext context) => ChangeNotifierProvider(
              create: (_) => SingleCardViewModel(),
              child: CardScreen(),
            ),
        Routes.SELECT_AIRTIME_BENEFICIARY: (BuildContext context) =>
            AirtimeSelectBeneficiaryScreen(),
        Routes.SELECT_TRANSFER_BENEFICIARY: (BuildContext context) =>
            TransferSelectBeneficiaryScreen(),
        Routes.SELECT_BILL_BENEFICIARY: (BuildContext context) =>
            BillSelectBeneficiaryScreen(),
        Routes.BLOCK_ACCOUNT: (BuildContext context) => BlockAccountScreen(),
        Routes.UNBLOCK_DEBIT_CARD: (BuildContext context) =>
            UnblockDebitCardScreen(),
        Routes.REGISTERED_DEVICES: (BuildContext context) =>
            ChangeNotifierProvider(
              create: (_) => UserDeviceViewModel(),
              child: UserDeviceListView(),
            ),
      },
    );
  }
}

void main() async {
  await _onCreate();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ChangeNotifierProvider(create: (_) => DashboardViewModel()),
    ],
    child: MoniepointApp(),
  ));
}

Future<void> _onCreate() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseModule.inject();
  ServiceModule.inject();

  await Firebase.initializeApp();
  await PreferenceUtil.initAsync();
}
