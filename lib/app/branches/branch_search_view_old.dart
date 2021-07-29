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

class BranchSearchScreenOld extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BranchSearchScreen();
}

class _BranchSearchScreen extends State<BranchSearchScreenOld> {
  TextEditingController _searchController = TextEditingController();
  Timer? debouncer;
  bool _isLoading = false;

  void _onSearchFieldChange(BranchViewModel viewModel, String text) {
    if (text.isEmpty) {
      _searchController.text = "";
    }
    if (text.isNotEmpty && text.length <= 2) return;
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
          SvgPicture.asset(
            'res/drawables/ic_branch_info.svg',
            width: 48,
            height: 48,
            color: Colors.colorFaded,
          ),
          SizedBox(
            height: 16,
          ),
          Flexible(
              child: Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Text('Enter a moniepoint branch name to search.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BranchViewModel>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.backgroundWhite,
      body: Container(
        padding: EdgeInsets.only(top: 38),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
                child: Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              // padding: EdgeInsets.only(top: 19, bottom: 19),
              child: TextFormField(
                  controller: _searchController,
                  onChanged: (v) => _onSearchFieldChange(viewModel, v),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      hintText: "Search by branch name",
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
                            color: Colors.colorFaded,
                          ),
                        ),
                      ),
                      suffixIcon: _isLoading
                          ? Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: SizedBox(
                                height: 10,
                                width: 10,
                                child: SpinKitThreeBounce(
                                    size: 20.0,
                                    color:
                                        Colors.primaryColor.withOpacity(0.8)),
                              ),
                            )
                          : null,
                      isCollapsed: true,
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)))),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 2)
                  ]),
            )),
            SizedBox(height: 20),
            Expanded(
              flex: 0,
              child:
                  Divider(color: Colors.colorFaded.withOpacity(0.5), height: 1),
            ),
            SizedBox(height: 12),
            Expanded(
              child: StreamBuilder(
                  stream: viewModel.searchResultStream,
                  builder:
                      (context, AsyncSnapshot<Resource<List<BranchInfo>>> a) {
                    if (!a.hasData) return Container();
                    if ((a.hasData && a.data is Success) &&
                        a.data?.data?.isEmpty == true) {
                      return _emptyView();
                    }

                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: a.data?.data?.length ?? 0,
                      separatorBuilder: (context, index) => Column(
                        children: [
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                      itemBuilder: (context, index) {
                        return _BranchListItem(a.data!.data![index], index,
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
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _BranchListItem extends Container {
  final BranchInfo _branchInfo;
  final int position;
  final OnItemClickListener<BranchInfo, int> _onItemClickListener;

  _BranchListItem(this._branchInfo, this.position, this._onItemClickListener);

  Widget initialContainer() {
    return Container(
      height: 42,
      width: 42,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.primaryColor.withOpacity(0.1)),
      child: SvgPicture.asset('res/drawables/ic_location.svg'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(9))),
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: () => _onItemClickListener.call(_branchInfo, 0),
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 12, right: 12),
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
                    fontSize: 16,
                    color: Colors.textColorBlack,
                  ),
                )),
                SvgPicture.asset('res/drawables/ic_branch_link.svg'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
