
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_transaction.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_history_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_history_list_item.dart';
import 'package:moniepoint_flutter/core/views/empty_list_layout_view.dart';
import 'package:moniepoint_flutter/core/views/error_layout_view.dart';
import 'package:moniepoint_flutter/app/transfers/views/history_shimmer_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/paging/page_config.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/filter_view.dart';
import 'package:moniepoint_flutter/core/views/moniepoint_scaffold.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

class BillHistoryScreen extends StatefulWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  BillHistoryScreen();

  @override
  State<StatefulWidget> createState() => _BillHistoryScreen();

}

class _BillHistoryScreen extends State<BillHistoryScreen> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late final BillHistoryViewModel _viewModel;
  late ScrollController _scrollController;
  bool isInFilterMode = false;
  bool _isFilterOpened = false;
  PagingSource<int, BillTransaction> _pagingSource = PagingSource.empty();

  late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
  );

  @override
  void initState() {
    _viewModel = Provider.of<BillHistoryViewModel>(context, listen: false);
    _pagingSource = _viewModel.getPagedHistoryTransaction();
    _scrollController = ScrollController();
    super.initState();
  }

  Widget filterByDateButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        icon: SvgPicture.asset('res/drawables/ic_account_filter_2.svg'),
        onPressed: () => setState(() => isInFilterMode = true ),
        label: Text(
          'Filter',
          style: TextStyle(
            color: Colors.primaryColor,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size(40, 0)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            overlayColor: MaterialStateProperty.all(Colors.darkBlue.withOpacity(0.2)),
            padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(16, 7.2, 25, 7.2)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(41))),
            backgroundColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.2))
        ),
      ),
    );
  }

  void _retry() {
    setState(() {
      _pagingSource = _viewModel.getPagedHistoryTransaction();
    });
  }

  void _dateFilterDateChanged(int startDate, int endDate) {
    setState(() {
      _viewModel.setStartAndEndDate(startDate, endDate);
      _pagingSource = _viewModel.getPagedHistoryTransaction();
    });
  }

  void _onCancelFilter() {
    setState(() {
      isInFilterMode = false;
      _isFilterOpened = false;
      _viewModel.resetFilter();
      _pagingSource = _viewModel.getPagedHistoryTransaction();
    });
  }

  Widget _makeListView() {
    return Container(
      margin: EdgeInsets.only(top: 24),
      padding: EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color: Colors.darkBlue.withOpacity(0.1),
                offset: Offset(0, 4),
                blurRadius: 12)
          ]),
      child: Pager<int, BillTransaction>(
        scrollController: _scrollController,
        pagingConfig: PagingConfig(pageSize: 100, initialPageSize: 130),
        source: _pagingSource,
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
                          _viewModel.filterableItems,
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
                        padding: EdgeInsets.only(left: 16, bottom: 7),
                        child: filterByDateButton(),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Visibility(
                        visible: isEmpty,
                        child: Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              EmptyLayoutView(
                                _viewModel.isFilteredList()
                                    ? 'You have no bill purchase within this date range.'
                                    : "You have no bill purchase history yet.",
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
                                  error?.second.replaceAll("Transactions", "bill purchase history") ?? "",
                                  _retry
                              ),
                              SizedBox(height: 50)
                            ],
                          ),
                        )),
                    Visibility(
                        visible: !isEmpty && error == null,
                        child: Flexible(
                            child: ListView.separated(
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: items.data.length,
                                separatorBuilder: (context, index) => Padding(
                                      padding: EdgeInsets.only(left: 16, right: 16),
                                      child: Divider(
                                        color: Color(0XFFE0E0E0),
                                        height: 1,
                                      ),
                                    ),
                                itemBuilder: (context, index) {
                                  return BillHistoryListItem(
                                      transaction: items.data[index],
                                      position: index,
                                      onItemClickListener: (item, i) {
                                        Navigator.of(context).pushNamed(Routes.BILL_DETAIL,arguments: item.id);
                                      },
                                      fileStreamFn: _viewModel.getFile
                                  );
                                })
                        )),
                    LoadStatesLoadingIndicator(pagingData: data)
                  ],
                );
              });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MoniepointScaffold(
      key: widget._scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: Colors.primaryColor),
        title: Text('Bill Payment History',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.textColorBlack
            )
        ),
        backgroundColor: Color(0XFFE8EFFA).withOpacity(0.52),
        elevation: 0,
      ),
      body: SessionedWidget(
        context: context,
        child: Container(
          color: Color(0XFFE8EFFA).withOpacity(0.52),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "History",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.textColorBlack),
                ),
              ),
              Expanded(child: _makeListView()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


}