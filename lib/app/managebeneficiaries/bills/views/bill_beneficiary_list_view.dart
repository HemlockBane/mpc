import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/viewmodels/bill_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_list_item.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:provider/provider.dart';


class BillBeneficiaryListScreen extends StatefulWidget {

  final GlobalKey<ScaffoldState>? scaffoldKey;

  BillBeneficiaryListScreen({this.scaffoldKey});

  @override
  State<StatefulWidget> createState() => _BillBeneficiaryScreen();

}

class _BillBeneficiaryScreen extends State<BillBeneficiaryListScreen> {

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BillBeneficiaryViewModel>(context, listen: false);
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
      child: Pager<int, BillBeneficiary>(
          source: viewModel.getBillBeneficiaries(),
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

                  });
                });
          }
      ),
    );
  }

}