import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/transaction_list_view_model.dart';
import 'package:moniepoint_flutter/app/accounts/views/transaction_history_list_item.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/filter_item.dart';
import 'package:moniepoint_flutter/core/paging/page_config.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/filter_view.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

class AccountTransactionScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AccountTransactionScreen();

}

class _AccountTransactionScreen extends State<AccountTransactionScreen> {

  ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isInFilterMode = false;

  initState() {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    viewModel.getCustomerAccountBalance().listen((event) { });
    super.initState();
  }

  Widget balanceView(TransactionHistoryViewModel viewModel) {
    return Container(
      padding: EdgeInsets.only(top: 26, bottom: 26, left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.primaryColor.withOpacity(0.1),
            offset: Offset(0, 8),
            blurRadius: 4,
            spreadRadius: 0
          )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Available Balance', style: TextStyle(fontSize: 13, color: Colors.colorFaded, fontWeight: FontWeight.normal),),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          color: Colors.darkBlue.withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(16))
                      ),
                      child: Center(
                        child: Text('SAVINGS', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                  )
                ],
              )
          ),
          SizedBox(height: 5),
          Flexible(
              child: StreamBuilder(
                stream: viewModel.balanceStream,
                builder: (context, AsyncSnapshot<AccountBalance?> snapShot){
                  final accountBalance = snapShot.hasData ? snapShot.data?.availableBalance?.formatCurrency ?? "--" : '--';
                  return Text(
                    accountBalance,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  );
                },
              )
          ),
          SizedBox(height: 5,),
          Flexible(
              child: StreamBuilder(
                stream: viewModel.balanceStream,
                builder: (context, AsyncSnapshot<AccountBalance?> snapShot){
                  final accountBalance = snapShot.hasData ? snapShot.data?.ledgerBalance?.formatCurrency ?? "--" : '--';
                  return Text(
                    'Ledger Balance: $accountBalance',
                    style: TextStyle(
                        color: Colors.colorFaded,
                        fontSize: 12,
                        fontFamily: Styles.defaultFont,
                        fontWeight: FontWeight.normal
                    ),
                  ).colorText({accountBalance : Tuple(Colors.white, null)}, bold: false, underline: false);
                },
              )
          ),
          SizedBox(height: 2,),
          Flexible(
            child: Row(
              children: [
                Expanded(child: Divider(color: Colors.white.withOpacity(0.2), height: 1,)),
                SizedBox(width: 6,),
                Styles.imageButton(
                    onClick: () => "",
                    color: Colors.white.withOpacity(0.2),
                    padding: EdgeInsets.symmetric(horizontal: 5.2, vertical: 4),
                    borderRadius: BorderRadius.circular(4),
                    image: SvgPicture.asset('res/drawables/ic_settings.svg', width: 20, height: 20,)
                )
              ],
            ),
          ),
          SizedBox(height: 6,),
          Flexible(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'A/C No.',
                        style: TextStyle(color: Colors.colorFaded, fontSize: 13)
                      ),

                      Text(
                        viewModel.accountNumber,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 14)
                      )
                    ],
                  ),
                  SizedBox(width: 32,),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Account Name',
                            style: TextStyle(color: Colors.colorFaded, fontSize: 13)
                        ),
                        Text(
                            viewModel.accountName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.white, fontSize: 14)
                        )
                      ]
                  ),
                ],
              )
          )
        ],
      ),
    );
  }

  Widget filterMenu() {
    return Flexible(
        flex:0,
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 23, bottom: 7.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: SvgPicture.asset('res/drawables/ic_account_filter.svg'),
                onPressed: () => setState(() => isInFilterMode = true ),
                label: Text('Filter',
                  style: TextStyle(color: Colors.darkBlue, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(40, 0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: MaterialStateProperty.all(Colors.darkBlue.withOpacity(0.2)),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 12, vertical: 6.8)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    backgroundColor: MaterialStateProperty.all(Colors.solidDarkBlue.withOpacity(0.05))
                ),
              ),

              TextButton.icon(
                  onPressed: () => {},
                  icon: SvgPicture.asset('res/drawables/ic_account_download.svg'),
                  label: Text('Download Statement',
                    style: TextStyle(color: Colors.primaryColor, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(40, 0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.1)),
                    padding: MaterialStateProperty.all(EdgeInsets.only(left: 8, right: 2, top: 8, bottom: 8)),
                  )
              )
            ],
          ),
        )
    );
  }

  Widget _listContainer(TransactionHistoryViewModel viewModel, {Widget? child}) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
              color: Colors.primaryColor.withOpacity(0.01),
              offset: Offset(0, -1),
              blurRadius: 3,
              spreadRadius: 0
          )
        ]
      ),
      child: child,
    );
  }


  Widget _pagingView(TransactionHistoryViewModel viewModel) {
    return Pager<int, AccountTransaction>(
        pagingConfig: PagingConfig(pageSize: 10, initialPageSize: 20),
        source: viewModel.getPagedHistoryTransaction(),
        builder: (context, value, _) {
          return Column(
            children: [
              Visibility(
                visible: isInFilterMode,
                child: Flexible(
                  flex: 0,
                  child: FilterLayout(_scaffoldKey, [
                    FilterItem(title: "Date"),
                    FilterItem(title: "Type"),
                    FilterItem(title: "Channel")
                  ], onCancel: (){
                    setState(() { isInFilterMode = false; });
                  }),
                ),
              ),
              Visibility(
                  visible: !isInFilterMode,
                  child: filterMenu()
                  ),
              SizedBox(height: 12,),
              Expanded(child: ListView.separated(
                controller: _scrollController,
                itemCount: value.data.length,
                separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Divider(height: 1,),
                ),
                itemBuilder: (context, index) {
                  print(value.data[index]);
                  return TransactionHistoryListItem(value.data[index], index, (item, i) {

                  });
                },
              ))
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0XFFEAF4FF),
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: -12,
          iconTheme: IconThemeData(color: Colors.primaryColor),
          title: Text('Account',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.darkBlue,
                  fontFamily: Styles.defaultFont,
                  fontSize: 17
              )
          ),
          backgroundColor: Color(0XFFEAF4FF),
          elevation: 0
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
              top: 170,
              bottom: 0,
              right: 0,
              left: 0,
              child: _listContainer(viewModel, child: _pagingView(viewModel))
          ),
          Positioned(
              right: 42,
              left: 42,
              top: 42,
              child: balanceView(viewModel)
          ),
        ],
      ),
    );
  }

}