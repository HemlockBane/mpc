import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart' hide Colors, Page;
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class ContactListDialog extends StatefulWidget {

  final String contactName;
  final List<Item> phoneNumbers;

  ContactListDialog(this.contactName, this.phoneNumbers);

  @override
  State<StatefulWidget> createState() => _ContactListDialog();

}

class _ContactListDialog extends State<ContactListDialog> {
  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet(
        height: 500,
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_airtime_dialog.svg',
        centerImageColor: Colors.primaryColor,
        centerImageHeight: 30,
        centerImageWidth: 30,
        centerBackgroundHeight: 80,
        centerBackgroundWidth: 80,
        centerBackgroundPadding: 20,
        content: Container(
          child: Column(
            children: [
              SizedBox(height: 24),
              Center(
                child: Text(widget.contactName,
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: Colors.solidDarkBlue
                    )),
              ),
              SizedBox(height: 4,),
              Flexible(
                  flex: 0,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                      child: Text(
                        "Select one of ${widget.contactName}'s phone number to proceed.",
                        style: TextStyle(color: Colors.deepGrey, fontSize: 13),
                      ),
                  )
              ),
              SizedBox(height: 24),
              Expanded(
                  child: ListView.separated(
                    itemCount: widget.phoneNumbers.length,
                    separatorBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Divider(color: Color(0XFFE0E0E0), height: 1,),
                    ),
                    itemBuilder: (context, index) {
                      return _ContactNumberListItem(widget.phoneNumbers[index], (item, i) {
                        Navigator.of(context).pop(item);
                      });
                    },
                  )
              ),
            ],
          ),
        )
    );
  }
}

class _ContactNumberListItem extends Container{

  final Item mobileNumber;
  final OnItemClickListener<Item, int> _onItemClickListener;

  _ContactNumberListItem(this.mobileNumber, this._onItemClickListener);

    @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemClickListener.call(mobileNumber, 0),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      mobileNumber.label ?? "",
                      style: TextStyle(color: Colors.grey.withOpacity(0.5),fontSize: 14, fontWeight: FontWeight.w600)
                  ),
                  Text(
                      mobileNumber.value ?? "",
                      style: TextStyle(color: Colors.darkBlue,fontSize: 18, fontWeight: FontWeight.w600)
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}