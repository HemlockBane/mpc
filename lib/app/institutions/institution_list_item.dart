import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/customer/account_provider.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/custom_check_box.dart';

class InstitutionListItem extends StatefulWidget {

  final AccountProvider _provider;
  final int position;
  final OnItemClickListener<AccountProvider, int>? _onItemClickListener;
  final Key key;

  InstitutionListItem(
      this.key,
      this._provider,
      this.position,
      this._onItemClickListener): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InstitutionItem();
  }

}

class _InstitutionItem extends State<InstitutionListItem> {

  @override
  void initState() {
    super.initState();
  }

  void _onSelected() {
    widget._onItemClickListener?.call(widget._provider, widget.position);
  }

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: _onSelected,
      child: Container(
        padding: EdgeInsets.only(left: 24, right: 16, top: 4, bottom: 4),
        child: Row(
          children: [
            Expanded(
                child: Text(
                    widget._provider.name ?? "",
                    style: TextStyle(fontSize: 15, color: (widget._provider.isSelected == true)
                        ? Colors.primaryColor
                        : Colors.dividerColor2,
                      fontFamily: Styles.defaultFont,
                      fontWeight: FontWeight.normal
                    ))
            ),
            SizedBox(width: 8),
            CustomCheckBox(CustomFont.question_mark, 'label',  onSelect: (bool a) {
              _onSelected();
            }, isSelected: widget._provider.isSelected == true),
            SizedBox(width: 8),
          ],
        ),
      ),
    ),
  );
}