import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/views/empty_list_layout_view.dart';
import 'package:moniepoint_flutter/core/views/error_layout_view.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/app/transfers/viewmodels/transfer_history_view_model.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_history_list_item.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/paging/page_config.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/filter_view.dart';
import 'package:provider/provider.dart';

import 'history_shimmer_view.dart';

class TransferHistoryScreen extends StatefulWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final Function(SingleTransferTransaction transaction)? replayTransactionCallback;

  TransferHistoryScreen(this._scaffoldKey, {this.replayTransactionCallback});

  @override
  State<StatefulWidget> createState() => _TransferHistoryScreen();

}

class _TransferHistoryScreen extends State<TransferHistoryScreen> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {

  late ScrollController _scrollController;
  bool isInFilterMode = false;
  bool _isFilterOpened = false;
  PagingSource<int, SingleTransferTransaction> _pagingSource = PagingSource.empty();

  late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
  );

  @override
  void initState() {
    final viewModel = Provider.of<TransferHistoryViewModel>(context, listen: false);
    _pagingSource = viewModel.getPagedHistoryTransaction();
    _scrollController = ScrollController();
    super.initState();
  }

  Widget filterByDateButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () => setState(() => isInFilterMode = true ),
        icon: SvgPicture.asset('res/drawables/ic_filter.svg'),
        label: Text('Filter by Date', style: TextStyle(color: Colors.darkBlue, fontSize: 15, fontWeight: FontWeight.bold),),
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size(40, 0)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            overlayColor: MaterialStateProperty.all(Colors.darkBlue.withOpacity(0.2)),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 28, vertical: 7)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            backgroundColor: MaterialStateProperty.all(Colors.solidDarkBlue.withOpacity(0.05))
        ),
      ),
    );
  }

  void _retry() {
  }

  void _dateFilterDateChanged(int startDate, int endDate) {
    final viewModel = Provider.of<TransferHistoryViewModel>(context, listen: false);
    setState(() {
      viewModel.setStartAndEndDate(startDate, endDate);
      _pagingSource = viewModel.getPagedHistoryTransaction();
    });
  }

  void _onCancelFilter() {
    final viewModel = Provider.of<TransferHistoryViewModel>(context, listen: false);
    setState(() {
      isInFilterMode = false;
      _isFilterOpened = false;
      viewModel.resetFilter();
      _pagingSource = viewModel.getPagedHistoryTransaction();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewModel = Provider.of<TransferHistoryViewModel>(context, listen: false);
    return Container(
      width: double.infinity,
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
      child: Pager<int, SingleTransferTransaction>(
        pagingConfig: PagingConfig(pageSize: 40, initialPageSize: 40),
        source: _pagingSource,
        scrollController: _scrollController,
        builder: (context, items, _) {
          return ListViewUtil.handleLoadStates(
              animationController: _animationController,
              pagingData: items,
              shimmer: HistoryListShimmer(),
              listCallback: (PagingData data, bool isEmpty, error) {
                return Column(
                  children: [
                    Visibility(
                      visible: isInFilterMode,
                      child: Flexible(
                        flex: 0,
                        child: FilterLayout(
                          widget._scaffoldKey,
                          viewModel.filterableItems,
                          dateFilterCallback: _dateFilterDateChanged,
                          onCancel: _onCancelFilter,
                          isPreviouslyOpened: _isFilterOpened,
                          onOpen: () => _isFilterOpened = true,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !isInFilterMode,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16, bottom: 7),
                        child: filterByDateButton(),
                      ),
                    ),
                    SizedBox(height: 24,),
                    Visibility(
                        visible: isEmpty,
                        child: Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              EmptyLayoutView(viewModel.isFilteredList()
                                  ? 'You have no Transfers within this date range.'
                                  : "You have no transfer history yet.",
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
                                  error?.second.replaceAll("Transactions", "transfer history") ?? "", _retry),
                              SizedBox(height: 50,)
                            ],
                          ),
                        )
                    ),
                    Visibility(
                        visible: !isEmpty && error == null,
                        child: Expanded(child: ListView.separated(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: items.data.length,
                            separatorBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: Divider(color: Color(0XFFE0E0E0), height: 1,),
                            ),
                            itemBuilder: (context, index) {
                              return TransferHistoryListItem(items.data[index], index, (item, i) async {
                                dynamic transaction = await Navigator.of(context).pushNamed(Routes.TRANSFER_DETAIL, arguments: item.historyId);
                                if(transaction != null && transaction is SingleTransferTransaction) {
                                  widget.replayTransactionCallback?.call(transaction);
                                }
                              });
                            }),)
                    )
                  ],
                );
              }
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

}