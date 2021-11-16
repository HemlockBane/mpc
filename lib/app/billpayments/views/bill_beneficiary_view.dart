import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_validation_status.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_product.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_customer_enquiry_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_purchase_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_view.dart';
import 'package:moniepoint_flutter/app/billpayments/views/biller_logo.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_list_item.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_shimmer_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/generic_list_placeholder.dart';
import 'package:moniepoint_flutter/core/views/selection_combo_two.dart';
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
              padding: EdgeInsets.only(left: 20, right: 20),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items?.length ?? 0,
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 6,bottom: 5),
                child: Divider(color: Colors.transparent, height: 1,),
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
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Column(
            children: [
              Text(
                viewModel?.biller?.name ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.textColorBlack
                ),
              ),
              Text(
                viewModel?.billerCategory?.name ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.textColorBlack.withOpacity(0.5)
                ),
              )
            ],
          ),
        ),
        Expanded(child: Container(
          margin: EdgeInsets.only(top: 24),
          padding: EdgeInsets.only(top: 8),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
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
                      child: _BillerProductsView(
                        billerProducts: billerProducts,
                        biller: viewModel!.biller!,
                        fileStreamFn: viewModel!.getFile,
                        defaultSelected: viewModel?.billerProduct,
                        onItemSelected: (item,_) {
                          viewModel?.setBillerProduct(item);
                          setState(() {});
                        },
                      ),
                    )
                ),
                SizedBox(height: 32),
                Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                        padding : EdgeInsets.only(left: 16, right: 16),
                        child : Text(_getHint(viewModel!),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.textColorMainBlack
                            )
                        )
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
                          )),
                          SizedBox(width: 9,),
                          Styles.imageButton(
                              padding: EdgeInsets.only(right: 24, left: 24, top: 20.5, bottom: 20.5),
                              image: SvgPicture.asset('res/drawables/ic_forward_anchor.svg', color: Colors.white,),
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
                      child: StreamBuilder(
                          stream: frequentBeneficiaries ,
                          builder: (BuildContext context, AsyncSnapshot<Resource<List<BillBeneficiary>?>> a) {
                            return makeListView(context, a);
                          }),
                    )
                ),
                Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Center(
                      child: TextButton(
                          child: Text(
                              'View all Beneficiaries',
                              style: TextStyle(
                                  color: Colors.solidOrange,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          onPressed: _selectBeneficiary
                      ),
                    )
                )
              ],
            ),
          ),
        ))
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _customerIdController.dispose();
    super.dispose();
  }

}

class _BillerProductsView extends StatelessWidget {

  _BillerProductsView({
    required this.billerProducts,
    required this.biller,
    required this.fileStreamFn,
    this.onItemSelected,
    this.defaultSelected
  });

  final Biller biller;
  final Stream<Resource<List<BillerProduct>>>? billerProducts;
  final Stream<Resource<FileResult>> Function(String logoId) fileStreamFn;
  final OnItemClickListener<BillerProduct?, int>? onItemSelected;
  final BillerProduct? defaultSelected;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: billerProducts,
        builder: (context, AsyncSnapshot<Resource<List<BillerProduct>>> a) {
          if(!a.hasData || a.hasError) return Container();
          if(a.data is Loading && a.data?.data?.isEmpty == true) return SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.darkBlue),
              ));

          final data = (a.data?.data ?? []).map((product) {
            return ComboItem(product, product.name ?? "",
              isSelected: defaultSelected?.id == product.id
            );
          }).toList();
          return SelectionCombo2<BillerProduct>(data,
            onItemSelected: onItemSelected,
            titleIcon: (item) => BillerLogo(biller: biller, fileStreamFn: fileStreamFn),
          );
        }
    );
  }

}