import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_icons2_icons.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

const double dashboardTopMenuHeight = 60;

class DashboardTopMenu extends StatefulWidget implements PreferredSizeWidget {

  final DashboardViewModel viewModel;
  final List<String> titles;
  final ValueNotifier<int> menuChangeNotifier;
  final ScrollController? scrollController;

  DashboardTopMenu({
    required this.viewModel,
    required this.titles,
    required this.menuChangeNotifier,
    this.scrollController
  }) : super(key: Key("_DashboardTopMenu"));

  @override
  State<StatefulWidget> createState() => _DashboardTopMenuState();

  @override
  Size get preferredSize => Size(double.infinity, dashboardTopMenuHeight);

}

class _DashboardTopMenuState extends State<DashboardTopMenu> with TickerProviderStateMixin {

  late final Stream<Resource<FileResult>> _profilePictureStream;
  late final AnimationController _animController = AnimationController(vsync: this);
  final ValueNotifier<double> _scrollOffsetListener = ValueNotifier(0.0);

  @override
  initState() {
    _profilePictureStream = widget.viewModel.getProfilePicture();
    widget.scrollController?.addListener(() {
      _scrollOffsetListener.value = widget.scrollController?.offset ?? 0;
    });
    widget.menuChangeNotifier.addListener(() {
      if(widget.menuChangeNotifier.value > 0) {
        _scrollOffsetListener.value = 0;
      } else {
        _scrollOffsetListener.value = widget.scrollController?.offset ?? 0;
      }
    });
    super.initState();
  }

  ///Container that holds the user image loaded from remote service
  _userProfileImage(String base64String) => Container(
      height: 38,
      width: 38,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.primaryColor.withOpacity(0.13),
          width: 3,
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(
            base64Decode(base64String),
          ),
        ),
      ));

  _userProfilePlaceholder() => Container(
    height: 34,
    width: 34,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.withOpacity(0.2),
        border: Border.all(color: Colors.white.withOpacity(0.4))
    ),
    child: Icon(
      CustomIcons2.username,
      color: Colors.white.withOpacity(0.8),
      size: 21,
    ),
  );

  Widget  get child =>  Container(
    padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 16,
        right: 16
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder(
                stream: _profilePictureStream,
                builder: (ctx, AsyncSnapshot<Resource<FileResult>> snapShot) {
                  if (snapShot.hasData && (snapShot.data is Success || snapShot.data is Loading)) {
                    final data = snapShot.data?.data;
                    if (data?.base64String?.isNotEmpty == true) {
                      return _userProfileImage(data!.base64String!);
                    }
                  }

                  final localViewCachedImage = widget.viewModel.userProfileBase64String;
                  if (localViewCachedImage != null
                      && localViewCachedImage.isNotEmpty == true) {
                    return _userProfileImage(widget.viewModel.userProfileBase64String!);
                  }

                  return _userProfilePlaceholder();
                }),
            ValueListenableBuilder(
                valueListenable: widget.menuChangeNotifier,
                builder: (ctx, value, _) {
                  return Text(
                    widget.titles[widget.menuChangeNotifier.value],
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.textColorBlack),
                  );
                }
            ),
            Container(width: 40)
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
        valueListenable: _scrollOffsetListener,
        child: child,
        builder: (_, offset, child) {
          return TweenAnimationBuilder<double>(
              child: child,
              tween: Tween<double>(begin: 0.0, end: offset),
              duration: Duration(milliseconds: 500),
              builder: (__, value, child) {
                final appBarColorTween = ColorTween(
                    begin: Color(0XFFEBF2FA),
                    end: Colors.transparent
                ).evaluate(AlwaysStoppedAnimation(min(40, 40 - min(40, (value - 1) * 0.5))/40));
                return Container(
                  color: appBarColorTween,
                  child: child,
                );
              }
          );
        }
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
}
