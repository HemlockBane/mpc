
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_type.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/airtime_view_model.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/service_provider_view_model.dart';
import 'package:moniepoint_flutter/app/airtime/views/airtime_view.dart';
import 'package:moniepoint_flutter/app/airtime/views/dialogs/contact_list_dialog.dart';
import 'package:moniepoint_flutter/app/airtime/views/dialogs/service_providers_bottom_sheet.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_list_item.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_shimmer_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/pnd_notification_banner.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:moniepoint_flutter/core/views/generic_list_placeholder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AirtimeBeneficiaryScreen extends StatefulWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;

  AirtimeBeneficiaryScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _AirtimeBeneficiaryScreen();
  }
}

class _AirtimeBeneficiaryScreen extends State<AirtimeBeneficiaryScreen> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin, Validators{

  final Iterable<ComboItem<PurchaseType>> purchaseTypes = List.of([
    ComboItem(PurchaseType.DATA, "Data", icon: SvgPicture.asset('res/drawables/ic_data.svg', width: 35, height: 35,)),
    ComboItem(PurchaseType.AIRTIME,  "Airtime", isSelected: true, icon: SvgPicture.asset('res/drawables/ic_airtime.svg', width: 35, height: 35,)),
  ]);

  final List<AirtimeBeneficiary> _currentItems = [];
  final TextEditingController _phoneNumberController = TextEditingController();
  late final AnimationController _animationController;
  PurchaseType? _selectedPurchaseType;
  Stream<Resource<List<AirtimeBeneficiary>>>? frequentBeneficiaries;

  _AirtimeBeneficiaryScreen() {
    this._animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000)
    );
  }

  @override
  void initState() {
    final viewModel = Provider.of<AirtimeViewModel>(context, listen: false);
    frequentBeneficiaries = viewModel.getFrequentBeneficiaries();
    super.initState();
  }


  void displayServiceProvidersDialog(AirtimeBeneficiary beneficiary) async {
    dynamic result = await showModalBottomSheet(
        context: widget._scaffoldKey.currentContext ?? context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ChangeNotifierProvider(
          create: (_) => ServiceProviderViewModel(),
          child: ServiceProviderDialog(beneficiary, _selectedPurchaseType ?? PurchaseType.AIRTIME),
        )
    );
    if(result is Triple<AirtimeServiceProvider?, bool, String>) {
      final viewModel = Provider.of<AirtimeViewModel>(context, listen: false);

      final mBeneficiary = AirtimeBeneficiary(
          id: 0,
          name: (result.third.isNotEmpty) ? result.third : beneficiary.name,
          phoneNumber: beneficiary.phoneNumber,
          serviceProvider: result.first
      );
      viewModel.setBeneficiary(mBeneficiary);
      viewModel.setSaveBeneficiary(result.second);
      Future.delayed(Duration(milliseconds: 500), (){
        Navigator.of(context).pushNamed(AirtimeScreen.PAYMENT_SCREEN);
      });
    }
  }



  Widget makeListView(BuildContext context, AsyncSnapshot<Resource<List<AirtimeBeneficiary>?>> a) {
    final viewModel = Provider.of<AirtimeViewModel>(context, listen: false);

    return ListViewUtil.makeListViewWithState(
        context: context, 
        snapshot: a,
        loadingView: BeneficiaryShimmer(),
        animationController: _animationController,
        currentList: _currentItems,
        errorLayoutView: GenericListPlaceholder(
            SvgPicture.asset('res/drawables/ic_empty_beneficiary.svg'),
            'You have no airtime or data \nbeneficiaries yet.'
        ),
        emptyPlaceholder: GenericListPlaceholder(
            SvgPicture.asset('res/drawables/ic_empty_beneficiary.svg'),
            'You have no airtime or data beneficiary yet.'
        ),
        listView: (List<AirtimeBeneficiary>? items) {
          return ListView.separated(
              shrinkWrap: true,
              itemCount: items?.length ?? 0,
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Divider(color: Color(0XFFE0E0E0), height: 1,),
              ),
              itemBuilder: (context, index) {
                return BeneficiaryListItem(items![index], index, (beneficiary, int i) {
                  viewModel.setBeneficiary(beneficiary);
                  Navigator.of(context).pushNamed(AirtimeScreen.PAYMENT_SCREEN);
                });
              });
        }
    );
  }

  void _onMobileNumberChanged(String value) {
    if(isPhoneNumberValid(_phoneNumberController.text)) {
      FocusManager.instance.primaryFocus?.unfocus();
      final beneficiary = AirtimeBeneficiary(
          id: 0,
          phoneNumber: _phoneNumberController.text
      );
      displayServiceProvidersDialog(beneficiary);
    }
  }

  void _openContact() async {
    if(await Permission.contacts.request().isGranted) {
      final contact = await Navigator.of(widget._scaffoldKey.currentContext ?? context).pushNamed(Routes.CONTACTS);
      if(contact is! Contact) return;

      final phones = contact.phones?.where((element) => isPhoneNumberValid(element.value));

      if(phones == null || phones.isEmpty) {

        return;
      }

      if(phones.length > 1) {
        final item = await showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: widget._scaffoldKey.currentContext ?? context,
            builder: (context) => ContactListDialog(contact.displayName ?? "", phones.toList())
        );
        if(item != null && item is Item) {
          displayServiceProvidersDialog(AirtimeBeneficiary(id: 0, phoneNumber: item.value, name: contact.displayName));
        }
      } else {
        final item = phones.first;
        displayServiceProvidersDialog(AirtimeBeneficiary(id: 0, phoneNumber: item.value, name: contact.displayName));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewModel = Provider.of<AirtimeViewModel>(context, listen: false);
    return  Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
              PndNotificationBanner(
                onBannerTap: ()async{
                  Navigator.of(widget._scaffoldKey.currentContext!).pushNamed(Routes.ACCOUNT_UPDATE);
                },
              ),
            SizedBox(height: 24),
            Padding(
              padding : EdgeInsets.only(left: 16, right: 16),
              child: Text('What do you want to buy?', style: TextStyle(color: Colors.deepGrey, fontSize: 14, fontWeight: FontWeight.w200)),
            ),
            SizedBox(height: 12),
            Flexible(
                flex: 0,
                fit: FlexFit.tight,
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: SelectionCombo<PurchaseType>(purchaseTypes.toList(), (item, index) {
                      _selectedPurchaseType = item;
                      if(item != null) viewModel.setPurchaseType(item);
                  }),
                )
            ),
            SizedBox(height: 24),
            Expanded(
                flex: 0,
                child: Padding(
                    padding : EdgeInsets.only(left: 16, right: 16),
                    child : Text('Enter Phone Number', textAlign: TextAlign.start, style: TextStyle( fontSize: 14,color: Colors.deepGrey.withOpacity(0.9)))
                )
            ),
            SizedBox(height: 12),
            Expanded(
                flex: 0,
                child: Padding(
                  padding : EdgeInsets.only(left: 16, right: 16),
                  child: Stack(
                    children: [
                      Styles.appEditText(
                          hint: 'Enter Phone Number',
                          animateHint: false,
                          controller: _phoneNumberController,
                          inputFormats: [FilteringTextInputFormatter.digitsOnly],
                          fontSize: 13,
                          onChanged: _onMobileNumberChanged,
                          startIcon: Icon(CustomFont.call, size: 20, color: Colors.colorFaded,)
                      ),
                      Positioned(
                          right: 0,
                          child: Styles.imageButton(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(4), bottomRight:Radius.circular(4)),
                            padding: EdgeInsets.all(12),
                            image: SvgPicture.asset('res/drawables/ic_phone_book.svg', color: Colors.white, width: 32, height: 32,),
                            onClick: _openContact
                          )
                      )
                    ],
                  ),
                )
            ),
            SizedBox(height: 24),
            Expanded(
                flex: 0,
                child: Padding(
                  padding : EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Divider(color: Colors.deepGrey.withOpacity(0.2), thickness: 1,  height: 1)),
                      SizedBox(width: 8),
                      Text('Or', style: TextStyle(color: Colors.deepGrey),),
                      SizedBox(width: 8),
                      Expanded(child: Divider(color: Colors.deepGrey.withOpacity(0.2), thickness: 1, height: 1, )),
                    ],
                  ),
                )
            ),
            SizedBox(height: 18),
            Padding(
              padding : EdgeInsets.only(left: 16, right: 16),
              child: Text('Select a Beneficiary', style: TextStyle(color: Colors.deepGrey, fontSize: 14, fontWeight: FontWeight.w400)),
            ),
            SizedBox(height: 10),
            Expanded(child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.darkBlue.withOpacity(0.1),
                    offset: Offset(0, 4),
                    blurRadius: 12
                  )
                ]
              ),
              child: StreamBuilder(
                  stream: frequentBeneficiaries ,
                  builder: (BuildContext context, AsyncSnapshot<Resource<List<AirtimeBeneficiary>?>> a) {
                    return makeListView(context, a);
                  }),
            )),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              color: Colors.white,
              child: Center(
                child: TextButton(
                  child:Text('View all Beneficiaries', style: TextStyle(color: Colors.solidOrange, fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    final beneficiary = await Navigator.of(widget._scaffoldKey.currentContext!)
                        .pushNamed(Routes.SELECT_AIRTIME_BENEFICIARY);
                    if(beneficiary is AirtimeBeneficiary) {
                      Future.delayed(Duration(milliseconds: 500), (){
                        displayServiceProvidersDialog(beneficiary);
                      });
                    }
                  }
                ),
              ),
            )
          ],
        ),
    );
  }
  
  
  @override
  void dispose() {
    _phoneNumberController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

}