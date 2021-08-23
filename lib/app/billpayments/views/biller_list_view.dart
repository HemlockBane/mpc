import 'dart:convert';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_purchase_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/biller_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_view.dart';
import 'package:moniepoint_flutter/core/views/empty_list_layout_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_category.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:provider/provider.dart';

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
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Divider(
                      color: Colors.transparent,
                      height: 12,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewModel = Provider.of<BillerViewModel>(context, listen: false);
    final billCategory = ModalRoute.of(context)!.settings.arguments as BillerCategory;
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Divider(
            height: 1,
            color: Color(0XFFE0E0E0),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
              child: StreamBuilder(
                  stream: viewModel.getBillersByCategoryId(billCategory.categoryCode ?? ""),
                  builder: (BuildContext context, AsyncSnapshot<Resource<List<Biller>?>> a) {
                    return makeListView(context, a);
                  })
          ),
        ],
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

  Stream<Resource<FileResult>>? _fileResultStream;
  Image? _itemImage;

  Widget _defaultImage() {
    return Container(
      width: 34,
      height: 34,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.primaryColor.withOpacity(0.1)),
      child: Center(
        child: Container(),
      ),
    );
  }

  @override
  void initState() {
    _fetchBillerLogo();
    super.initState();
  }

  void _fetchBillerLogo() {
    _fileResultStream = Provider.of<BillPurchaseViewModel>(context, listen: false)
        .getFile(widget._billBiller.logoImageUUID ?? "");
  }

  Widget initialView(BuildContext mContext) {
    if(widget._billBiller.logoImageUUID == null) return _defaultImage();
    return Visibility(
      visible: widget._billBiller.logoImageUUID != null,
      child: StreamBuilder(
          stream: _fileResultStream,
          builder: (mContext, AsyncSnapshot<Resource<FileResult>> snapShot) {
            //TODO refactor to make re-usable
            if(!snapShot.hasData || snapShot.data == null || (snapShot.data is Error && _itemImage == null)) return _defaultImage();
            final base64 = snapShot.data?.data;
            final base64String = base64?.base64String;
            if((base64 == null || base64String == null || base64String.isEmpty == true) && _itemImage == null) return _defaultImage();
            _itemImage = (_itemImage == null)
                ? Image.memory(base64Decode(base64String!), width: 40, height: 40, errorBuilder: (_,_i,_j) {
                  return Container();
                })
                : _itemImage;
            return _itemImage!;
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(13)),
          border: Border.all(
              color: Colors.colorPrimaryDark.withOpacity(0.1),
              width: 0.5
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.colorPrimaryDark.withOpacity(0.1),
                offset: Offset(0, 1),
                blurRadius: 0.5)
          ]),
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            highlightColor: Colors.primaryColor.withOpacity(0.02),
            overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.05)),
            borderRadius: BorderRadius.all(Radius.circular(13)),
            onTap: () => widget._onItemClickListener?.call(widget._billBiller, widget.position),
            child: Container(
              padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  initialView(context),
                  SizedBox(width: 16),
                  Expanded(
                      child: Text(widget._billBiller.name ?? "",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.colorPrimaryDark,
                              fontWeight: FontWeight.bold))
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
