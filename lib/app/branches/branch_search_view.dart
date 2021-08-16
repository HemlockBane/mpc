import 'dart:async';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/branches/model/data/branch_info.dart';
import 'package:moniepoint_flutter/app/branches/viewmodels/branch_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:provider/provider.dart';

class BranchSearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BranchSearchScreen();
}

class _BranchSearchScreen extends State<BranchSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  Timer? debouncer;
  bool _isLoading = false;

  void _onSearchFieldChange(BranchViewModel viewModel, String text) {
    if (text.isEmpty) {
      _searchController.text = "";
      setState(() {});
      return;
    }
    if (text.isNotEmpty && text.length <= 2) {
      setState(() {});
      return;
    }

    debouncer?.cancel();
    debouncer = Timer(Duration(milliseconds: 700), () {
      viewModel.search(text);
    });
  }

  initState() {
    super.initState();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<BranchViewModel>(context, listen: true);
    viewModel.searchResultStream.listen((event) {
      _isLoading = event is Loading;
      setState(() {});
    });
  }

  Widget _emptyView() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
          ),
          Container(
            height: 159,
            width: 159,
            decoration: BoxDecoration(
              color: Color(0xFFE94444).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'res/drawables/ic_branch_no_location.svg',
                width: 47.83,
                height: 61.5,
                // color: Colors.colorFaded,
              ),
            ),
          ),
          SizedBox(height: 16),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  Text(
                    'Location not found',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.textColorBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    child: Text(
                      "You can try searching for something else or head back to the home page",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.textColorBlack,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BranchViewModel>(context, listen: true);
    final minHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.backgroundWhite,
      body: SingleChildScrollView(
        child: Container(
          height: minHeight,
          padding: EdgeInsets.only(top: 38),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  // padding: EdgeInsets.only(top: 19, bottom: 19),
                  child: TextFormField(
                      controller: _searchController,
                      onChanged: (v) => _onSearchFieldChange(viewModel, v),
                      textAlignVertical: TextAlignVertical.center,
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: "Search by branch name",
                          hintStyle: TextStyle(
                              color: Color(0xFF4A4A4A).withOpacity(0.2934)),
                          contentPadding: EdgeInsets.only(top: 19, bottom: 19),
                          prefixIcon: GestureDetector(
                            onTap: () {
                              if (_searchController.text.isNotEmpty)
                                _onSearchFieldChange(viewModel, "");
                              else
                                Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 12, right: 16, bottom: 12, left: 16),
                              child: Icon(
                                CustomFont.backArrow,
                                size: 20,
                                color: Color(0xFF9DA1AB),
                              ),
                            ),
                          ),
                          suffixIcon:
                              _isLoading && _searchController.text.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.only(right: 16),
                                      child: SizedBox(
                                        height: 10,
                                        width: 10,
                                        child: SpinKitThreeBounce(
                                            size: 20.0,
                                            color: Colors.primaryColor
                                                .withOpacity(0.8)),
                                      ),
                                    )
                                  : null,
                          isCollapsed: true,
                          disabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)))),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          spreadRadius: 2,
                        )
                      ]),
                ),
              ),
              SizedBox(height: 50),
              StreamBuilder(
                  stream: viewModel.searchResultStream,
                  builder:
                      (context, AsyncSnapshot<Resource<List<BranchInfo>>> a) {
                    if (_searchController.text == "" || _searchController.text.length <= 2 || _isLoading)
                      return Container();

                    if (!a.hasData ||
                        (a.hasData && a.data is Success) &&
                            a.data?.data?.isEmpty == true) {
                      return Container();
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 22),
                          child: Text(
                            "SEARCH RESULTS",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.textColorBlack,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    );
                  }),
              SizedBox(height: 5),
              Expanded(
                child: StreamBuilder(
                    stream: viewModel.searchResultStream,
                    builder:
                        (context, AsyncSnapshot<Resource<List<BranchInfo>>> a) {
                      if (_searchController.text.isEmpty || _searchController.text.length <= 2 || _isLoading) return Container();

                      if (!a.hasData ||
                          (a.hasData && a.data is Success) &&
                              a.data?.data?.isEmpty == true) {
                        return _emptyView();
                      }


                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: a.data?.data?.length ?? 0,
                        separatorBuilder: (context, index) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              // SizedBox(height: 15),
                              Divider(height: 1),
                            ],
                          ),
                        ),
                        itemBuilder: (context, index) {
                          return BranchListItem(a.data!.data![index], index,
                              (item, itemIndex) {
                            Future.delayed(Duration(milliseconds: 180), () {
                              Navigator.of(context).pop(item);
                            });
                          });
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class BranchListItem extends Container {
  final BranchInfo _branchInfo;
  final int position;
  final OnItemClickListener<BranchInfo, int> _onItemClickListener;

  BranchListItem(this._branchInfo, this.position, this._onItemClickListener);

  Widget initialContainer() {
    return Container(
      height: 42,
      width: 42,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Color(0xFF9DA1AB).withOpacity(0.1)),
      child: Center(
        child: SvgPicture.asset(
          'res/drawables/ic_location_2.svg',
          height: 20,
          width: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: () => _onItemClickListener.call(_branchInfo, 0),
        onDoubleTap: (){},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              initialContainer(),
              SizedBox(width: 20),
              Expanded(
                  child: Text(
                _branchInfo.name ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.textColorBlack,
                ),
              )),
              SvgPicture.asset('res/drawables/ic_branch_link_2.svg'),
            ],
          ),
        ),
      ),
    );
  }
}
