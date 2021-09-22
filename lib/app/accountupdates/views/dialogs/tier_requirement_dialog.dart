// import 'dart:async';
// import 'dart:math';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart' hide Colors;
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:moniepoint_flutter/app/accounts/model/data/account_update_flag.dart';
// import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
// import 'package:moniepoint_flutter/app/accountupdates/views/colored_linear_progress_bar.dart';
// import 'package:moniepoint_flutter/app/accountupdates/views/tier_requirement_item.dart';
// import 'package:moniepoint_flutter/core/bottom_sheet_state.dart';
// import 'package:moniepoint_flutter/core/colors.dart';
// import 'package:collection/collection.dart';
// import 'package:moniepoint_flutter/core/tuple.dart';
// import 'package:moniepoint_flutter/core/views/dots_indicator.dart';
//
// import '../account_progress_view.dart';
//
// class TierRequirementDialog extends StatefulWidget {
//
//   final List<Tier> tiers;
//   final double progress;
//   final Tuple<double, BottomSheetState> state;
//
//   TierRequirementDialog(this.tiers, this.progress, this.state);
//
//   @override
//   State<StatefulWidget> createState() => _TierRequirementDialog();
//
// }
//
// class _TierRequirementDialog extends State<TierRequirementDialog> with SingleTickerProviderStateMixin {
//
//   late final AnimationController  _controller = AnimationController(
//       vsync: this, duration: Duration(milliseconds: 1500)
//   );
//
//   late PageView _pageView;
//   final _pageController = PageController();
//   final pageChangeDuration = const Duration(milliseconds: 250);
//   final pageCurve = Curves.linear;
//   List<TierRequirementItem> _pages = [];
//
//   Timer? _testTimer;
//
//   double _pageHeight = 400;
//   // double _progress = 0;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Widget makePageView() {
//     _pages = widget.tiers.mapIndexed((index, element) => TierRequirementItem(element, index)).toList();
//
//     this._pageView = PageView.builder(
//         itemCount: _pages.length,
//         controller: _pageController,
//         onPageChanged: (index) {
//           if(index == 0) _pageHeight = 400;
//           if(index == 1) _pageHeight = 485;
//           if(index == 2) _pageHeight = 625;
//           setState(() {});
//         },
//         itemBuilder: (BuildContext context, int index) {
//           return _pages[index % _pages.length];
//         }
//     );
//     return _pageView;
//   }
//
//
//   Widget _buildProgressBar() {
//     return Padding(
//       padding: EdgeInsets.only(left: 16, right: 16),
//       child: AccountProgressView(widget.progress, widget.tiers),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: _pageHeight,
//       padding: EdgeInsets.only(top: 16, bottom: 16),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20), topRight: Radius.circular(20)
//           ),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.grey.withOpacity(0.05),
//                 offset: Offset(0, -1),
//                 blurRadius: 4
//             )
//           ]),
//       child: Column(
//         children: [
//           RotationTransition(
//             turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
//             child: SvgPicture.asset('res/drawables/ic_drop_down.svg', width: 14, height: 10,),
//           ),
//           SizedBox(height: 16,),
//           _buildProgressBar(),
//           SizedBox(height: 24,),
//           Divider(color: Color(0XFFBFD7E5).withOpacity(0.6),),
//           Flexible(fit:FlexFit.tight,child: makePageView()),
//           DotIndicator(controller: _pageController, itemCount: _pages.length),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _testTimer?.cancel();
//     super.dispose();
//   }
// }