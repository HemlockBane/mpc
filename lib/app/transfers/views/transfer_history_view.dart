import 'dart:convert';

import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/app/transfers/viewmodels/transfer_history_view_model.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_history_list_item.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/filter_item.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:moniepoint_flutter/core/views/filter_view.dart';
import 'package:provider/provider.dart';

class TransferHistoryScreen extends StatefulWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey;
  TransferHistoryScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() => _TransferHistoryScreen();

}

class _TransferHistoryScreen extends State<TransferHistoryScreen> with AutomaticKeepAliveClientMixin {

  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewModel = Provider.of<TransferHistoryViewModel>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(top: 24),
      padding: EdgeInsets.only(top: 24),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: FilterLayout(widget._scaffoldKey, [FilterItem(title: "Date")])
          ),
          SizedBox(height: 24,),
          Flexible(
              child: Pager<int, SingleTransferTransaction>(
                source: viewModel.getPagedHistoryTransaction(),
                builder: (context, items, _) {
                  return ListView.separated(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: items.data.length,
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Divider(color: Color(0XFFE0E0E0), height: 1,),
                      ),
                      itemBuilder: (context, index) {
                        return TransferHistoryListItem(items.data[index], index, (item, i) {

                        });
                      });
                },
              )
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}