import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/savings/model/data/savings_product.dart';
import 'package:moniepoint_flutter/app/savings/viewmodels/savings_dashboard_viewmodel.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/icon_curved_container.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:shimmer/shimmer.dart';

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

  @override
  void initState() {
    itemSource = widget._viewModel.getFlexProduct();
    super.initState();
  }

  void _onItemClick() {
    switch(widget.productType) {
      case SavingsProductType.FLEX:
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
      child: StreamBuilder(
        stream: itemSource,
        builder: (ctx, AsyncSnapshot<Resource<SavingsProduct>> snap) {

          if(!snap.hasData || (snap.data is Loading && snap.data?.data == null)) {
            return _SavingsProductShimmer();
          }

          final product = snap.data!.data!;

          return Column(
            children: [
              IconCurvedContainer(
                  backgroundColor: Colors.savingsPrimary.withOpacity(0.08),
                  image: SvgPicture.asset("res/drawables/ic_savings_flex.svg")
              ),
              SizedBox(height: 8),
              Text(
                product.name ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.textColorBlack
                ),
              ),
              SizedBox(height: 3),
              Text(
                product.shortDescription ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    color: Colors.dividerColor2
                ),
              ),
              SizedBox(height: 7),
              Divider(height: 0.8, color: Color(0XFF752E96).withOpacity(0.12)),
              SizedBox(height: 8),
              Text(
                "${product.interestRate}% p.a",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.textColorBlack
                ),
              ).colorText({"p.a" : Tuple(Colors.greyTextColor, null)}, underline: false),
              SizedBox(height: 14),
              Styles.appButton(
                  buttonStyle: _buttonStyle(),
                  onClick: _onItemClick,
                  text: "Get Started"
              )
            ],
          );
        },
      ),
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
    return Column(
      children: [
        Shimmer.fromColors(
            child: IconCurvedContainer(
                backgroundColor: Colors.grey.withOpacity(0.3),
                image: SvgPicture.asset("res/drawables/ic_savings_flex.svg", color: Colors.savingsPrimary.withOpacity(0.002),)
            ),
            baseColor: Color(0XFFE3E8EB).withOpacity(0.5),
            highlightColor: Colors.grey.withOpacity(0.3)
        ),
        SizedBox(height: 8),
        Shimmer.fromColors(
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
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
    );
  }

}