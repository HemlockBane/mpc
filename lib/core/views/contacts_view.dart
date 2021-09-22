import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/paging/page_config.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/contacts_view_model.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';

import '../colors.dart';
import '../styles.dart';

class ContactScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ContactScreen();

}

class _ContactScreen extends State<ContactScreen> {

  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  PagingSource<int, Contact> _pagingSource = PagingSource.empty();
  ContactsViewModel? _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<ContactsViewModel>(context, listen: false);
    _pagingSource = _viewModel?.getContacts() ?? _pagingSource;
    super.initState();
  }

  void _onContactSearch(String value) {
    setState(() {
      _pagingSource = (value.isEmpty)
          ? _viewModel?.getContacts() ?? _pagingSource
          : _viewModel?.searchContacts(value) ?? _pagingSource;
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<ContactsViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.backgroundWhite,
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: -12,
          iconTheme: IconThemeData(color: Colors.primaryColor),
          title: Text('Contacts',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.darkBlue,
                  fontFamily: Styles.defaultFont,
                  fontSize: 17
              )
          ),
          backgroundColor: Colors.backgroundWhite,
          elevation: 0
      ),
      body: Column(
        children: [
          SizedBox(height: 8,),
          Expanded(
              flex: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Styles.appEditText(
                    controller: _searchController,
                    borderColor: Colors.darkBlue.withOpacity(0.2),
                    focusedBorderColor: Colors.darkBlue.withOpacity(0.2),
                    hint: 'Search',
                    startIcon: Icon(CustomFont.search, color: Colors.darkBlue.withOpacity(0.3),),
                    onChanged: _onContactSearch
                ),
              )
          ),
          SizedBox(height: 8,),
          Expanded(
              child: Pager<int, Contact>(
                  source: _pagingSource,
                  pagingConfig: PagingConfig(pageSize: 800, initialPageSize: 800),
                  builder: (context, value, _) {
                    return ListView.separated(
                        controller: _scrollController,
                        itemCount: value.data.length,
                        separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Divider(color: Color(0XFFE0E0E0), height: 1,),
                        ),
                        itemBuilder: (context, index) {
                          return _ContactListItem(value.data[index], index, (beneficiary, int i) {
                            Navigator.of(context).pop(beneficiary);
                          });
                        });
                  }
              )
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

}

class _ContactListItem extends Container{

  final Contact _contact;
  final int position;
  final OnItemClickListener<Contact, int>? _onItemClickListener;

  _ContactListItem(this._contact, this.position, this._onItemClickListener);

  Widget initialView() {
    return Container(
      width: 38,
      height: 38,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.darkBlue.withOpacity(0.1)
      ),
      child: Center(
        child: Text(
            _contact.displayName?.abbreviate(2, true) ?? _contact.middleName?.abbreviate(2, true) ?? "",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.darkBlue, fontSize: 13)
        ),
      ),
    );
  }

  Item? contactNumber() {
    Iterable<Item>? phones = _contact.phones;
    return (phones?.isNotEmpty == true) ? phones?.first : Item(label: "", value: "");
  }

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () => _onItemClickListener?.call(_contact, position),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
        child: Row(
          children: [
            initialView(),
            SizedBox(width: 16),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          _contact.displayName ?? "",
                          style: TextStyle(fontSize: 16, color: Colors.darkBlue, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(height: 2),
                      Text(
                          contactNumber()?.value ?? "",
                          style: TextStyle(fontSize: 12, color: Colors.deepGrey, fontWeight: FontWeight.normal, fontFamily: Styles.defaultFont)
                      )
                    ]
                )),
            SvgPicture.asset('res/drawables/ic_forward_anchor.svg', width: 13.5, height: 13.5, color: Colors.darkBlue.withOpacity(0.3),),
            SizedBox(width: 2),
          ],
        ),
      ),
    ),
  );
}