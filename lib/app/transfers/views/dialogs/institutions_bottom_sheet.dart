import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/customer/account_provider.dart';
import 'package:moniepoint_flutter/app/institutions/institution_list_item.dart';
import 'package:moniepoint_flutter/app/institutions/institution_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:provider/provider.dart';

class InstitutionDialog extends StatefulWidget {

  final String accountNumber;

  InstitutionDialog(this.accountNumber);

  @override
  State<StatefulWidget> createState() => _InstitutionDialog();
}

class _InstitutionDialog extends State<InstitutionDialog> with SingleTickerProviderStateMixin {

  AccountProvider? _selectedAccountProvider;
  Stream<Resource<List<AccountProvider>>>? institutionsStream;
  AnimationController? _animationController;
  final List<AccountProvider> _currentList = [];

  _InstitutionDialog() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600)
    );
  }

  Widget makeListView(BuildContext context, AsyncSnapshot<Resource<List<AccountProvider>?>> a) {
    final viewModel = Provider.of<InstitutionViewModel>(context, listen: false);

    return ListViewUtil.makeListViewWithState(
        context: context,
        snapshot: a,
        animationController: _animationController!,
        currentList: _currentList,
        listView: (List<AccountProvider>? items) {
          final sortedItems = viewModel.sortAndRankWithAccountNumber(items??[], widget.accountNumber).take(5).toList();
          return ListView.separated(
              shrinkWrap: true,
              itemCount: sortedItems.length,
              separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Divider(color: Color(0XFFE0E0E0)),
                  ),
              itemBuilder: (context, index) {
                return InstitutionListItem(
                    Key(index.toString()),
                    sortedItems[index],
                    index, (a, int i) {
                      setState(() {
                        _selectedAccountProvider?.isSelected = false;
                        _selectedAccountProvider = sortedItems[i];
                        _selectedAccountProvider?.isSelected = true;
                      });
                    });
              });
        });
  }

  @override
  void initState() {
    final viewModel = Provider.of<InstitutionViewModel>(context, listen: false);
    institutionsStream = viewModel.getInstitutions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BottomSheets.makeAppBottomSheet(
        height: 700,
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_bank.svg',
        centerImageColor: Colors.primaryColor,
        content: Container(
          child: Column(
            children: [
              SizedBox(height: 12),
              Center(
                child: Text('Select Bank',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.solidDarkBlue)),
              ),
              SizedBox(height: 24),
              Expanded(
                  child: StreamBuilder(
                      stream: institutionsStream,
                      builder: (context, AsyncSnapshot<Resource<List<AccountProvider>?>> a) {
                        return makeListView(context, a);
                      })),
              SizedBox(height: 16),
              Center(
                child: TextButton(
                  child: Text(
                    'View All Banks',
                    style: TextStyle(
                        fontFamily: Styles.defaultFont,
                        color: Colors.solidOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                  onPressed: () => null,
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                  flex: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 16),
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: Styles.appButton(
                                buttonStyle: Styles.greyButtonStyle,
                                onClick: () => Navigator.of(context).pop(),
                                text: 'Cancel',
                                elevation: 0),
                          )),
                      SizedBox(width: 32),
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: Styles.appButton(
                                onClick: (_selectedAccountProvider != null && _selectedAccountProvider?.isSelected == true)
                                    ? () => Navigator.of(context).pop(_selectedAccountProvider)
                                    : null,
                                text: 'Next',
                                elevation: 0
                            ),
                          )),
                      SizedBox(width: 16),
                    ],
                  )),
              SizedBox(height: 43),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
