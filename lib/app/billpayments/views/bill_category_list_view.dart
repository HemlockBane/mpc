import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_view.dart';
import 'package:moniepoint_flutter/core/views/empty_list_layout_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_category.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_category_view_model.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:provider/provider.dart';

class BillCategoryListScreen extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  BillCategoryListScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() => _BillCategoryListScreen();
}

class _BillCategoryListScreen extends State<BillCategoryListScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
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
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Divider(
                  color: Colors.transparent,
                  height: 12,
                ),
              ),
              itemBuilder: (context, index) {
                return _BillCategoryListItem(items![index], index, (item, selectedIndex) {
                  Navigator.of(context).pushNamed(BillScreen.BILL_BILLER_SCREEN, arguments: item);
                });
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewModel = Provider.of<BillCategoryViewModel>(context, listen: false);
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
                  stream: viewModel.getCategories(),
                  builder: (BuildContext context, AsyncSnapshot<Resource<List<BillerCategory>?>> a) {
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

class _BillCategoryListItem extends Container {

  final BillerCategory _billCategory;
  final int position;
  final OnItemClickListener<BillerCategory, int>? _onItemClickListener;

  _BillCategoryListItem(this._billCategory, this.position, this._onItemClickListener);

  Widget initialView(String? svg) {
    return Container(
      width: 34,
      height: 34,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.primaryColor.withOpacity(0.1)
      ),
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
            onTap: () => _onItemClickListener?.call(_billCategory, position),
            child: Container(
              padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  initialView(_billCategory.svgImage),
                  SizedBox(width: 16),
                  Expanded(
                      child: Text(
                          _billCategory.name ?? "",
                          style: TextStyle(fontSize: 16, color: Colors.colorPrimaryDark, fontWeight: FontWeight.bold)
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
