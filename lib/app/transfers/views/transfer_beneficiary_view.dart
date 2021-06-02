import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/customer/account_provider.dart';
import 'package:moniepoint_flutter/app/institutions/institution_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_list_item.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_shimmer_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/transfers/viewmodels/account_enquiry_view_model.dart';
import 'package:moniepoint_flutter/app/transfers/viewmodels/transfer_view_model.dart';
import 'package:moniepoint_flutter/app/transfers/views/dialogs/account_enquiry_dialog.dart';
import 'package:moniepoint_flutter/app/transfers/views/dialogs/institutions_bottom_sheet.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_view.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:provider/provider.dart';

class TransferBeneficiaryScreen extends StatefulWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;

  TransferBeneficiaryScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _TransferBeneficiaryScreen();
  }
}

class _TransferBeneficiaryScreen extends State<TransferBeneficiaryScreen> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin{

  final List<TransferBeneficiary> _currentItems = [];
  final TextEditingController _accountNumberController = TextEditingController();
  late final AnimationController _animationController;
  Stream<Resource<List<TransferBeneficiary>>>? frequentBeneficiaries;

  _TransferBeneficiaryScreen() {
    this._animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000)
    );
  }

  @override
  void initState() {
    final viewModel = Provider.of<TransferViewModel>(context, listen: false);
    frequentBeneficiaries = viewModel.getFrequentBeneficiaries();
    super.initState();
  }

  void displayInstitutionsDialog() async {
    FocusManager.instance.primaryFocus?.unfocus();
    AccountProvider? provider = await showModalBottomSheet(
        context: widget._scaffoldKey.currentContext ?? context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ChangeNotifierProvider(
          create: (_) => InstitutionViewModel(),
          child: InstitutionDialog(_accountNumberController.text),
        ));

    if(provider != null) {
      doNameEnquiry(
          provider,
          TransferBeneficiary(accountName: "", accountNumber: _accountNumberController.text)
      );
    }
  }

  void doNameEnquiry(AccountProvider accountProvider, TransferBeneficiary beneficiary,
      {bool saveBeneficiary = true}) async {

    final viewModel = Provider.of<TransferViewModel>(context, listen: false);
    dynamic result = await showModalBottomSheet(
        context: widget._scaffoldKey.currentContext ?? context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ChangeNotifierProvider(
          create: (_) => AccountEnquiryViewModel(),
          child: AccountEnquiryDialog(accountProvider, beneficiary, saveBeneficiary: saveBeneficiary),
        ));

    if (result != null && result is Tuple<TransferBeneficiary, bool>) {
      viewModel
        ..setBeneficiary(result.first)
        ..setSaveBeneficiary(result.second);
      Navigator.of(context).pushNamed(TransferScreen.PAYMENT_SCREEN);
    } else if (result != null && result is Error<TransferBeneficiary>) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: widget._scaffoldKey.currentContext ?? context,
          builder: (context) => BottomSheets.displayErrorModal(context, title: "Oops", message: result.message));
    }
  }

  Widget makeListView(BuildContext context, AsyncSnapshot<Resource<List<TransferBeneficiary>?>> a) {
    return ListViewUtil.makeListViewWithState(
        context: context,
        loadingView: BeneficiaryShimmer(),
        snapshot: a,
        animationController: _animationController,
        currentList: _currentItems,
        listView: (List<TransferBeneficiary>? items) {
          return ListView.separated(
              shrinkWrap: true,
              itemCount: items?.length ?? 0,
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Divider(color: Color(0XFFE0E0E0), height: 1,),
              ),
              itemBuilder: (context, index) {
                return BeneficiaryListItem(items![index], index, (beneficiary, int i) {
                  final provider = AccountProvider()
                    ..bankCode = beneficiary.getBeneficiaryProviderCode()
                    ..name = beneficiary.getBeneficiaryProviderName();
                    doNameEnquiry(provider, beneficiary as TransferBeneficiary, saveBeneficiary: false);
                });
              });
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final viewModel = Provider.of<TransferViewModel>(context, listen: false);

    return  Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 24),
            Expanded(
                flex: 0,
                child: Padding(
                    padding : EdgeInsets.only(left: 16, right: 16),
                    child : Text('Enter Account Number', textAlign: TextAlign.start, style: TextStyle( fontSize: 14,color: Colors.deepGrey.withOpacity(0.9)))
                )
            ),
            SizedBox(height: 12),
            Expanded(
                flex: 0,
                child: Padding(
                  padding : EdgeInsets.only(left: 16, right: 16),
                  child: Styles.appEditText(
                      hint: 'Enter Account Number',
                      padding: EdgeInsets.only(top: 17, bottom: 17),
                      animateHint: false,
                      controller: _accountNumberController,
                      inputFormats: [FilteringTextInputFormatter.digitsOnly],
                      fontSize: 13,
                      onChanged: (t) => (t.length == 10) ? displayInstitutionsDialog(): null,
                      startIcon: Icon(CustomFont.bankIcon, size: 20, color: Colors.colorFaded,)
                  ),
                )
            ),
            SizedBox(height: 24),
            Expanded(
                flex: 0,
                child: Padding(
                  padding : EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Divider(height: 1, color: Colors.deepGrey.withOpacity(0.2), thickness: 1)),
                      SizedBox(width: 8),
                      Text('Or', style: TextStyle(color: Colors.deepGrey),),
                      SizedBox(width: 8),
                      Expanded(child: Divider(height: 1, color: Colors.deepGrey.withOpacity(0.2), thickness: 1)),
                    ],
                  ),
                )
            ),
            SizedBox(height: 18),
            Padding(
              padding : EdgeInsets.only(left: 16, right: 16),
              child: Text('Select a Beneficiary', style: TextStyle(color: Colors.deepGrey, fontSize: 14, fontWeight: FontWeight.w200)),
            ),
            SizedBox(height: 10),
            Expanded(child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.darkBlue.withOpacity(0.1),
                    offset: Offset(0, 4),
                    blurRadius: 12
                  )
                ]
              ),
              child: StreamBuilder(
                  stream: frequentBeneficiaries ,
                  builder: (BuildContext context, AsyncSnapshot<Resource<List<TransferBeneficiary>?>> a) {
                    return makeListView(context, a);
                  }),
            )),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              color: Colors.white,
              child: Center(
                child: TextButton(
                  child:Text('View all Beneficiaries', style: TextStyle(color: Colors.solidOrange, fontWeight: FontWeight.bold)),
                  onPressed: ()=>null),
              ),
            )
          ],
        ),

    );
  }
  
  
  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

}