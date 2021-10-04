import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_update_flag.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/account_upgrade_state.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/colored_linear_progress_bar.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_status_page_icon.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_status_requirement_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:collection/collection.dart';


class AccountStatusScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AccountStatusScreenState();

}

class _AccountStatusScreenState extends State<AccountStatusScreen> {

  ui.Image? _checkMarkIcon;

  late final AccountUpdateViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<AccountUpdateViewModel>(context,listen: false);
    _viewModel.getOnBoardingSchemes(fetchFromRemote: false).listen((event) { });
    super.initState();

    Future.delayed(Duration(milliseconds: 200), () {
      _viewModel.identificationForm.restoreFormState();
    });
  }

  Future <Null> init() async {
    final ByteData data = await rootBundle.load('res/drawables/ic_check_mark_progress.png');
    _checkMarkIcon = await loadImage(new Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Tier? getCurrentTier() {
    final userAccount = _viewModel.userAccounts.firstOrNull;
    if(userAccount == null || userAccount.customerAccount?.id ==  null) return null;
    final schemeName = _viewModel.getUserQualifiedTierName(userAccount.customerAccount!.id!);
    return _viewModel.tiers.firstWhereOrNull((element) => element.name?.toLowerCase() == schemeName?.toLowerCase());
  }

  AccountState _getAccountState() {
    final userAccount = _viewModel.userAccounts.firstOrNull;
    if(userAccount == null || userAccount.customerAccount?.id ==  null) return AccountState.COMPLETED;
    return userAccount.getAccountState();
  }

  String _getButtonTitleFromState(AccountState accountState) {
    if(accountState == AccountState.PND) {
      return "Fix Account";
    }
    if(accountState == AccountState.IN_COMPLETE){
      return "Fix Account";
    }
    return "Upgrade Account";
  }

  Widget _contentView(AccountState accountState) => SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountStatusPageIcon(
              color: Colors.primaryColor.withOpacity(0.1),
              icon: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.primaryColor
                ),
                child: SvgPicture.asset("res/drawables/ic_bank.svg", color: Colors.white,),
              )
          ),
          SizedBox(height: 15),
          Text(
            "Your Account Status",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.textColorBlack
            ),
          ),
          SizedBox(height: 40),
          _AccountStatusContainer(
            tiers: _viewModel.tiers,
            currentTier: getCurrentTier(),
            checkMarkIcon: _checkMarkIcon,
            accountState: accountState,
          ),
          SizedBox(height: 25),
          Visibility(
            visible: accountState == AccountState.IN_COMPLETE
                || accountState == AccountState.REQUIRE_DOCS
                || accountState == AccountState.PND,
              child: SizedBox(
                width: double.infinity,
                child: Styles.appButton(
                    elevation: 0.3,
                    onClick: () => Navigator.of(context).popAndPushNamed(Routes.ACCOUNT_UPDATE),
                    text: _getButtonTitleFromState(accountState),
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.white
                    )
                ),
              )
          ),
          Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: Column(
                children: [
                  Center(
                      child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Dismiss",
                            style: TextStyle(
                                color: Colors.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600
                            ),
                          )
                      )
                  )
                ],
              )
          )
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final accountState = _getAccountState();
    return SessionedWidget(
      context: context,
      child: Scaffold(
        backgroundColor: Colors.backgroundTwo,
        appBar: AppBar(
            centerTitle: false,
            titleSpacing: -12,
            iconTheme: IconThemeData(color: Colors.primaryColor),
            title: Text('Account Management',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.textColorBlack,
                    fontFamily: Styles.defaultFont,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                )
            ),
            backgroundColor: Colors.transparent,
            elevation: 0
        ),
        body: FutureBuilder(
            future: init(),
            builder: (_, __) =>_contentView(accountState)
        ),
      ),
    );
  }

}

class _AccountStatusContainer extends StatelessWidget {

  _AccountStatusContainer({
    required this.tiers,
    required this.checkMarkIcon,
    required this.currentTier,
    required this.accountState
  });

  final List<Tier> tiers;
  final ui.Image? checkMarkIcon;
  final Tier? currentTier;
  final AccountState accountState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8, top: 21),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.7, color: Color(0XFF0357EE).withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
                color: Color(0XFF0E4FB1).withOpacity(0.12),
                offset: Offset(0,1),
                blurRadius: 2
            )
          ]
      ),
      child: Column(
          children: [
            _AccountUpgradeProgressView(
              tiers: tiers,
              checkMarkIcon: checkMarkIcon,
            ),
            SizedBox(height: 29),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Divider(height: 1, color: Colors.primaryColor.withOpacity(0.2 ),),
            ),
            _AccountLimitView(
              currentTier: currentTier,
            ),
            Divider(height: 1, color: Colors.primaryColor.withOpacity(0.2 ),),
            _AccountStatusDetails()
          ]
      )
    );
  }

}

///_ProgressiveView
///
///
///
///
class _AccountUpgradeProgressView extends StatelessWidget {

  _AccountUpgradeProgressView({
    required this.tiers,
    required this.checkMarkIcon
  });

  final List<Tier> tiers;
  final ui.Image? checkMarkIcon;

  final ValueNotifier<double> notifier = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);
    final tween = Tween<double>(begin: 0, end: viewModel.getFormWeightedProgress());
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: TweenAnimationBuilder(
            tween: tween,
            curve: Curves.decelerate,
            duration: Duration(seconds: 3),
            child: CustomPaint(
                size: Size(double.infinity, 60),
                painter: ColoredLinearProgressBar(
                    repaint: notifier,
                    progress: 0,
                    tiers: tiers,
                    checkMarkIcon: checkMarkIcon,
                    tierPositionCallback: (tier, width) {
                      final flags = tier.alternateSchemeRequirement?.toAccountUpdateFlag();
                      final sumOfNotRequiredWeight = flags?.fold(0, (int previousValue, element) {
                        if(!element.required && element.flagName != Flags.BVN_VERIFIED) previousValue += element.weight;
                        return previousValue;
                      });
                      final percentageValue = 100 - (sumOfNotRequiredWeight ?? 0);
                      return (percentageValue / 100) * width;
                    }
                )
            ),
            builder: (mContext, double value, child) {
              notifier.value = value;
              return child ?? Container();
            }
        ),
      ),
    );
  }
}


///_AccountLimitView
///
///
///
///
class _AccountLimitView extends StatelessWidget {


  _AccountLimitView({
    required this.currentTier
  });

  final Tier? currentTier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          SizedBox(height: 22),
          Text(
            "Account Limits",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.darkBlue
            ),
          ),
          SizedBox(height: 13,),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Daily Debit Limit",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.darkBlue.withOpacity(0.5)
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "${currentTier?.maximumDailyDebit?.formatCurrency}",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.textColorBlack,
                        fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
              SizedBox(width: 49),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Balance Limit",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.darkBlue.withOpacity(0.5)
                    ),
                  ),
                  SizedBox(height: 2,),
                  Text(
                    "${currentTier?.maximumCumulativeBalance?.formatCurrency}",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.textColorBlack,
                        fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 19),
        ],
      ),
    );
  }

}

///_AccountStatusDetails
///
///
///
///
///
class _AccountStatusDetails extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AccountStatusDetailsState();

}

class _AccountStatusDetailsState extends State<_AccountStatusDetails> {

  int _currentDisplayedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 18, left: 19, right: 19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account Details",
            style: TextStyle(
              color: Colors.darkBlue,
              fontWeight: FontWeight.w500,
              fontSize: 14
            ),
          ),
          SizedBox(height: 12),
          ExpansionPanelList(
            elevation: 0,
            dividerColor: Colors.primaryColor.withOpacity(0.22),
            expansionCallback: (index, bool isOpen) {
              _currentDisplayedIndex = (isOpen) ? index : -1;
              if(_currentDisplayedIndex == -1 && !isOpen) {
                _currentDisplayedIndex = index;
              } else {
                _currentDisplayedIndex = -1;
              }
              setState(() => {});
            },
            children: [
              ExpansionPanel(
                  isExpanded: _currentDisplayedIndex == 0,
                  headerBuilder: (a, isOpen) {
                     return  _PanelHeader(
                       title: "Additional Info",
                       icon: SvgPicture.asset("res/drawables/ic_add.svg"),
                     );
                  },
                  body: Container(height: 10)
              ),
              ExpansionPanel(
                  isExpanded: _currentDisplayedIndex == 1,
                  headerBuilder: (a, isOpen) {
                    return _PanelHeader(
                      title: "Address",
                      icon: SvgPicture.asset("res/drawables/ic_location.svg"),
                    );
                  },
                  body: Container(height: 10)
              ),
              ExpansionPanel(
                  isExpanded: _currentDisplayedIndex == 2,
                  headerBuilder: (a, isOpen) {
                    return _PanelHeader(
                      title: "Identification",
                      icon: SvgPicture.asset("res/drawables/ic_bank_number_input.svg", color: Colors.primaryColor,),
                    );
                  },
                  body: _IdentificationDetailsView()
              ),
              ExpansionPanel(
                  isExpanded: _currentDisplayedIndex == 3,
                  headerBuilder: (a, isOpen) {
                    return _PanelHeader(
                      title: "Next Of Kin",
                      icon: SvgPicture.asset("res/drawables/ic_two_user.svg"),
                    );
                  },
                  body: Container(
                    height: 100,
                  )
              )
            ],
          ),
        ],
      ),
    );
  }

}

///_PanelHeader
///
///
///
class _PanelHeader extends StatelessWidget {

  _PanelHeader({
    required this.title,
    required this.icon
  });

  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          SizedBox(width: 30, child: icon,),
          SizedBox(width: 8,),
          Text(title, style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.textColorDeem
          ))
        ],
      ),
    );
  }
}

///_FormContentBlock
///
///
///
///
class _FormContentBlock extends StatelessWidget {

  _FormContentBlock({
    required this.title,
    required this.value
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: Colors.darkBlue.withOpacity(0.5),
          )
        ),
        SizedBox(height: 4,),
        Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.darkBlue.withOpacity(0.5),
            )
        )
      ],
    );
  }

}

class _IdentificationDetailsView extends StatelessWidget {

  _IdentificationDetailsView();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AccountUpdateViewModel>(context, listen: false);

    return Container(
      child: Column(
        children: [
          StreamBuilder(
              stream: viewModel.identificationForm.idTypeStream,
              builder: (ctx, AsyncSnapshot<IdentificationType?> snapshot) {
                return _FormContentBlock(
                    title: "Identification Type",
                    value: snapshot.data?.idType ?? "Not Yet Supplied"
                );
              }
          ),
          SizedBox(height: 19),
          _FormContentBlock(
              title: "Identification No.",
              value: "3456776654345"
          ),
          SizedBox(height: 19),
          _FormContentBlock(
              title: "Issue Date",
              value: "Issue Date"
          ),
        ],
      ),
    );
  }

}