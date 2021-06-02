import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/viewmodels/bill_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_list_item.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:provider/provider.dart';


class AirtimeBeneficiaryListScreen extends StatefulWidget {

  final GlobalKey<ScaffoldState>? scaffoldKey;

  AirtimeBeneficiaryListScreen({this.scaffoldKey});

  @override
  State<StatefulWidget> createState() => _AirtimeBeneficiaryListScreen();

}

class _AirtimeBeneficiaryListScreen extends State<AirtimeBeneficiaryListScreen> {

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AirtimeBeneficiaryViewModel>(context, listen: false);
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
          source: viewModel.getAirtimeBeneficiaries(),
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