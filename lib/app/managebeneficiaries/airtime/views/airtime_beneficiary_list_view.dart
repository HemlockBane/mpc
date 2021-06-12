import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/viewmodels/airtime_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_list_item.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_list_state.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/managed_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/remove_beneficiary_dialog.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/paging/page_config.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:provider/provider.dart';

class AirtimeBeneficiaryListScreen extends StatefulWidget {

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool isSelectMode;

  AirtimeBeneficiaryListScreen({required Key key, this.scaffoldKey, this.isSelectMode = true}):super(key: key);

  @override
  State<StatefulWidget> createState() => AirtimeBeneficiaryListState();

}

class AirtimeBeneficiaryListState extends BeneficiaryListState<AirtimeBeneficiaryListScreen> {

  AirtimeBeneficiaryViewModel? _viewModel;
  ScrollController _scrollController = ScrollController();
  PagingSource<int, AirtimeBeneficiary> _pagingSource = PagingSource.empty();

  @override
  void initState() {
    _viewModel = Provider.of<AirtimeBeneficiaryViewModel>(context, listen: false);
    _pagingSource = _viewModel?.getAirtimeBeneficiaries() ?? _pagingSource;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _viewModel = Provider.of<AirtimeBeneficiaryViewModel>(context, listen: false);
    return Container(
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
      child: Pager<int, AirtimeBeneficiary>(
          pagingConfig: PagingConfig(pageSize: 20, initialPageSize: 30),
          source: _pagingSource,
          builder: (context, value, _) {
            return ListView.separated(
                controller: _scrollController,
                itemCount: value.data.length,
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Divider(color: Color(0XFFE0E0E0), height: 1,),
                ),
                itemBuilder: (context, index) {
                  return BeneficiaryListItem(value.data[index], index, (beneficiary, int i) {
                    if(widget.isSelectMode) Navigator.of(context).pop(beneficiary);
                    else ManagedBeneficiaryScreen.handleDeleteBeneficiary(context, beneficiary, BeneficiaryType.AIRTIME);
                  });
                });
          }
      ),
    );
  }

  @override
  void searchBeneficiary() {
    print(searchValue);
    setState(() {
      _pagingSource = _viewModel?.searchAirtimeBeneficiaries(searchValue) ?? _pagingSource;
    });
  }

}