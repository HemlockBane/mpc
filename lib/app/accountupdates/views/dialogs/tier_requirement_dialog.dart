import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/tier_requirement_item.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/views/dots_indicator.dart';

class TierRequirementDialog extends StatefulWidget {
  
  final List<Tier> tiers;
  
  TierRequirementDialog(this.tiers);

  @override
  State<StatefulWidget> createState() => _TierRequirementDialog();

}

class _TierRequirementDialog extends State<TierRequirementDialog> with SingleTickerProviderStateMixin {

  late final AnimationController  _controller = AnimationController(
      vsync: this, duration: Duration(milliseconds: 1500)
  );

  late PageView _pageView;
  final _pageController = PageController();
  final pageChangeDuration = const Duration(milliseconds: 250);
  final pageCurve = Curves.linear;
  List<TierRequirementItem> _pages = [];

  double _pageHeight = 300;
  
  @override
  void initState() {
    super.initState();
  }
  
  Widget makePageView() {
    _pages = widget.tiers.mapIndexed((index, element) => TierRequirementItem(element, index)).toList();

    this._pageView = PageView.builder(
        itemCount: _pages.length,
        controller: _pageController,
        onPageChanged: (index) {
          if(index == 0) _pageHeight = 300;
          if(index == 1) _pageHeight = 360;
          if(index == 2) _pageHeight = 530;
          setState(() {});
        },
        itemBuilder: (BuildContext context, int index) {
          return _pages[index % _pages.length];
        }
    );
    return _pageView;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _pageHeight,
      padding: EdgeInsets.only(top: 16, bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                offset: Offset(0, -1),
                blurRadius: 4
            )
          ]),
      child: Column(
        children: [
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: SvgPicture.asset('res/drawables/ic_drop_down.svg', width: 16, height: 12,),
          ),
          SizedBox(height: 24,),
          Divider(color: Color(0XFFBFD7E5).withOpacity(0.6),),
          Flexible(fit:FlexFit.tight,child: makePageView()),
          DotIndicator(controller: _pageController, itemCount: _pages.length),
        ],
      ),
    );
  }
}