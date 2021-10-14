import 'dart:async';

import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/accounts/model/data/account_update_flag.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/additional_info_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/customer_address_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/customer_identification_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/dialogs/account_update_dialog.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/next_of_kin_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/proof_of_address_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/lazy.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/error_layout_view.dart';
import 'package:moniepoint_flutter/core/views/pie_progress_bar.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

import 'document_verification_view.dart';

class AccountUpdateScreen extends StatefulWidget {

  final Map<String, Lazy<PagedForm>> _formsMap =  Map.unmodifiable({
    Flags.ADDITIONAL_INFO: lazy(() => AdditionalInfoScreen()),
    Flags.IDENTIFICATION_INFO : lazy(() => CustomerIdentificationScreen()),
    Flags.ADDRESS_INFO : lazy(() => CustomerAddressScreen()),
    Flags.ADDRESS_PROOF : lazy(() => ProofOfAddressScreen()),
    Flags.NEXT_OF_KIN_INFO : lazy(() => NextOfKinScreen()),
  });

  @override
  State<StatefulWidget> createState() =>_AccountUpdateScreen();

}

///_AccountUpdateScreen
///
///
///
///
///
class _AccountUpdateScreen extends State<AccountUpdateScreen> with CompositeDisposableWidget {

  late AccountUpdateViewModel _viewModel;
  late PageView _pageView;

  final _pageController = PageController();
  final pageChangeDuration = const Duration(milliseconds: 250);
  final pageCurve = Curves.linear;

  Stream<Resource<bool>> _loadPageDependencies = Stream.empty();

  int _currentPage = 0;
  List<PagedForm> _pages = [];

  bool _displayPageProgress = true;

  Widget setupPageView() {
    _pages = _getDisplayableForms();
    if(_pages.isEmpty) return Container(color: Colors.white);
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

  List<PagedForm> _getPagedForms(List<AccountUpdateFlag?> flags, {bool enforceRequired = false}) {
    final _formsMap = widget._formsMap;
    final forms = <PagedForm>[];

    AccountUpdateFlag? idVerificationFlag;
    AccountUpdateFlag? addressVerification;

    flags.where((element) => element != null).forEach((flag) {
      final isRequired = (enforceRequired) ? flag!.required : true;
      //if the flag status is false and it's required then we need to add it up
      if((!flag!.status && isRequired) && _formsMap.containsKey(flag.flagName)) {
        final pageForm = _formsMap[flag.flagName];
        if(pageForm != null) forms.add(pageForm.value);
      }

      else if(flag.flagName == Flags.IDENTIFICATION_VERIFIED) idVerificationFlag = flag;
      else if(flag.flagName == Flags.ADDRESS_VERIFIED) addressVerification = flag;
    });

    if(forms.isEmpty && _isAwaitingVerification(idVerificationFlag, addressVerification)) {
      _displayPageProgress = false;
      forms.add(
          DocumentVerificationScreen(idVerificationFlag, addressVerification)
      );
    }
    return forms;
  }

  List<PagedForm> _getDisplayableFormsForAccountUpdate() {
    final mCustomer = _viewModel.customer;
    final mAccountStatus = UserInstance().accountStatus;
    final flags = mAccountStatus?.listFlags() ?? mCustomer?.listFlags();

    if(flags == null) return [];

    return _getPagedForms(flags);
  }

  List<PagedForm> _getDisplayableForms() {
    //let's check if the account status is available
    //if the account status is available we need to confirm if we are on PND or not
    final mAccountStatus = UserInstance().accountStatus;
    if(mAccountStatus == null) return _getDisplayableFormsForAccountUpdate();

    //If the account is not on pnd we can ascertain that this is an account update mode
    //however, we might need the updatedFlags from the account status rather than
    //depend on the customerObject which isn't updated until re-login
    if(mAccountStatus.postNoDebit == false) return _getDisplayableFormsForAccountUpdate();

    //now if the status value is available and we are on pnd we need to get the scheme that will lift the pnd
    Tier? pndLiftScheme = mAccountStatus.pndLiftScheme;

    List<AccountUpdateFlag>? updateFlagsForScheme = pndLiftScheme?.alternateSchemeRequirement?.toAccountUpdateFlag();

    return _getPagedForms(updateFlagsForScheme ?? [], enforceRequired: true);
  }

  bool _isAwaitingVerification(AccountUpdateFlag? idVerification, AccountUpdateFlag? addressVerification) {
    final isAwaitingDocumentIDVerification = idVerification?.status == false;
    final isAwaitingAddressVerification = addressVerification?.status == false;
    return isAwaitingDocumentIDVerification || isAwaitingAddressVerification;
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
    }).disposedBy(this);
  }

  void _subscribeUiToAccountEligibility() {
    _viewModel.checkCustomerEligibility().listen((event) {
      if(event is Loading) {
        _viewModel.setIsLoading(true);
      }
      else if(event is Success) {
        _viewModel.setIsLoading(false);
        _subscribeUiToAccountUpgrade(event);
      }
      else if(event is Error<Tier>) {
        _viewModel.setIsLoading(false);
        showError(context, title: "Failed verifying customer eligibility", message: event.message);
      }
    }).disposedBy(this);
  }

  void _subscribeUiToAccountUpgrade(Resource<Tier> event) async {
    dynamic value = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ChangeNotifierProvider.value(
          value: _viewModel,
          child: AccountUpdateDialog(event.data!),
        ));

    if(value != null && value is Tier) {
      await showSuccess(
          context,
          title: "Update Successful",
          message: "Customer Details updated successfully",
          onPrimaryClick: () => Navigator.of(context).pop(context)
      );
      Navigator.of(context).pop(context);
    }
    if(value != null && value is Error<Tier>) {
      showError(context, title: "Account Upgrade Failed", message: value.message);
    }
  }

  @override
  void initState() {
    _viewModel = AccountUpdateViewModel();
    _registerPageChange();
    _loadPageDependencies = _viewModel.loadPageDependencies();
    super.initState();
  }

  Future<bool> _onBackPressed() async {
    print(_currentPage);
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
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _viewModel),
          ],
          child: StreamBuilder(
              stream: _loadPageDependencies,
              builder: (context, AsyncSnapshot<Resource<bool>> snapshot) {
                if(!snapshot.hasData || snapshot.data is Loading) {
                  return Center(
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final data = snapshot.data;
                if(data is Error<bool>) {
                  return Center(
                    child: ErrorLayoutView(
                        "Error Setting up account update",
                        data.message ?? "",
                        () {
                          setState(() {
                            _loadPageDependencies = _viewModel.loadPageDependencies();
                          });
                        }
                    ),
                  );
                }
                return SessionedWidget(
                  context: context,
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                        centerTitle: false,
                        titleSpacing: -12,
                        title: Text(
                            'Account Status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17, color: Colors.darkBlue
                            )
                        ),
                        elevation: 0,
                        backgroundColor: Color(0XFFF3F6FC),//Colors.backgroundWhite,
                        iconTheme: IconThemeData(color: Colors.primaryColor)
                    ),
                    body: Container(
                      color: Color(0XFFF3F6FC),//Colors.backgroundWhite,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: FutureBuilder(
                              future: Future.delayed(Duration(milliseconds: 60), () => "done"),
                              builder: (BuildContext mContext, AsyncSnapshot<dynamic> futureSnap) {
                                if(futureSnap.connectionState != ConnectionState.done || !_displayPageProgress) return SizedBox();
                                return Padding(
                                  padding: EdgeInsets.only(left: 16,right: 16,  top: 8, bottom: 16),
                                  child: PieProgressBar(
                                    viewPager: _pageController,
                                    totalItemCount: _pages.length,
                                    pageTitles: getPageTitles(),
                                    displayTitle: false,
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(child: setupPageView())
                        ],
                      ),
                    ),
                  ),
                );
              }
          ),
    ));
  }

  @override
  void dispose() {
    disposeAll();
    _viewModel.dispose();
    super.dispose();
  }
}

