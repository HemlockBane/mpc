import 'dart:convert';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_purchase_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/biller_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_view.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/views/empty_list_layout_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_category.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:provider/provider.dart';

import 'biller_logo.dart';

class BillerListScreen extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  BillerListScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() => _BillerListScreen();
}

class _BillerListScreen extends State<BillerListScreen> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late final AnimationController _animationController;
  final List<Biller> _currentItems = [];

  _BillerListScreen() {
    this._animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000)
    );
  }

  @override
  void initState() {
    final viewModel = Provider.of<BillPurchaseViewModel>(context, listen: false);
    viewModel.setBiller(null);
    super.initState();
  }

  Widget makeListView(BuildContext context, AsyncSnapshot<Resource<List<Biller>?>> a) {
    final viewModel = Provider.of<BillPurchaseViewModel>(context, listen: false);

    return ListViewUtil.makeListViewWithState<Biller>(
        context: context,
        snapshot: a,
        animationController: _animationController,
        displayLocalData: false,
        currentList: _currentItems,
        emptyPlaceholder: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyLayoutView(
                "There are currently no biller for the\nselected bill category"
            )
          ],
        ),
        listView: (List<Biller>? items) {
          return ListView.separated(
              shrinkWrap: true,
              itemCount: items?.length ?? 0,
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 21, right: 21),
                child: Divider(
                  color: Color(0XFFBFD7E5).withOpacity(0.6),
                  height: 1,
                ),
              ),
              itemBuilder: (context, index) {
                return BillerListItem(items![index], index, (item, selectedIndex) {
                  viewModel.setBiller(item);
                  Navigator.of(context).pushNamed(BillScreen.BENEFICIARY_SCREEN, arguments: item);
                });
              });
        });
  }

  Widget _mainContent(BillerCategory billCategory) {
    final viewModel = Provider.of<BillerViewModel>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 24,),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Styles.appEditText(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              startIcon: Icon(CustomFont.search, color: Colors.colorFaded),
              hint: 'Search Biller',
              fontSize: 13,
              onChanged: (value) {
              }
          ),
        ),
        SizedBox(height: 23,),
        Divider(
          color: Color(0XFFBFD7E5).withOpacity(0.6),
          height: 1,
        ),
        SizedBox(height: 18,),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Select Biller",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.textColorBlack
              ),
            ),
          ),
        ),
        SizedBox(height: 12,),
        Expanded(child: StreamBuilder(
            stream: viewModel.getBillersByCategoryId(billCategory.categoryCode ?? ""),
            builder: (BuildContext context, AsyncSnapshot<Resource<List<Biller>?>> a) {
              return makeListView(context, a);
            })
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final billCategory = ModalRoute.of(context)!.settings.arguments as BillerCategory;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            billCategory.name ?? "",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.textColorBlack
            ),
          ),
        ),
        Expanded(child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 24),
          padding: EdgeInsets.only(top: 8),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: _mainContent(billCategory),
        )),
      ],
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

class BillerListItem extends StatefulWidget {

  final Biller _billBiller;
  final int position;
  final OnItemClickListener<Biller, int>? _onItemClickListener;

  BillerListItem(
      this._billBiller,
      this.position,
      this._onItemClickListener
      );

  @override
  State<StatefulWidget> createState() => _BillerListItem();

}

class _BillerListItem extends State<BillerListItem> {
  late final BillPurchaseViewModel viewModel;

  @override
  void initState() {
    viewModel = Provider.of<BillPurchaseViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            highlightColor: Colors.primaryColor.withOpacity(0.02),
            overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.05)),
            onTap: () => widget._onItemClickListener?.call(widget._billBiller, widget.position),
            child: Container(
              padding: EdgeInsets.only(top: 16, bottom: 16, left: 21, right: 21),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BillerLogo(
                    biller: widget._billBiller,
                    fileStreamFn: viewModel.getFile,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                      child: Text(widget._billBiller.name ?? "",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.colorPrimaryDark,
                              fontWeight: FontWeight.bold
                          )
                      )
                  ),
                  SvgPicture.asset(
                    'res/drawables/ic_forward_anchor.svg',
                    width: 13.5,
                    height: 13.5,
                    color: Colors.primaryColor,
                  ),
                  SizedBox(width: 2),
                ],
              ),
            ),
          ),
        ),
      );
}
