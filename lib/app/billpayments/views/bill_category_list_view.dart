import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_purchase_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_view.dart';
import 'package:moniepoint_flutter/core/pnd_notification_banner.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/views/empty_list_layout_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_category.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_category_view_model.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/icon_curved_container.dart';
import 'package:provider/provider.dart';

class BillCategoryListScreen extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  BillCategoryListScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() => _BillCategoryListScreen();
}

class _BillCategoryListScreen extends State<BillCategoryListScreen> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late final AnimationController _animationController;
  final List<BillerCategory> _currentItems = [];

  _BillCategoryListScreen() {
    this._animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000)
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget makeListView(BuildContext context, AsyncSnapshot<Resource<List<BillerCategory>?>> a) {
    return ListViewUtil.makeListViewWithState<BillerCategory>(
        context: context,
        snapshot: a,
        animationController: _animationController,
        currentList: _currentItems,
        emptyPlaceholder: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyLayoutView(
                "There are currently no bill category"
            )
          ],
        ),
        listView: (List<BillerCategory>? items) {
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
                return _BillCategoryListItem(items![index], index, (item, selectedIndex) {
                  final viewModel = Provider.of<BillPurchaseViewModel>(context, listen: false);
                  viewModel.setBillerCategory(item);
                  Navigator.of(context).pushNamed(BillScreen.BILL_BILLER_SCREEN, arguments: item);
                });
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewModel = Provider.of<BillCategoryViewModel>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PndNotificationBanner(
          onBannerTap: () {
            Navigator.of(widget._scaffoldKey.currentContext!).pushNamed(Routes.ACCOUNT_UPDATE);
          },
        ),
        SizedBox(height: 16,),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Select Category",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.textColorBlack
            ),
          ),
        ),
        Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 24),
              padding: EdgeInsets.only(top: 8),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: StreamBuilder(
                  stream: viewModel.getCategories(),
                  builder: (BuildContext context, AsyncSnapshot<Resource<List<BillerCategory>?>> a) {
                    return makeListView(context, a);
                  }),
            )
        ),
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

class _BillCategoryListItem extends Container {

  final BillerCategory _billCategory;
  final int position;
  final OnItemClickListener<BillerCategory, int>? _onItemClickListener;

  _BillCategoryListItem(this._billCategory, this.position, this._onItemClickListener);

  Widget initialView(String? svg) {
    return IconCurvedContainer(
        width: 53,
        height: 53,
        padding: EdgeInsets.all(12),
        backgroundColor: Colors.primaryColor.withOpacity(0.1),
        child: (svg != null)
            ? SvgPicture.string(svg, width: 16, height: 16,)
            : SvgPicture.asset("")
    );
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
            onTap: () => _onItemClickListener?.call(_billCategory, position),
            child: Container(
              padding: EdgeInsets.only(top: 16, bottom: 16, left: 21, right: 21),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  initialView(_billCategory.svgImage),
                  SizedBox(width: 16),
                  Expanded(
                      child: Text(_billCategory.name ?? "",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.textColorBlack,
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
