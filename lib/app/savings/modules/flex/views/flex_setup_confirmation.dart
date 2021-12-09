import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving_config.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/flex_setup_viewmodel.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

import '../../../savings_success_view.dart';

class FlexSetUpConfirmationView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _FlexSetUpConfirmationViewState();

}

class _FlexSetUpConfirmationViewState extends State<FlexSetUpConfirmationView> {

  late final FlexSetupViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<FlexSetupViewModel>(context, listen: false);
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

    return [
      ListTile(
        contentPadding: EdgeInsets.only(left: 22, right: 22, top: 22, bottom: 14),
        title:  Padding(
          padding: EdgeInsets.only(bottom: 3.5),
          child: Text(
            "Monthly Savings Amount",
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
      ListTile(
        contentPadding: EdgeInsets.only(left: 22, right: 22, top: 14, bottom: 14),
        title: Padding(
          padding: EdgeInsets.only(bottom: 3.5),
          child: Text(
            "Interest Rate",
            style: titleStyle,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 3.5),
          child: Text(
            "${_viewModel.flexSaving?.flexSavingInterestProfile?.interestRate}% p.a",
            style: subTitleStyle,
          ).colorText({"p.a" : Tuple(Colors.grey, null)}, underline: false),
        ),
      ),
    ];
  }

  void _subscribeUiToCreateConfig() {
    if(_viewModel.isLoading == true) return;

    setState(() => _viewModel.setIsLoading(true));
    _viewModel.createFlexConfig().listen((event) {
      if(event is Loading) {
        if(!_viewModel.isLoading) {
          setState(() => _viewModel.setIsLoading(true));
        }
      }
      else if(event is Success) {
        setState(() => _viewModel.setIsLoading(false));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => SavingsSuccessView(
              primaryText: "Flex Setup\nSuccessful!",
              secondaryText: "Your Flex account has been successfully setup!",
              primaryButtonText: "Continue",
              primaryButtonAction: () => Navigator.of(context).popUntil(
                  (route) => route.settings.name == Routes.SAVINGS_FLEX_DASHBOARD
                      || route.settings.name == Routes.DASHBOARD
              ),
            ),
          ),
        );
      }
      else if(event is Error<FlexSavingConfig>) {
        setState(() {_viewModel.setIsLoading(false);});
        showError(
            context,
            title: "Failed setting up\nflex savings!",
            message: event.message
        );
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
            title: Text('Setup Confirmation',
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
                  "Setup Confirmation",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 23,),
                Container(
                  height: 220,
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
                    itemBuilder: (ctx, index) => listTiles[index],
                  ),
                ),
                SizedBox(height: 15),
                Expanded(child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Styles.statefulButton2(
                        loadingColor: Colors.savingsPrimary.withOpacity(0.5),
                        buttonStyle: Styles.savingsFlexButtonStyle,
                        isLoading: _viewModel.isLoading,
                        isValid: true,
                        onClick: _subscribeUiToCreateConfig,
                        text: 'Complete Setup'
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