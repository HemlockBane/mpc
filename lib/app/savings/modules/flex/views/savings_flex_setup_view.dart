import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/flex_setup_viewmodel.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/views/pie_progress_bar.dart';
import 'package:provider/provider.dart';

import 'forms/first_flex_setup_form.dart';
import 'forms/second_flex_setup_form.dart';


class SavingsFlexSetupView extends StatefulWidget {
  const SavingsFlexSetupView({Key? key}) : super(key: key);

  @override
  _SavingsFlexSetupViewState createState() => _SavingsFlexSetupViewState();
}

class _SavingsFlexSetupViewState extends State<SavingsFlexSetupView> with CompositeDisposableWidget{

  late FlexSetupViewModel _viewModel;
  late PageView _pageView;

  final _pageController = PageController();
  final pageChangeDuration = const Duration(milliseconds: 250);
  final pageCurve = Curves.linear;

  int _currentPage = 0;
  List<PagedForm> _pages = [];

  void _registerPageChange() {
    _viewModel.pageFormStream.listen((event) {
      // go back to previous page
      if (event.first == -1) _onBackPressed();

      final totalItem = _pages.length;
      if (totalItem > 0 && _currentPage < totalItem - 1) {
        _pageController.animateToPage(_currentPage + 1, duration: pageChangeDuration, curve: pageCurve);
      } else if(_currentPage == totalItem - 1) {
        // submit form

      }
    }).disposedBy(this);
  }

  Widget setupPageView() {
    _pages = [FirstFlexSetupForm(), SecondFlexSetupForm()];
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

  Future<bool> _onBackPressed() async {
    if (_currentPage != 0) {
      await _pageController.animateToPage(
        _currentPage - 1, duration: pageChangeDuration, curve: pageCurve);
      return false;
    }
    return true;
  }

  List<String> getPageTitles() {
    return _pages.map((e) => e.getTitle()).toList();
  }

  @override
  void initState() {
    _viewModel = FlexSetupViewModel();
    _registerPageChange();
    super.initState();
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
              backgroundColor: Color(0xffF8F8F8),
              appBar: AppBar(
                centerTitle: false,
                titleSpacing: 0,
                iconTheme: IconThemeData(color: Colors.solidGreen),
                title: Text('General Savings',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.textColorBlack)),
                backgroundColor: Colors.backgroundWhite,
                elevation: 0
              ),
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    SvgPicture.asset("res/drawables/ic_savings_flex_alt.svg", height: 57, width: 57,),
                    SizedBox(height: 25),
                    Text(
                      "Setup Flex",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 14),
                    Expanded(child: setupPageView(),)
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20, right: 18,
              child: FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 60), () => "done"),
                builder: (context, snapshot) {
                  if(snapshot.connectionState != ConnectionState.done) return SizedBox();
                  // Material helps take away the yellow lines under the text
                  return Material(
                    child: PieProgressBar(
                      viewPager: _pageController,
                      totalItemCount: _pages.length,
                      pageTitles: getPageTitles(),
                      displayTitle: false,
                      progressColor: Colors.solidGreen,
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    disposeAll();
    _viewModel.dispose();
    super.dispose();
  }
}





