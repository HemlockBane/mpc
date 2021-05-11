import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/accountupdates/viewmodels/account_update_view_model.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/additional_info_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/customer_address_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/next_of_kin_view.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/proof_of_address_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
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

  late PageView _pageView;
  late AccountUpdateViewModel _viewModel;


  Widget setupPageView() {
    List<Widget> pages = [
      AdditionalInfoScreen(),
      CustomerIdentificationScreen(),
      CustomerAddressScreen(),
      ProofOfAddressScreen(),
      NextOfKinScreen()
    ];
    this._pageView = PageView.builder(
        itemCount: pages.length,
        controller: PageController(),
        itemBuilder: (BuildContext context, int index){
          return pages[index % pages.length];
        });
    return _pageView;
  }

  @override
  void initState() {
    _viewModel = AccountUpdateViewModel();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _viewModel.fetchCountries().listen((event) {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: _viewModel),
        ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: false,
            leadingWidth: 24,
            title: Text('Account Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.darkBlue)),
            elevation: 0,
            backgroundColor: Colors.backgroundWhite,
            iconTheme: IconThemeData(color: Colors.primaryColor)
        ),
        body: Container(
          color: Colors.backgroundWhite,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: PieProgressBar(),
              ),
              SizedBox(height: 32,),
              Expanded(child: setupPageView(),)
            ],
          ),
        ),
      ),
    );
  }

}