
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_transaction.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/airtime_history_view_model.dart';
import 'package:moniepoint_flutter/core/views/empty_list_layout_view.dart';
import 'package:moniepoint_flutter/core/views/error_layout_view.dart';
import 'package:moniepoint_flutter/app/transfers/views/history_shimmer_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/filter_item.dart';
import 'package:moniepoint_flutter/core/paging/page_config.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/filter_view.dart';
import 'package:provider/provider.dart';

import 'airtime_history_list_item.dart';

class AirtimeHistoryScreen extends StatefulWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey;
  AirtimeHistoryScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() => _AirtimeHistoryScreen();

}

class _AirtimeHistoryScreen extends State<AirtimeHistoryScreen> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {

  late ScrollController _scrollController;
  bool isInFilterMode = false;
  bool _isFilterOpened = false;
  PagingSource<int, AirtimeTransaction> _pagingSource = PagingSource.empty();

  late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
  );

  @override
  void initState() {
    final viewModel = Provider.of<AirtimeHistoryViewModel>(context, listen: false);
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
    final viewModel = Provider.of<AirtimeHistoryViewModel>(context, listen: false);
    setState(() => _pagingSource = viewModel.getPagedHistoryTransaction());
  }

  void _dateFilterDateChanged(int startDate, int endDate) {
    final viewModel = Provider.of<AirtimeHistoryViewModel>(context, listen: false);
    setState(() {
      viewModel.setStartAndEndDate(startDate, endDate);
      _pagingSource = viewModel.getPagedHistoryTransaction();
    });
  }

  void _onCancelFilter() {
    final viewModel = Provider.of<AirtimeHistoryViewModel>(context, listen: false);
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
    final viewModel = Provider.of<AirtimeHistoryViewModel>(context, listen: false);
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
      child:
      Pager<int, AirtimeTransaction>(
        pagingConfig: PagingConfig(pageSize: 10, initialPageSize: 15),
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
                            onCancel: _onCancelFilter ,
                            dateFilterCallback: _dateFilterDateChanged,
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
                                  ? 'You have no Airtime/Data purchase within this date range.'
                                  : "You have no airtime/data purchase history yet.",
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
                                  error?.second.replaceAll("Transactions", "airtime/data purchase history") ?? "", _retry),
                              SizedBox(height: 50,)
                            ],
                          ),
                        )
                    ),
                    Visibility(
                      visible: !isEmpty && error == null,
                      child: Flexible(
                          child: ListView.separated(
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: items.data.length,
                              separatorBuilder: (context, index) => Padding(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Divider(color: Color(0XFFE0E0E0), height: 1,),
                              ),
                              itemBuilder: (context, index) {
                                return AirtimeHistoryListItem(items.data[index], index, (item, i) {
                                  Navigator.of(context).pushNamed(Routes.AIRTIME_DETAIL, arguments: item.historyId);
                                });
                              })
                        ),
                    )
                  ],
                );
              }
          );
        },
      )
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