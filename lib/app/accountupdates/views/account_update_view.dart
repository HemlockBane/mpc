import 'dart:async';

import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/additional_info_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/customer_address_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/next_of_kin_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/proof_of_address_view.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/views/pie_progress_bar.dart';
import 'package:provider/provider.dart';

import 'customer_identification_view.dart';

class AccountUpdateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountUpdateScreen();
  }
}

class _AccountUpdateScreen extends State<AccountUpdateScreen> {

  late AccountUpdateViewModel _viewModel;

  late PageView _pageView;
  final _pageController = PageController();
  final pageChangeDuration = const Duration(milliseconds: 250);
  final pageCurve = Curves.linear;

  int _currentPage = 0;
  List<PagedForm> _pages = [];

  Widget setupPageView() {
    _pages = <PagedForm>[
      AdditionalInfoScreen(),
      CustomerIdentificationScreen(),
      CustomerAddressScreen(),
      ProofOfAddressScreen(),
      NextOfKinScreen()
    ];
    this._pageView = PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _pages.length,
        controller: _pageController,
        onPageChanged: (page) {
          _currentPage = page;
        },
        itemBuilder: (BuildContext context, int index){
          return _pages[index % _pages.length]..bind(_pages.length, index);
        });
    return _pageView;
  }

  void _registerPageChange() {
    _viewModel.pageFormStream.listen((event) {
      final totalItem = _pages.length;

      if (totalItem > 0 && _currentPage < totalItem - 1) {
        _pageController.animateToPage(_currentPage + 1, duration: pageChangeDuration, curve: pageCurve);
      } else if(_currentPage == totalItem - 1) {
        //submit form
        _subscribeUiToAccountEligibility();
      }
    });
  }

  void _subscribeUiToAccountEligibility() {
    _viewModel.checkCustomerEligibility().listen((event) {
      if(event is Loading) {}
      else if(event is Success) _subscribeUiToAccountUpgrade();
      else if(event is Error<Tier>) {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return BottomSheets.displayErrorModal(context, message: event.message);
            });
      }
    });
  }

  void _subscribeUiToAccountUpgrade() {
    _viewModel.updateAccount().listen((event) {
    });
  }

  @override
  void initState() {
    _viewModel = AccountUpdateViewModel();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _viewModel.fetchCountries().listen((event) {});
    });
    _registerPageChange();
    super.initState();
  }

  Future<bool> _onBackPressed() async {
    if(_currentPage != 0) {
      await _pageController.animateToPage(_currentPage - 1, duration: pageChangeDuration, curve: pageCurve);
      return false;
    }
    return true;
  }

  List<String> getPageTitles() {
    return List.unmodifiable([
      "Additional Info",
      "Customer ID",
      "Customer Address",
      "Proof of Address",
      "Next of Kin",
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _viewModel),
          ],
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                centerTitle: false,
                titleSpacing: -12,
                title: Text('Account Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.darkBlue)),
                elevation: 0,
                backgroundColor: Colors.backgroundWhite,
                iconTheme: IconThemeData(color: Colors.primaryColor)
            ),
            body: Container(
              color: Colors.backgroundWhite,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.,
                children: [
                  FutureBuilder(
                    future: Future.value(true),
                    builder: (BuildContext mContext, AsyncSnapshot<void> snap) {
                      return (snap.hasData) ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: PieProgressBar(
                            viewPager: _pageController,
                            totalItemCount: _pages.length,
                            pageTitles: getPageTitles(),
                        ),
                      ) : SizedBox();
                    },
                  ),
                  SizedBox(height: 32,),
                  Expanded(child: setupPageView())
                ],
              ),
            ),
          ),
    ));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}