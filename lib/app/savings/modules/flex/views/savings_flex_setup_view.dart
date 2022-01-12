import 'dart:async';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving_config.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/flex_setup_viewmodel.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/views/pie_progress_bar.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

import 'forms/first_flex_setup_form.dart';
import 'forms/second_flex_setup_form.dart';

///
///SavingsFlexSetupView
///@author Paul Okeke
///
class SavingsFlexSetupView extends StatefulWidget {
  const SavingsFlexSetupView({
    Key? key,
    required this.flexSaving
  }) : super(key: key);

  final FlexSaving flexSaving;

  @override
  _SavingsFlexSetupViewState createState() => _SavingsFlexSetupViewState();

}

///_SavingsFlexSetupViewState
///
///
class _SavingsFlexSetupViewState extends State<SavingsFlexSetupView> with CompositeDisposableWidget{

  late FlexSetupViewModel _viewModel;
  late PageView _pageView;

  final _pageController = PageController();
  final pageChangeDuration = const Duration(milliseconds: 250);
  final pageCurve = Curves.linear;

  late Stream<Resource<FlexSavingConfig>> _flexConfigStream;
  final Completer _progressBarCompleter = Completer();

  List<PagedForm> _pages = [];

  void _registerPageChange() {
    _viewModel.pageFormStream.listen((event) {
      // go back to previous page
      if (event.first == -1) _onBackPressed();

      final totalItem = _pages.length;
      final _currentPage = _viewModel.currentPage;
      if (totalItem > 0 && _currentPage < totalItem - 1) {
        _pageController.animateToPage(_currentPage + 1, duration: pageChangeDuration, curve: pageCurve);
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
        _viewModel.setCurrentPage(page);
        _viewModel.checkValidity();
      },
      itemBuilder: (BuildContext context, int index) {
        return _pages[index % _pages.length]..bind(_pages.length, index);
      });
    return _pageView;
  }

  Future<bool> _onBackPressed() async {
    final _currentPage = _viewModel.currentPage;
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
    _viewModel = Provider.of<FlexSetupViewModel>(context, listen: false);
    _viewModel.setFlexSaving(widget.flexSaving);
    _flexConfigStream = _viewModel.getFlexSavingConfig();
    _registerPageChange();
    super.initState();
  }

  Widget _progressBar() {
    return FutureBuilder(
        future: _progressBarCompleter.future,
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.done) return SizedBox();
          return Padding(
            padding: EdgeInsets.only(right: 16),
            child: PieProgressBar(
              viewPager: _pageController,
              totalItemCount: _pages.length,
              pageTitles: getPageTitles(),
              displayTitle: false,
              progressColor: Colors.solidGreen,
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MultiProvider(
        providers: [ChangeNotifierProvider.value(value: _viewModel)],
        child: SessionedWidget(
          context: context,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: false,
              titleSpacing: 0,
              iconTheme: IconThemeData(color: Colors.solidGreen),
              title: Text(
                  'General Savings',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.textColorBlack
                  )
              ),
              backgroundColor: Color(0XFFF5F5F5).withOpacity(0.7),
              elevation: 0,
              toolbarHeight: 70,
              actions: [_progressBar()],
            ),
            body: StreamBuilder(
              stream: _flexConfigStream,
              builder: (ctx, AsyncSnapshot<Resource<FlexSavingConfig>> snap) {
                if(snap.data is Loading) return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.darkBlue),
                        ),
                      )
                    ],
                  ),
                );

                final duration = (_viewModel.flexSaving?.configCreated == true)
                    ? Duration(seconds: 1)
                    : Duration(milliseconds: 100);

                Future.delayed(duration, () {
                  if(!_progressBarCompleter.isCompleted) {
                    _progressBarCompleter.complete(null);
                  }
                });
                return Container(
                  color: Color(0XFFF5F5F5).withOpacity(0.7),
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
                      Expanded(child: setupPageView())
                    ],
                  ),
                );
              },
            ),
          ),
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





