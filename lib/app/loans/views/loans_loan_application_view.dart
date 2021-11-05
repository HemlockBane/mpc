import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/rendering.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/loans/viewmodels/loan_request_viewmodel.dart';
import 'package:moniepoint_flutter/app/loans/views/loan_offers_form.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_apply_for_loan_form.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/views/pie_progress_bar.dart';
import 'package:provider/provider.dart';

class LoanApplicationView extends StatefulWidget {
  const LoanApplicationView({Key? key}) : super(key: key);

  @override
  _LoanApplicationViewState createState() => _LoanApplicationViewState();
}

class _LoanApplicationViewState extends State<LoanApplicationView> with CompositeDisposableWidget {
  late LoanRequestViewModel _viewModel;
  late PageView _pageView;

  final _pageController = PageController();
  final pageChangeDuration = const Duration(milliseconds: 250);
  final pageCurve = Curves.linear;

  int _currentPage = 0;
  List<PagedForm> _pages = [];

  Widget setupPageView() {
    _pages = [LoanOffersView(), ApplyForLoanView()];
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
        print("loan application: selected loan ${event.loanOffer.toJson()}");
        _viewModel.setSelectedLoanOffer(event.loanOffer);
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
      // This hack fixes the page refresh issue for page 2
      // TODO: Find a proper solution to the issue
      FocusManager.instance.primaryFocus?.unfocus();
      return false;
    }
    return true;
  }

  List<String> getPageTitles() {
    return _pages.map((e) => e.getTitle()).toList();
  }

  @override
  void initState() {
    _viewModel = Provider.of<LoanRequestViewModel>(context, listen: false);
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
                    SizedBox(height: 25),
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
              top: 25,
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