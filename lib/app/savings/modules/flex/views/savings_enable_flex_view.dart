import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/savings/model/data/savings_product.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/savings_flex_enable_viewmodel.dart';
import 'package:moniepoint_flutter/app/savings/savings_success_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:provider/provider.dart';

const lightGreen = Color(0xffD1E7D3);
const double toolBarMarginTop = 37;
const double maxDraggableTop = toolBarMarginTop * 5 + 26;
const String loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"
    " sed do eiusmod tempor incididunt ut labore et dolore magna aliqua";

class SavingsEnableFlexView extends StatefulWidget {

  const SavingsEnableFlexView({
    Key? key,
    required this.product
  }) : super(key: key);

  final SavingsProduct product;

  @override
  State<StatefulWidget> createState() => SavingsEnableFlexState();

}

class SavingsEnableFlexState extends State<SavingsEnableFlexView> {

  late final SavingsFlexEnableViewModel viewModel;

  TextStyle getBoldStyle(
      {double fontSize = 32.5,
        Color color = Colors.textColorBlack,
        FontWeight fontWeight = FontWeight.w700}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  TextStyle getNormalStyle(
      {double fontSize = 32.5,
        Color color = Colors.white,
        FontWeight fontWeight = FontWeight.w400}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);


  @override
  initState() {
    viewModel = Provider.of<SavingsFlexEnableViewModel>(context, listen: false);
    super.initState();
  }

  void _navigateToSuccessPage(String accountNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => SavingsSuccessView(
          primaryText: "Flex\nSavings Enabled",
          secondaryText: widget.product.longDescription ?? "",
          content: FlexEnabledSuccessContent(accountNumber: accountNumber),
          primaryButtonText: "Setup Flex Savings",
          primaryButtonAction: () {
            Navigator.pushNamed(context, Routes.SAVINGS_FLEX_SETUP);
          },
          secondaryButtonText: "Dismiss",
          secondaryButtonAction: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _subscribeUiToEnableFlex() {
    setState(() => viewModel.setIsEnablingFlex(true));
    viewModel.enableFlexSavings().listen((event) {
      if(event is Loading) {
        if(!viewModel.isEnablingFlex) {
          setState(() => viewModel.setIsEnablingFlex(true));
        }
      }
      else if(event is Success) {
        setState(() => viewModel.setIsEnablingFlex(false));
        _navigateToSuccessPage(event.data?.cbaAccountNuban ?? "");
      }
      else if(event is Error<FlexSaving>) {
        setState(() {viewModel.setIsEnablingFlex(false);});
        showError(
            context,
            title: "Failed enabling flex savings!",
            message: event.message
        );
      }
    });
  }

  Widget _content(context) {
    final screenSize = MediaQuery.of(context).size;
    final maxExtent = 0.81;
    final containerHeight = 1;
    final minExtent = 0.63;
    // TODO: Ask @Paul to explain this minExtent to me
    // final minExtent = 1 - (containerHeight / (screenSize.height - maxDraggableTop));
    return DraggableScrollableSheet(
        maxChildSize: maxExtent,
        minChildSize: minExtent,
        initialChildSize: minExtent,
        builder: (ctx, ScrollController draggableScrollController) {
          return Container(
            padding: EdgeInsets.only(top: 21, left: 23, right: 23),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              border: Border.all(
                width: 1.0,
                color: Color(0xff063A4F0D).withOpacity(0.05),
              ),
            ),
            child: ListView(
              controller: draggableScrollController,
              children: [
                Text(
                  "Flex Savings",
                  style: getBoldStyle(),
                ),
                SizedBox(height: 16),
                Text(widget.product.longDescription ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.5,
                        height: 1.5,
                        color: Colors.textColorBlack
                    )
                ),
                SizedBox(height: 24),
                _SavingsInterestView(product: widget.product),
                SizedBox(height: 24),
                _SavingsRulesInfoWindow(product: widget.product),
                SizedBox(height: 27),
                Styles.statefulButton2(
                    buttonStyle: Styles.savingsFlexButtonStyle,
                    isValid: true,
                    isLoading: viewModel.isEnablingFlex,
                    onClick: _subscribeUiToEnableFlex,
                    text: 'Enable Flex Savings',
                    loadingColor: Colors.savingsPrimary.withOpacity(0.5)
                ),
                SizedBox(height: 31.5),
                GestureDetector(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Learn More about Flex Savings",
                          style: getBoldStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.chevron_right,
                            color: Colors.textColorBlack,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20)
              ],
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      body: Stack(
        children: [
          Positioned(
            top: toolBarMarginTop,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Styles.imageButton(
                    padding: EdgeInsets.all(9),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    onClick: () => Navigator.of(context).pop(),
                    image: SvgPicture.asset(
                      'res/drawables/ic_back_arrow.svg',
                      fit: BoxFit.contain,
                      width: 19.5,
                      height: 19.02,
                      color: Colors.textColorBlack,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Savings",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.textColorBlack),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 33,
            right: 0,
            child: Image.asset('res/drawables/savings_flex_bg.png'),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: _content(context),
          )
        ],
      ),
    );
  }

}

///_SavingsInterestView
///
///
class _SavingsInterestView extends StatelessWidget {

  _SavingsInterestView({required this.product});

  final SavingsProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          color: lightGreen,
          borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      child: Column(
        children: [
          Text(
            "Interest Rate",
            style: TextStyle(
                fontSize: 16.8,
                fontWeight: FontWeight.w500,
                color: Colors.textColorBlack
            ),
          ),
          SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${product.flexSavingScheme?.interestRate ?? "--"}",
                  style: TextStyle(
                      fontSize: 37.55,
                      fontWeight: FontWeight.w700,
                      color: Colors.textColorBlack
                  ),
              ),
              SizedBox(width: 2),
              Text("%",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.textColorBlack.withOpacity(0.5)
                  ),
              ),
            ],
          ),
          SizedBox(height: 3),
          Text(
            "PER ANNUM",
            style: TextStyle(
                color: Colors.textColorBlack,
                fontWeight: FontWeight.normal,
                fontSize: 10,
                letterSpacing: 2
            ),
          ),
        ],
      ),
    );
  }
}

///_SavingsRulesInfoWindow
///
///
///
class _SavingsRulesInfoWindow extends StatelessWidget {

  _SavingsRulesInfoWindow({required this.product});

  final SavingsProduct product;

  Row _infoBannerContent({
    required String svgPath,
    required String title,
    required String subtitle,
    String? additionalInfo
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(svgPath),
        SizedBox(width: 16.6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13, color: Colors.textColorBlack,
              )),
              SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                    fontSize: 12.9,
                    height: 1.48,
                    fontWeight: FontWeight.normal,
                    color: Colors.textColorBlack),
              ),
              SizedBox(height: 5),
              if (additionalInfo != null)
                Text(
                  additionalInfo,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13, color: Colors.textColorBlack,
                      letterSpacing: -0.3
                  )
                )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 17),
      child: Column(
        children: [
          _infoBannerContent(
              title: "Terms of Withdrawal",
              subtitle: "You're eligible to withdraw without\n penalties on these dates:",
              svgPath: "res/drawables/ic_savings_lock.svg",
              additionalInfo: "25th - 30th of every month"
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Divider(
              color: Color(0xff29522D).withOpacity(0.29),
              thickness: 0.5,
            ),
          ),
          _infoBannerContent(
              title: "Penalty",
              subtitle: "${product.penalties}% penalty on the interest for\n premature/unplanned withdrawals",
              svgPath: "res/drawables/ic_savings_warning.svg"
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Color(0xff244528).withOpacity(0.05),
          borderRadius: BorderRadius.all(Radius.circular(16))
      ),
    );
  }
  
}

class FlexEnabledSuccessContent extends StatelessWidget {

  FlexEnabledSuccessContent({required this.accountNumber});

  final String accountNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 19, bottom: 22, left: 21, right: 21),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.19),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Your Flex Savings Acc. No.",
            style: TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                accountNumber,
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
              TextButton.icon(
                  onPressed: () => Clipboard.setData(ClipboardData(text: accountNumber)),
                  icon: SvgPicture.asset(
                    'res/drawables/ic_copy_full.svg',
                    color: Colors.white,
                  ),
                  label: Text(
                    'Copy',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ))
            ],
          )
        ],
      ),
    );
  }
}

