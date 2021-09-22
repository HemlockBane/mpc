import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_utils.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';

///@author Paul Okeke
///@Contributor Obinna Igwe
class DashboardRecentlyPaidView extends StatefulWidget {
  final List<Color> recentlyPaidColors = [
    Color(0xff0361F0),
    Color(0xff51E070),
    Color(0xffF08922),
    Color(0xff9B51E0),
    Color(0xffECAB03),
    Color(0xff0B3275),
    Color(0xff1EB12D),
    Color(0xffE05196),
    Color(0xff51ADE0),
  ];

  final Stream<Resource<List<TransferBeneficiary>>> beneficiaries;
  final int minItemForDisplay;
  final int numOfItemsToDisplay;
  final EdgeInsets? margin;

  DashboardRecentlyPaidView({
    required this.beneficiaries,
    this.minItemForDisplay = 3,
    this.numOfItemsToDisplay = 10,
    this.margin,
  }) : super(key: Key("DashboardRecentlyPaidView"));

  @override
  State<StatefulWidget> createState() => _DashboardRecentlyPaidState();
}



///_DashboardRecentlyPaidState
///
///
///
///
///
///
///
class _DashboardRecentlyPaidState extends State<DashboardRecentlyPaidView> {

  final List<Beneficiary> _viewCachedBeneficiaries = [];

  _topHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Recently Paid",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              // height: 18,
            ),
          ),
          TextButton(
            onPressed: () async {
              final beneficiary = await Navigator.pushNamed(context, Routes.SELECT_TRANSFER_BENEFICIARY);
              if(beneficiary != null && beneficiary is TransferBeneficiary) {
                Navigator.of(context).pushNamed(Routes.TRANSFER, arguments: {
                  TransferScreen.START_TRANSFER: beneficiary
                });
              }
            },
            child: Text(
              "View all",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.primaryColor,
              ),
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.beneficiaries,
        builder: (mContext,
            AsyncSnapshot<Resource<List<TransferBeneficiary>>> snapShot) {
          if (!snapShot.hasData) return SizedBox();
          ///If it's loading and it doesn't have data, return
          ///However if there's cached data in the db we can load that first.
          if ((snapShot.data is Loading && snapShot.data?.data?.isEmpty == true)
              || (snapShot.data is Error && _viewCachedBeneficiaries.isEmpty)) return SizedBox();

          //clear the cached data so we can add new ones if they exist
          if(snapShot.data is Loading || snapShot.data is Success) {
            _viewCachedBeneficiaries.clear();
          }

          //Adds newly fetched Data to the viewCache
          _viewCachedBeneficiaries.addAll(snapShot.data?.data ?? []);

          if (_viewCachedBeneficiaries.length < widget.minItemForDisplay) return SizedBox();

          final recentBeneficiaries = BeneficiaryUtils.sortByFrequentlyUsed(_viewCachedBeneficiaries);

          return Container(
            padding: EdgeInsets.only(left: 17, right: 17, top: 9, bottom: 10),
            margin: widget.margin,
            decoration: BoxDecoration(
                color: Colors.backgroundWhite,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Color(0xff1F0E4FB1).withOpacity(0.12))
                ]),
            child: Column(
              children: [
                _topHeader(),
                SizedBox(height: 20),
                Container(
                  height: 120,
                  child: _RecentlyPaidListView(
                    colors: widget.recentlyPaidColors,
                    beneficiaries: recentBeneficiaries
                        .take(widget.numOfItemsToDisplay)
                        .toList(),
                  ),
                )
              ],
            ),
          );
        });
  }
}

/// _RecentlyPaidListView
///
///
///
///
class _RecentlyPaidListView extends Stack {
  final List<Color> colors;
  final List<Beneficiary> beneficiaries;

  _RecentlyPaidListView({required this.beneficiaries, required this.colors});

  @override
  Key? get key => Key("recently-paid-list-view");

  @override
  List<Widget> get children => _contentView();

  int getColorIndex(int index, int listLength) {
    if (index < listLength - 1) return index;
    return index % listLength;
  }

  List<Widget> _contentView() {
    return [
      ListView.separated(
        separatorBuilder: (ctx, index) => SizedBox(width: 25),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: beneficiaries.length,
        itemBuilder: (BuildContext context, int index) {
          final colorIdx = getColorIndex(index, colors.length);
          final color = colors[colorIdx];
          final recentlyPaidBeneficiary = beneficiaries[index];

          return _RecentlyPaidBeneficiaryItem(
              backgroundColor: color, beneficiary: recentlyPaidBeneficiary
          );
        },
      ),
      Align(
        alignment: Alignment.topRight,
        child: Container(
          height: 112,
          width: 40,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff00FFFFFF), Colors.white],
                  stops: [0.48, 1.0])),
        ),
      )
    ];
  }
}

/// _RecentlyPaidBeneficiaryItem
///
///
///
/// TODO requires more refactoring
class _RecentlyPaidBeneficiaryItem extends StatelessWidget {
  final Color backgroundColor;
  final Beneficiary beneficiary;

  _RecentlyPaidBeneficiaryItem(
      {required this.backgroundColor, required this.beneficiary});

  _beneficiaryNames() => beneficiary
      .getAccountName()
      .toLowerCase()
      .capitalizeFirstOfEach
      .split(" ");

  _onItemClicked(BuildContext context, Beneficiary beneficiary) {
    Navigator.of(context).pushNamed(Routes.TRANSFER, arguments: {
      TransferScreen.START_TRANSFER: beneficiary
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO requires more refactoring
    var firstName = "";
    var lastName = "";

    final names = _beneficiaryNames();

    if (names.isNotEmpty) {
      if (names.length < 2) {
        firstName = names[0];
      } else {
        firstName = names[0];
        lastName = names[1];
      }
    }

    return Column(children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            "res/drawables/ic_m_bg.svg",
            fit: BoxFit.cover,
            height: 64,
            width: 64,
            color: backgroundColor.withOpacity(0.11),
          ),
          Container(
            height: 64,
            width: 64,
            child: Material(
              borderRadius: BorderRadius.circular(17),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(17),
                overlayColor: MaterialStateProperty.all(backgroundColor.withOpacity(0.1)),
                highlightColor: backgroundColor.withOpacity(0.05),
                onTap: () => _onItemClicked(context, beneficiary),
                child: Center(
                  child: Text(
                    beneficiary.getAccountName().abbreviate(2, false, includeMidDot: false),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: backgroundColor
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (beneficiary.isIntraBank())
            Positioned(
              top: -2,
              right: 1,
              child: SvgPicture.asset(
                "res/drawables/ic_m_bg.svg",
                fit: BoxFit.cover,
                height: 20,
                width: 20,
                color: Colors.white,
              ),
            ),
          if (beneficiary.isIntraBank())
            Positioned(
              top: 0,
              right: 3,
              child: SvgPicture.asset(
                "res/drawables/ic_moniepoint_cube_alt.svg",
                fit: BoxFit.cover,
                height: 16,
                width: 16,
              ),
            ),
        ],
      ),
      SizedBox(height: 6),
      Text(
        "$firstName\n$lastName",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 13,
            letterSpacing: -0.2,
            height: 1.3,
            fontWeight: FontWeight.w500,
            color: Colors.textColorBlack.withOpacity(0.9)
        ),
        textAlign: TextAlign.center,
      ),
    ]);
  }
}
