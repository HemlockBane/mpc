import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/views/empty_list_layout_view.dart';
import 'package:moniepoint_flutter/core/views/error_layout_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/viewmodels/bill_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_list_item.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_list_state.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_shimmer_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/managed_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/remove_beneficiary_dialog.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:provider/provider.dart';


class BillBeneficiaryListScreen extends StatefulWidget {

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool isSelectMode;

  BillBeneficiaryListScreen({required Key key, this.scaffoldKey, this.isSelectMode = true}):super(key: key);

  @override
  State<StatefulWidget> createState() => BillBeneficiaryState();

}

class BillBeneficiaryState extends BeneficiaryListState<BillBeneficiaryListScreen> with SingleTickerProviderStateMixin {

  BillBeneficiaryViewModel? _viewModel;
  ScrollController _scrollController = ScrollController();
  PagingSource<int, BillBeneficiary> _pagingSource = PagingSource.empty();
  late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
  );


  @override
  void initState() {
    _viewModel = Provider.of<BillBeneficiaryViewModel>(context, listen: false);
    _pagingSource = _viewModel?.getBillBeneficiaries() ?? _pagingSource;
    super.initState();
  }

  void _retry() => searchBeneficiary();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _viewModel = Provider.of<BillBeneficiaryViewModel>(context, listen: false);
    return Container(
      width: double.infinity,
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
      child: Pager<int, BillBeneficiary>(
          source: _pagingSource,
          builder: (context, value, _) {
            return ListViewUtil.handleLoadStates(
                animationController: _animationController,
                pagingData: value,
                shimmer: BeneficiaryShimmer(),
                listCallback: (PagingData data, bool isEmpty, error) {
                  return Column(
                    children: [
                      Visibility(
                          visible: isEmpty,
                          child: Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EmptyLayoutView(searchValue.isNotEmpty
                                    ? 'You have no saved beneficiary\nwith the name "$searchValue"'
                                    : "You have no saved biller \nbeneficiaries yet.",
                                  imageRes: 'res/drawables/ic_empty_beneficiary.svg',
                                )
                              ],
                            ),
                          )),
                      Visibility(
                          visible: error != null,
                          child: Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ErrorLayoutView(
                                    error?.first ?? "",
                                    error?.second.replaceAll("Transactions", "biller beneficiaries") ?? "", _retry),
                                SizedBox(height: 50,)
                              ],
                            ),
                          )
                      ),
                      Visibility(
                          visible: !isEmpty && error == null,
                          child: Expanded(child: ListView.separated(
                              controller: _scrollController,
                              itemCount: value.data.length,
                              separatorBuilder: (context, index) => Padding(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Divider(color: Color(0XFFE0E0E0), height: 1,),
                              ),
                              itemBuilder: (context, index) {
                                return BeneficiaryListItem(value.data[index], index, (beneficiary, int i) {
                                  if (widget.isSelectMode) Navigator.of(context).pop(beneficiary);
                                  else ManagedBeneficiaryScreen.handleDeleteBeneficiary(context, beneficiary, BeneficiaryType.BILL)
                                      .then((value) => (value) ?  searchBeneficiary() : null);
                                });
                              }),
                          ))
                    ],
                  );
                }
            );
          }
      ),
    );
  }

  @override
  void searchBeneficiary() {
    setState(() {
      _pagingSource = _viewModel?.searchBillBeneficiaries(searchValue) ?? _pagingSource;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

}