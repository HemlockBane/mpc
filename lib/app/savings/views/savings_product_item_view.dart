import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/savings/model/data/savings_product.dart';
import 'package:moniepoint_flutter/app/savings/viewmodels/savings_dashboard_viewmodel.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/icon_curved_container.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:moniepoint_flutter/main.dart';
import 'package:shimmer/shimmer.dart';

import 'savings_dasboard_view.dart';

enum SavingsProductType {
  FLEX,
  TARGET,
  SAFE_LOCK,
  GROUP
}

class SavingsProductItemView extends StatefulWidget  {

  SavingsProductItemView({
    required this.productType,
    required SavingsDashboardViewModel viewModel
  }) : this._viewModel = viewModel;

  final SavingsProductType productType;
  final SavingsDashboardViewModel _viewModel;

  @override
  State<StatefulWidget> createState() => _SavingsProductItemState();

}

class _SavingsProductItemState extends State<SavingsProductItemView> {

  late final Stream<Resource<SavingsProduct>> itemSource;

  SavingsProduct? savingsProduct;

  @override
  void initState() {
    print("Rebuilding Each Item");
    itemSource = widget._viewModel.getRunningFlexSavings();
    super.initState();
  }

  void _onItemClick() {
    switch(widget.productType) {
      case SavingsProductType.FLEX:
        if(savingsProduct != null) {
          navigatorKey.currentState?.pushNamed(
              Routes.SAVINGS_FLEX_ENABLE,
              arguments: {"product": this.savingsProduct}
          );
        }
        break;
      case SavingsProductType.TARGET:
        break;
      case SavingsProductType.SAFE_LOCK:
        break;
      case SavingsProductType.GROUP:
        break;
    }
  }

  ButtonStyle _buttonStyle() {
    switch (widget.productType) {
      case SavingsProductType.FLEX:
        return Styles.savingsFlexButtonStyle;
      case SavingsProductType.TARGET:
        return Styles.targetSavingsButtonStyle;
      case SavingsProductType.SAFE_LOCK:
        return Styles.savingsSafeLockButtonStyle;
      case SavingsProductType.GROUP:
        return Styles.groupSavingsButtonStyle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: itemSource,
      builder: (ctx, AsyncSnapshot<Resource<SavingsProduct>> snap) {

        if(!snap.hasData || (snap.data is Loading && snap.data?.data == null)) {
          return _SavingsProductShimmer();
        }

        if(snap.data is Loading && (snap.data?.data?.flexSavings == null
            || snap.data?.data?.flexSavings?.isEmpty == true)){
          return _SavingsProductShimmer();
        }

        if(snap.data is Error<SavingsProduct>) {
          return Text("Error Loading", style: TextStyle(fontSize: 16, color: Colors.black),);
        }

        final product = snap.data?.data;

        this.savingsProduct = product;

        if(product != null && product.flexSavings != null && product.flexSavings?.isNotEmpty == true) {
          return SavingsProductItemActiveView(
            product: product,
            productType: widget.productType,
          );
        }

        return Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 10),
            decoration: BoxDecoration(
                color: Colors.backgroundWhite,
                border: Border.all(color: Color(0XFFB1881E).withOpacity(0.1), width: 0.7),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Color(0XFF165B1D).withOpacity(0.14),
                      offset: Offset(0, 1),
                      blurRadius: 2
                  )
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconCurvedContainer(
                    backgroundColor: Colors.savingsPrimary.withOpacity(0.1),
                    child: SvgPicture.asset("res/drawables/ic_savings_flex_2.svg", width: 24, height: 30,)
                ),
                SizedBox(height: 8),
                Text(
                  product?.name ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  product?.shortDescription ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.dividerColor2
                  ),
                ),
                SizedBox(height: 9),
                Divider(height: 0.8, color: Color(0XFF752E96).withOpacity(0.12)),
                SizedBox(height: 8),
                Text(
                  "${product?.flexSavingScheme?.interestRate}% p.a",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.textColorBlack
                  ),
                ).colorText({"p.a" : Tuple(Colors.greyTextColor.withOpacity(0.5), null)}, underline: false),
                SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: Styles.appButton(
                      elevation: 0.4,
                      padding: 14,
                      buttonStyle: _buttonStyle().copyWith(
                          padding: MaterialStateProperty.all(EdgeInsets.only(top: 9, bottom: 9)),
                          textStyle: MaterialStateProperty.all(TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13
                          ))
                      ),
                      onClick: _onItemClick,
                      text: "Get Started"
                  ),
                )
              ],
            )
        );
      },
    );

  }

}


///SavingsProductItemActiveView
///
///
///
class SavingsProductItemActiveView extends StatelessWidget {

  SavingsProductItemActiveView({
    required this.productType,
    required this.product
  });

  final SavingsProduct? product;
  final SavingsProductType productType;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.savingsPrimary,
            border: Border.all(color: Color(0XFFB1881E).withOpacity(0.1), width: 0.7),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Color(0XFF165B1D).withOpacity(0.14),
                  offset: Offset(0, 1),
                  blurRadius: 2
              )
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconCurvedContainer(
                backgroundColor: Colors.white.withOpacity(1),
                child: SvgPicture.asset("res/drawables/ic_savings_flex_2.svg", width: 24, height: 30,)
            ),
            SizedBox(height: 8),
            Text(
              product?.name ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.white
              ),
            ),
            SizedBox(height: 3),
            Text(
              product?.shortDescription ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.white
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.28),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text(
                    "${product?.flexSavings?.length}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Text(
                    "Active Savings",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                  ),
                )
              ],
            ),
            SizedBox(height: 14),
            Divider(height: 0.9, color: Color(0XFFFFFFFF).withOpacity(0.3)),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(40, 0)),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: MaterialStateProperty.all(
                          EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 10)
                      )
                  ),
                  onPressed: () => Navigator.of(context).pushNamed(SavingsDashboardView.FLEX_SAVINGS),
                  child: Text(
                    "View",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700
                    )
                  )
              ),
            )
          ],
        )
    );
  }

}




///_SavingsProductShimmer
///
///
///
class _SavingsProductShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 15),
        decoration: BoxDecoration(
            color: Colors.backgroundWhite,
            border: Border.all(color: Color(0XFFB1881E).withOpacity(0.1), width: 0.7),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Color(0XFF165B1D).withOpacity(0.14),
                  offset: Offset(0, 1),
                  blurRadius: 2
              )
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
                child: IconCurvedContainer(
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    child: SvgPicture.asset("res/drawables/ic_savings_flex.svg", color: Colors.savingsPrimary.withOpacity(0.002),)
                ),
                baseColor: Color(0XFFE3E8EB).withOpacity(0.5),
                highlightColor: Colors.grey.withOpacity(0.3)
            ),
            SizedBox(height: 8),
            Shimmer.fromColors(
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                  decoration: BoxDecoration(
                    color: Color(0XFFE3E8EB).withOpacity(0.5),
                  ),
                ),
                baseColor: Color(0XFFE3E8EB).withOpacity(0.5),
                highlightColor: Colors.grey.withOpacity(0.3)
            ),
            SizedBox(height: 3),
            Shimmer.fromColors(
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.dividerColor2.withOpacity(0.5),
                  ),
                ),
                baseColor: Color(0XFFE3E8EB).withOpacity(0.5),
                highlightColor: Colors.grey.withOpacity(0.3)
            ),
            SizedBox(height: 0.5),
            Shimmer.fromColors(
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.dividerColor2.withOpacity(0.5),
                  ),
                ),
                baseColor: Color(0XFFE3E8EB).withOpacity(0.5),
                highlightColor: Colors.grey.withOpacity(0.3)
            ),
            SizedBox(height: 7),
            Divider(height: 0.8, color: Color(0XFF752E96).withOpacity(0.12)),
            SizedBox(height: 8),
            Shimmer.fromColors(
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.dividerColor2.withOpacity(0.5),
                  ),
                ),
                baseColor: Color(0XFFE3E8EB).withOpacity(0.5),
                highlightColor: Colors.grey.withOpacity(0.3)
            ),
            SizedBox(height: 14),
            Shimmer.fromColors(
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.dividerColor2.withOpacity(0.5),
                  ),
                ),
                baseColor: Color(0XFFE3E8EB).withOpacity(0.5),
                highlightColor: Colors.grey.withOpacity(0.3)
            ),
          ],
        ),
    );
  }

}