import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_validation_status.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_product.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_customer_enquiry_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_purchase_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_list_item.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_shimmer_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/generic_list_placeholder.dart';
import 'package:provider/provider.dart';

import 'dialogs/bill_customer_enquiry_dialog.dart';

class BillBeneficiaryScreen extends StatefulWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;

  BillBeneficiaryScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() => _BillBeneficiaryScreen();

}

class _BillBeneficiaryScreen extends State<BillBeneficiaryScreen> with TickerProviderStateMixin {

  final List<BillBeneficiary> _currentItems = [];
  late final AnimationController _animationController;
  final TextEditingController _customerIdController = TextEditingController();
  Stream<Resource<List<BillBeneficiary>>>? frequentBeneficiaries;
  Stream<Resource<List<BillerProduct>>>? billerProducts;

  BillPurchaseViewModel? viewModel;

  _BillBeneficiaryScreen() {
    this._animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000)
    );
  }

  Widget makeListView(BuildContext context, AsyncSnapshot<Resource<List<BillBeneficiary>?>> a) {
    return ListViewUtil.makeListViewWithState(
        context: context,
        loadingView: BeneficiaryShimmer(),
        snapshot: a,
        animationController: _animationController,
        currentList: _currentItems,
        emptyPlaceholder: GenericListPlaceholder(
            SvgPicture.asset('res/drawables/ic_empty_beneficiary.svg'),
            'You have no saved biller \nbeneficiaries yet.'
        ),
        listView: (List<BillBeneficiary>? items) {
          return ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items?.length ?? 0,
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Divider(color: Color(0XFFE0E0E0), height: 1,),
              ),
              itemBuilder: (context, index) {
                return BeneficiaryListItem(items![index], index, (beneficiary, int i) {
                  viewModel?.setBeneficiary(beneficiary);
                  if(viewModel?.billerProduct != null) {
                    _validateCustomerId(beneficiary.getBeneficiaryDigits(), false);
                  }
                });
              });
        }
    );
  }

  @override
  void initState() {
    this.viewModel = Provider.of<BillPurchaseViewModel>(context, listen: false);
    frequentBeneficiaries = viewModel?.getFrequentBeneficiaries();
    billerProducts = viewModel?.getBillerProducts();
    viewModel?.setBillerProduct(null);
    super.initState();
  }

  String _getHint(BillPurchaseViewModel viewModel) {
    String hint = "Enter Customer ID";
    if(viewModel.billerProduct != null) {
      if(viewModel.billerProduct?.identifierName?.isNotEmpty == true) {
        return "Enter ${viewModel.billerProduct?.identifierName}";
      }
    }
    return hint;
  }

  void _validateCustomerId(String customerIdentity, bool shouldSaveBeneficiary) async {
    FocusManager.instance.primaryFocus?.unfocus();

    dynamic result = await showModalBottomSheet(
        context:  widget._scaffoldKey.currentContext ?? context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ChangeNotifierProvider(
          create: (_) => BillCustomerEnquiryViewModel(),
          child: BillCustomerEnquiryDialog(customerIdentity, viewModel!.billerProduct!, saveBeneficiary: shouldSaveBeneficiary),
        ));

    //<FullName, ValidationReference, isSaveBeneficiary?>
    if (result != null && result is Triple<String?, String?, bool>) {
      final billBeneficiary = BillBeneficiary(
        id: 0,
        name: result.first,
        biller: viewModel?.biller,
        customerIdentity: customerIdentity,
        billerProducts: List.unmodifiable([viewModel!.billerProduct!])
      );
      viewModel?.setBeneficiary(billBeneficiary);
      viewModel?.setSaveBeneficiary(result.third);
      viewModel?.setValidationReference(result.second ?? "");
      _customerIdController.text = "";
      Navigator.of(context).pushNamed(BillScreen.PAYMENT_SCREEN);
    } else if (result != null && result is Error<BillValidationStatus>) {
      showError(
          widget._scaffoldKey.currentContext ?? context,
          title: "Failed Validating Bill Beneficiary",
          message: result.message ?? ""
      );
    } else if(result != null && result is Error){
      showError(
          widget._scaffoldKey.currentContext ?? context,
          title: "Failed Validating Bill Beneficiary",
          message: result.message ?? ""
      );
    }

  }

  bool get isFormValid => viewModel!.billerProduct != null && _customerIdController.text.isNotEmpty;

  void _selectBeneficiary() async {
    final beneficiary = await Navigator.of(widget._scaffoldKey.currentContext!).pushNamed(Routes.SELECT_BILL_BENEFICIARY);
    if(beneficiary is BillBeneficiary) {
      if (viewModel?.billerProduct != null) {
        _validateCustomerId(beneficiary.customerIdentity ?? "", false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Oops! No Bill Product Selected.')));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    this.viewModel = Provider.of<BillPurchaseViewModel>(context, listen: false);
    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 24),
          Padding(
            padding : EdgeInsets.only(left: 16, right: 16),
            child: Text('Select Plan', style: TextStyle(color: Colors.deepGrey, fontSize: 14, fontWeight: FontWeight.w400)),
          ),
          SizedBox(height: 12),
          Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: StreamBuilder(
                    stream: billerProducts,
                    builder: (context, AsyncSnapshot<Resource<List<BillerProduct>>> a) {
                      if(!a.hasData || a.hasError) return Container();
                      if(a.data is Loading && a.data?.data?.isEmpty == true) return SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.darkBlue),
                          ));
                      final data = (a.data?.data ?? []).map((e) => ComboItem(e, e.name ?? "")).toList();
                      return SelectionCombo<BillerProduct>(data, (item, index) {
                        viewModel?.setBillerProduct(item);
                        setState(() {

                        });
                      });
                    }
                ),
              )
          ),
          SizedBox(height: 24),
          Flexible(
              fit: FlexFit.loose,
              child: Padding(
                  padding : EdgeInsets.only(left: 16, right: 16),
                  child : Text(_getHint(viewModel!), textAlign: TextAlign.start, style: TextStyle( fontSize: 14,color: Colors.deepGrey.withOpacity(0.9)))
              )
          ),
          SizedBox(height: 12),
          Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding : EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Styles.appEditText(
                        controller: _customerIdController,
                        hint: _getHint(viewModel!),
                        animateHint: false,
                        maxLines: 1,
                        fontSize: 13,
                        onChanged: (v) => setState((){}),
                        startIcon: Icon(CustomFont.username_icon, size: 24, color: Colors.colorFaded,)
                    )),
                    SizedBox(width: 12,),
                    Styles.imageButton(
                        image: SvgPicture.asset('res/drawables/ic_forward_arrow.svg', color: Colors.white,),
                        onClick: isFormValid ? () => _validateCustomerId(_customerIdController.text, true) : null,
                        disabledColor: Colors.primaryColor.withOpacity(0.5)
                    )
                  ],
                ),
              )
          ),
          SizedBox(height: 24),
          Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding : EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Divider(color: Colors.deepGrey.withOpacity(0.2), thickness: 1)),
                    SizedBox(width: 8),
                    Text('Or Select from Saved  Beneficiaries', style: TextStyle(color: Colors.deepGrey),),
                    SizedBox(width: 8),
                    Expanded(child: Divider(color: Colors.deepGrey.withOpacity(0.2), thickness: 1)),
                  ],
                ),
              )
          ),
          SizedBox(height: 18),
          Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Container(
                width: double.infinity,
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
                    builder: (BuildContext context, AsyncSnapshot<Resource<List<BillBeneficiary>?>> a) {
                      return makeListView(context, a);
                    }),
          )),
          Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Container(
                padding: EdgeInsets.only(bottom: 20),
                color: Colors.white,
                child: Center(
                  child: TextButton(
                      child: Text(
                          'View all Beneficiaries',
                          style: TextStyle(
                              color: Colors.solidOrange,
                              fontWeight: FontWeight.bold
                          )),
                      onPressed: _selectBeneficiary
                  ),
                ),
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _customerIdController.dispose();
    super.dispose();
  }

}