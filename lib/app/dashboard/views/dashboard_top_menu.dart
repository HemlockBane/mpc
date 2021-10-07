import 'dart:convert';

import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_icons2_icons.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'custom_refresh_indicator/custom_refresh_indicator.dart';



const double dashboardTopMenuHeight = 50;

class DashboardTopMenu extends StatefulWidget {
  final DashboardViewModel viewModel;
  final title;

  DashboardTopMenu({
    required this.viewModel,
    required this.title,
  }) : super(key: Key("_DashboardTopMenu"));

  @override
  State<StatefulWidget> createState() => _DashboardTopMenuState();

}

class _DashboardTopMenuState extends State<DashboardTopMenu> {

  late final Stream<Resource<FileResult>> _profilePictureStream;

  @override
  initState() {
    _profilePictureStream = widget.viewModel.getProfilePicture();
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
        border: Border.all(color: Colors.white.withOpacity(0.4))),
    child: Icon(
      CustomIcons2.username,
      color: Colors.white.withOpacity(0.8),
      size: 21,
    ),
  );


  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(
        top: 15,
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
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.textColorBlack),
              ),
              Container(width: 40)
            ],
          ),
        ],
      ),
    );
  }
}
