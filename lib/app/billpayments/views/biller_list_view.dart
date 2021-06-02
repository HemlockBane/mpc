import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_purchase_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/biller_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_category.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_category_view_model.dart';
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

class _BillerListScreen extends State<BillerListScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late final AnimationController _animationController;
  final List<Biller> _currentItems = [];

  _BillerListScreen() {
    this._animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
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
        currentList: _currentItems,
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
                return _BillerListItem(items![index], index, (item, selectedIndex) {
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

class _BillerListItem extends Container {

  final Biller _billBiller;
  final int position;
  final OnItemClickListener<Biller, int>? _onItemClickListener;


  static const BILLER_IMAGE_MAP = const {
    "aedc": "res/drawables/aedc.png",
    "eedc": "res/drawables/eedc.png",
    "ekedc": "res/drawables/ekedc.png",
    "ibedc": "res/drawables/ibedc.png",
    "ikedc": "res/drawables/ikedc.png",
    "jedc": "res/drawables/jedc.png",
    "kaduna": "res/drawables/kaduna.png",
    "kedco": "res/drawables/kedco.png",
    "phed": "res/drawables/phed.png",
  };

  _BillerListItem(
      this._billBiller,
      this.position,
      this._onItemClickListener
      );

  Widget initialView(String? svg) {
    return Container(
      width: 34,
      height: 34,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.primaryColor.withOpacity(0.1)),
      child: Center(
        child: (svg != null)
            ? SvgPicture.string(
                svg,
                width: 16,
                height: 16,
              )
            : Container(),
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
            onTap: () => _onItemClickListener?.call(_billBiller, position),
            child: Container(
              padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  initialView(_billBiller.svgImage),
                  SizedBox(width: 16),
                  Expanded(
                      child: Text(_billBiller.name ?? "",
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
