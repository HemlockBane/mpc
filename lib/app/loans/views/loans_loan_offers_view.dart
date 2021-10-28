import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/loans/viewmodels/loan_request_viewmodel.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_apply_confirmation_view.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_product_details_view.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/info_banner_content.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/views/pie_progress_bar.dart';
import 'package:moniepoint_flutter/core/views/transaction_account_source.dart';
import 'package:provider/provider.dart';

class LoanOffersView extends StatefulWidget {
  const LoanOffersView({Key? key}) : super(key: key);

  @override
  _LoanOffersViewState createState() => _LoanOffersViewState();
}

class _LoanOffersViewState extends State<LoanOffersView>
    with CompositeDisposableWidget {
  late LoanRequestViewModel _viewModel;
  late PageView _pageView;

  final _pageController = PageController();
  final pageChangeDuration = const Duration(milliseconds: 250);
  final pageCurve = Curves.linear;

  int _currentPage = 0;
  List<PagedForm> _pages = [];

  Widget setupPageView() {
    _pages = [AvailableOffersView(), ApplyForLoanView()];
    this._pageView = PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _pages.length,
        controller: _pageController,
        onPageChanged: (page) {
          _currentPage = page;
        },
        itemBuilder: (BuildContext context, int index) {
          return _pages[index % _pages.length]..bind(_pages.length, index);
        });
    return _pageView;
  }

  void _registerPageChange() {
    _viewModel.pageFormStream.listen((event) {
      final totalItem = _pages.length;
      if (totalItem > 0 && _currentPage < totalItem - 1) {
        _pageController.animateToPage(_currentPage + 1,
            duration: pageChangeDuration, curve: pageCurve);
      } else if (_currentPage == totalItem - 1) {
        // submit form

      }
    }).disposedBy(this);
  }

  Future<bool> _onBackPressed() async {
    if (_currentPage != 0) {
      await _pageController.animateToPage(_currentPage - 1,
          duration: pageChangeDuration, curve: pageCurve);
      return false;
    }
    return true;
  }

  List<String> getPageTitles() {
    return _pages.map((e) => e.getTitle()).toList();
  }

  @override
  void initState() {
    _viewModel = LoanRequestViewModel();
    _registerPageChange();
    super.initState();
  }

  @override
  void dispose() {
    disposeAll();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: _viewModel),
        ],
        child: Stack(
          children: [
            Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(90),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    AppBar(
                      centerTitle: false,
                      titleSpacing: 0,
                      iconTheme: IconThemeData(color: Colors.solidOrange),
                      title: Text(
                        'Loans',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.textColorBlack,
                        ),
                      ),
                      backgroundColor: Colors.backgroundWhite,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18),
                  Expanded(
                    child: setupPageView(),
                  )
                ],
              ),
            ),
            Positioned(
              top: 50,
              right: 18,
              child: FutureBuilder(
                  future:
                      Future.delayed(Duration(milliseconds: 60), () => "done"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done)
                      return SizedBox();

                    // Material helps take away the yellow lines under the text
                    return Material(
                      child: PieProgressBar(
                        viewPager: _pageController,
                        totalItemCount: _pages.length,
                        pageTitles: getPageTitles(),
                        displayTitle: false,
                        progressColor: Colors.solidOrange,
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class AvailableOffersView extends PagedForm {
  @override
  _AvailableOffersViewState createState() => _AvailableOffersViewState();

  @override
  String getTitle() => "AvailableOffersView";
}

class _AvailableOffersViewState extends State<AvailableOffersView> {
  late final LoanRequestViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<LoanRequestViewModel>(context, listen: false);
    super.initState();
  }

  TextStyle getBoldStyle({
    double fontSize = 24.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  TextStyle getNormalStyle({
    double fontSize = 11.5,
    Color color = const Color(0xffA9A5AF),
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  Widget _getDivider({double? topMargin, double? bottomMargin}) => Padding(
      padding: EdgeInsets.only(top: topMargin ?? 3, bottom: bottomMargin ?? 11),
      child: Divider(
        thickness: 1,
        color: Color(0xffF2EDE6),
      ),
  );

  Container _buildCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 13, 16, 15),
      margin: EdgeInsets.symmetric(horizontal: 18),
      child: child,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
              width: 0.7, color: Colors.loanCardShadowColor.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 1,
                color: Colors.loanCardShadowColor.withOpacity(0.1))
          ]),
    );
  }

  Widget _textButton({required String text, required VoidCallback onClick}) {
    return TextButton(
      child:
          Text(text, style: getBoldStyle(color: Colors.white, fontSize: 12.5)),
      style: TextButton.styleFrom(
          backgroundColor: Colors.solidOrange,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
      onPressed: () {
        onClick();
      },
    );
  }

  Widget _buildBottomView({String? text, VoidCallback? onClick}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Interest", style: getNormalStyle(fontSize: 12.5)),
                  SizedBox(height: 5),
                  Text("7.51%", style: getBoldStyle(fontSize: 13.5))
                ],
              ),
              SizedBox(width: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tenor", style: getNormalStyle(fontSize: 12.5)),
                  SizedBox(height: 5),
                  Text("14 days", style: getBoldStyle(fontSize: 13.5))
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 31),
        if (text != null && onClick != null)
          _textButton(
              text: text,
              onClick: () {
                onClick();
              })
      ],
    );
  }

  Widget starterLoanCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("res/drawables/ic_border_line.svg"),
              SizedBox(width: 14),
              Text(
                "Starter Loan",
                style: getBoldStyle(fontSize: 14.5),
              )
            ],
          ),
          _getDivider(),
          Text("Max Amount Eligible", style: getNormalStyle(fontSize: 12.5)),
          SizedBox(height: 4),
          Text("N 50,000.00", style: getBoldStyle(fontSize: 17)),
          SizedBox(height: 17),
          _buildBottomView(
            text: "Apply for offer",
            onClick: () {
              _viewModel.moveToNext(widget.position);
            },
          )
        ],
      ),
    );
  }

  Widget bossLoanCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                "res/drawables/ic_border_line.svg",
                color: Color(0xff656CCF2),
              ),
              SizedBox(width: 14),
              Text(
                "Boss Loan",
                style: getBoldStyle(fontSize: 14.5),
              )
            ],
          ),
          _getDivider(),
          Text("Max Amount Eligible", style: getNormalStyle(fontSize: 12.5)),
          SizedBox(height: 4),
          Text("N 50,000.00", style: getBoldStyle(fontSize: 17)),
          SizedBox(height: 17),
          _buildBottomView(),
          SizedBox(height: 17),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 17),
            child: InfoBannerContent(
                title: "Eligibility",
                subtitle:
                    "Take more than two starter loans to be eligible for this loan",
                svgPath: "res/drawables/ic_savings_warning.svg"),
            decoration: BoxDecoration(
                color: Color(0xff244528).withOpacity(0.05),
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Loan Offers",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 33),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Available Offers for you",
              style: getBoldStyle(fontSize: 15.5),
            ),
          ),
          SizedBox(height: 14),
          starterLoanCard(),
          SizedBox(height: 9),
          starterLoanCard(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: _getDivider(topMargin: 31, bottomMargin: 25),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Future offers",
              style: getBoldStyle(fontSize: 15.5),
            ),
          ),
          SizedBox(height: 13),
          bossLoanCard(),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}

class ApplyForLoanView extends PagedForm {
  @override
  _ApplyForLoanViewState createState() => _ApplyForLoanViewState();

  @override
  String getTitle() => "ApplyForLoanView";
}

class _ApplyForLoanViewState extends State<ApplyForLoanView>
    with AutomaticKeepAliveClientMixin {
  late final LoanRequestViewModel _viewModel;
  bool _isSelected = true;
  double _amount = 0.00;

  TextStyle getBoldStyle({
    double fontSize = 24.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  TextStyle getNormalStyle({
    double fontSize = 11.5,
    Color color = const Color(0xffA9A5AF),
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  Widget _getDivider({double? topMargin, double? bottomMargin}) => Padding(
      padding: EdgeInsets.only(top: topMargin ?? 6, bottom: bottomMargin ?? 11),
      child: Divider(
        thickness: 0.7,
        color: Color(0xff966C2E).withOpacity(0.12),
      ));

  @override
  void initState() {
    _viewModel = Provider.of<LoanRequestViewModel>(context, listen: false);
    refreshAccounts();
    super.initState();
  }

  void refreshAccounts() {
    if (_viewModel.userAccounts.length > 1)
      _viewModel.getUserAccountsBalance().listen((event) {});
    else
      _viewModel.getCustomerAccountBalance().listen((event) {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Apply for Starter Loan",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 33),
            Text(
              "How much would you like to borrow?",
              style: getNormalStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w500,
                color: Colors.textColorMainBlack,
              ),
            ),
            SizedBox(height: 13),
            Container(
              padding:
                  EdgeInsets.only(left: 14, right: 14, top: 26, bottom: 12),
              decoration: BoxDecoration(
                  color: Color(0xffE9ECF0),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                children: [
                  PaymentAmountView(
                    (_amount * 100).toInt(),
                    (value) {},
                    currencyColor: Color(0xffC1C2C5).withOpacity(0.5),
                    textColor: Colors.textColorBlack,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Max Amount",
                        style: getNormalStyle(
                            color: Color(0xffA9A5AF), fontSize: 12),
                      ),
                      SizedBox(width: 10),
                      Text("N 150,000.00",
                          style: getNormalStyle(
                              color: Color(0xffA9A5AF), fontSize: 12))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.fromLTRB(15, 15, 30, 17.25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Rate", style: getNormalStyle(fontSize: 12.5)),
                      SizedBox(height: 5),
                      Text("7.51%", style: getBoldStyle(fontSize: 13.5))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tenor", style: getNormalStyle(fontSize: 12.5)),
                      SizedBox(height: 5),
                      Text("14 days", style: getBoldStyle(fontSize: 13.5))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Interest", style: getNormalStyle(fontSize: 12.5)),
                      SizedBox(height: 5),
                      Text("N 150,000.00", style: getBoldStyle(fontSize: 13.5))
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  width: 0.7,
                  color: Colors.loanCardShadowColor.withOpacity(0.15),
                ),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 1,
                      color: Colors.loanCardShadowColor.withOpacity(0.1)),
                ],
              ),
            ),
            SizedBox(height: 32),
            Text(
              "Select payout Account",
              style: getNormalStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w500,
                color: Colors.textColorMainBlack,
              ),
            ),
            SizedBox(height: 12),
            TransactionAccountSource(
              _viewModel,
              primaryColor: Colors.solidOrange,
              titleStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.textColorBlack,
                  fontWeight: FontWeight.bold),
              checkBoxSize: Size(40, 40),
              listStyle: ListStyle.alternate,
              checkBoxPadding: EdgeInsets.all(6.0),
              checkBoxBorderColor: Color(0xffA6B6CE).withOpacity(0.95),
              isShowTrailingWhenExpanded: false,
            ),
            SizedBox(height: 16.4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Use same account for repayment",
                style: getNormalStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.textColorMainBlack,
                ),
              ),
              value: _isSelected,
              onChanged: (value) {
                if (!_isSelected) refreshAccounts();
                setState(() {
                  _isSelected = value;
                });
              },
              activeColor: Colors.solidOrange,
              activeTrackColor: Color(0xffD1CFD3),
              inactiveTrackColor: Color(0xffD1CFD3),
              inactiveThumbColor: Colors.white,
            ),
            if (!_isSelected)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: _getDivider(topMargin: 10, bottomMargin: 28),
              ),
            if (!_isSelected)
              Text(
                "Select repayment Account",
                style: getNormalStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.textColorMainBlack,
                ),
              ),
            if (!_isSelected) SizedBox(height: 12),
            if (!_isSelected)
              TransactionAccountSource(
                _viewModel,
                primaryColor: Colors.solidOrange,
                titleStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.textColorBlack,
                    fontWeight: FontWeight.bold),
                checkBoxSize: Size(40, 40),
                listStyle: ListStyle.alternate,
                checkBoxPadding: EdgeInsets.all(6.0),
                checkBoxBorderColor: Color(0xffA6B6CE).withOpacity(0.95),
                isShowTrailingWhenExpanded: false,
              ),
            SizedBox(height: !_isSelected ? 25 : 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 17),
              child: InfoBannerContent(
                  rightSpace: 100,
                  subtitleWidget: RichText(
                      text: TextSpan(style: TextStyle(height: 1.4), children: [
                    TextSpan(
                        text: "By tapping ",
                        style: getNormalStyle(
                            fontSize: 12.5, color: Colors.textColorBlack)),
                    TextSpan(
                        text: "Next",
                        style: getBoldStyle(
                            fontSize: 12.5, color: Colors.textColorBlack)),
                    TextSpan(
                        text: ", you agree to the",
                        style: getNormalStyle(
                            fontSize: 12.5, color: Colors.textColorBlack)),
                    TextSpan(
                        text: " Terms and Conditions",
                        style: getBoldStyle(
                            fontSize: 12.5, color: Colors.textColorBlack))
                  ])),
                  svgPath: "res/drawables/ic_savings_warning.svg"),
              decoration: BoxDecoration(
                  color: Color(0xff244528).withOpacity(0.05),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
            SizedBox(height: 50),
            Styles.statefulButton(
                buttonStyle: Styles.primaryButtonStyle.copyWith(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.solidOrange),
                    textStyle: MaterialStateProperty.all(getBoldStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white))),
                stream: Stream.value(true),
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) =>
                        LoansApplicationConfirmationView()),
                  );
                },
                text: 'Next'),
            SizedBox(height: 38 + 31.5),
          ],
        ),
      ),
    );
  }
}
