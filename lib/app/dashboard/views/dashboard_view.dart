import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_icons2_icons.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/strings.dart';

import 'dashboard_account_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController = PageController(viewportFraction: 1);
  PageController _mPageController = PageController(viewportFraction: 1);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Stream<Resource<List<TransferBeneficiary>>>? recentlyPaidBeneficiaries;
  Stream<Resource<FileResult>>? _fileResultStream;
  late String? passportUUID;

  late DashboardViewModel _viewModel;
  final items = <BannerItem>[];

  Widget _buildRecentlyPaidList(List<Color> recentlyPaidColors,
      List<TransferBeneficiary> recentlyPaidBeneficiaries) {
    return Column(children: [
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Recently Paid",
            style: Styles.textStyle(
              context,
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              // height: 18,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.TRANSFER);
            },
            child: Text(
              "View all",
              style: Styles.textStyle(
                context,
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
                color: Color(0xff0361F0),
              ),
            ),
          )
        ],
      ),
      SizedBox(height: 25),
      Container(
        height: 120,
        child: Stack(
          children: [
            ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: recentlyPaidBeneficiaries.take(10).length,
              itemBuilder: (BuildContext context, int index) {
                final colorIdx =
                    getColorIndex(index, recentlyPaidColors.length);
                final color = recentlyPaidColors[colorIdx];
                final recentlyPaidBeneficiary =
                    recentlyPaidBeneficiaries[index];

                return Row(
                  children: [
                    _buildRecentlyPaidItem(
                        color: color,
                        recentlyPaidBeneficiary: recentlyPaidBeneficiary),
                    SizedBox(width: 25)
                  ],
                );
              },
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 112,
                width: 40,
                // color: Colors.red,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xff00FFFFFF), Colors.white],
                        stops: [0.48, 1.0])),
              ),
            )
          ],
        ),
      )
    ]);
  }

  int getColorIndex(int index, int listLength) {
    if (index < listLength - 1) {
      return index;
    }

    return index % listLength;
  }

  void showComingSoonInfo() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return BottomSheets.makeAppBottomSheet2(
            height: 300,
            dialogIcon: SvgPicture.asset(
              'res/drawables/ic_info.svg',
              color: Colors.primaryColor,
              width: 40,
              height: 40,
            ),
            centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
            centerBackgroundPadding: 15,
            content: Column(
              children: [
                SizedBox(height: 20),
                Text('Coming Soon',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.textColorBlack)),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 75),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                      "This feature is currently in development. Not to worry, you’ll be using it sooner than you think. ",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.darkBlue),
                      textAlign: TextAlign.center),
                ),
                SizedBox(height: 24),
                TextButton(
                  child: Text(
                    'Dismiss',
                    style: TextStyle(color: Colors.primaryColor, fontSize: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(height: 32)
              ],
            ),
          );
        });
  }

  Widget _buildSuggestedItem(
      {required String iconPath,
      required String primaryText,
      required String secondaryText,
      required Color color,
      bool isTarget = false}) {
    return Expanded(
      child: InkWell(
        onTap: () => showComingSoonInfo(),
        child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Color(0xff1F0E4FB1).withOpacity(0.12),
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: isTarget ? 115 : 112,
                    width: 112,
                    child: Image.asset(iconPath),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      primaryText,
                      style: Styles.textStyle(context,
                          fontWeight: FontWeight.w700,
                          fontSize: 17.1,
                          color: Colors.white),
                    ),
                    Text(
                      secondaryText,
                      style: Styles.textStyle(context,
                          fontWeight: FontWeight.w700,
                          fontSize: 17.1,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentlyPaidItem(
      {required Color color,
      required TransferBeneficiary recentlyPaidBeneficiary}) {
    var firstName = "";
    var lastName = "";

    final names = recentlyPaidBeneficiary
        .getAccountName()
        .toLowerCase()
        .capitalizeFirstOfEach
        .split(" ");

    if (names.isNotEmpty) {
      if (names.length < 2) {
        firstName = names[0];
      } else {
        lastName = names[0];
        firstName = names[1];
      }
    }

    return Column(children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            "res/drawables/ic_m_bg.svg",
            fit: BoxFit.cover,
            height: 59,
            width: 59,
            color: color.withOpacity(0.11),
          ),
          Container(
            height: 59,
            width: 59,
            child: Center(
              // alignment: Alignment.center,
              child: Text(
                recentlyPaidBeneficiary
                    .getAccountName()
                    .abbreviate(2, false, includeMidDot: false),
                style: Styles.textStyle(context,
                    fontSize: 19.3, fontWeight: FontWeight.w700, color: color),
              ),
            ),
          ),
          if (_viewModel.isIntraTransfer(recentlyPaidBeneficiary))
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
          if (_viewModel.isIntraTransfer(recentlyPaidBeneficiary))
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
        firstName,
        style: Styles.textStyle(context,
            fontSize: 11.4,
            letterSpacing: -0.2,
            fontWeight: FontWeight.w500,
            color: Color(0xff1A0C2F).withOpacity(0.9)),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 2),
      Text(
        lastName,
        style: Styles.textStyle(context,
            fontSize: 11.4,
            letterSpacing: -0.2,
            fontWeight: FontWeight.w500,
            color: Color(0xff1A0C2F).withOpacity(0.9)),
        textAlign: TextAlign.center,
      ),
      // SizedBox(height: 19),
    ]);
  }

  Widget _buildItemCard(
      {required Color color,
      required String text,
      required String iconString,
      required String routeName,
      double height = 24,
      double width = 24}) {
    return InkWell(
      onTap: () {
        if (routeName.isNotEmpty) {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xffF9FBFD),
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Color(0xff1F0E4FB1).withOpacity(0.12),
              ),
            ]),
        child: Column(
          children: [
            SizedBox(height: 17),
            Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconString,
                  width: width,
                  height: height,
                  color: color,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: Styles.textStyle(
                context,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
                fontSize: 12.3,
                color: Color(0xff1A0C2F).withOpacity(0.8),
              ),
            ),
            SizedBox(height: 11)
          ],
        ),
      ),
    );
  }

  Widget _buildTopIcons(BuildContext context) {
    final firstName = UserInstance().getUser()?.firstName ?? "";
    final passportUUID = UserInstance().getUser()?.customers?[0];
    Widget? _itemImage;

    final fallbackImage = Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
          border: Border.all(color: Colors.white.withOpacity(0.4))),
      child: Icon(
        CustomIcons2.username,
        color: Color(0xffF5F9FF).withOpacity(0.5),
        size: 21,
      ),
    );

    final backWidget = (String? base64String) => Container(
          width: 33,
          height: 33,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: MemoryImage(
                    base64Decode(base64String!),
                  ),
                  onError: (_, __) => _itemImage = fallbackImage)),
        );

    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.084,
        left: 16,
        right: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: SvgPicture.asset(
              "res/drawables/ic_dashboard_drawer_menu.svg",
              height: 16,
              width: 24,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Text(
                firstName.isEmpty ? "Hello" : "Hello, $firstName",
                style: Styles.textStyle(context,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              SizedBox(width: 9),
              StreamBuilder(
                stream: (passportUUID != null) ? _fileResultStream : null,
                builder: (ctx, AsyncSnapshot<Resource<FileResult>> snapShot) {
                  if (!snapShot.hasData ||
                      snapShot.data == null ||
                      snapShot.data is Loading ||
                      (snapShot.data is Error && _itemImage == null))
                    return fallbackImage;

                  final base64 = snapShot.data?.data;
                  final base64String = base64?.base64String;

                  if ((base64 == null ||
                          base64String == null ||
                          base64String.isEmpty == true) &&
                      _itemImage == null) {
                    return fallbackImage;
                  }

                  if (_itemImage == null) {
                    _itemImage = backWidget(base64String);
                  }

                  return _itemImage!;
                },
              ),
              SizedBox(width: 4)
            ],
          )
        ],
      ),
    );
  }

  Widget _icon(
      {required String svgPath,
      Color? color,
      double? width,
      double? height,
      VoidCallback? onClick}) {
    return InkWell(
      highlightColor: Colors.white.withOpacity(0.1),
      overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.02)),
      onTap: onClick,
      child: SvgPicture.asset(
        svgPath,
        width: width ?? 21,
        height: height ?? 21,
        color: color,
      ),
    );
  }

  Widget drawerListItem(String title, String svgPath, String routeName,
      {double? height,
      double? width,
      bool shouldNavigate = true,
      VoidCallback? onTapAlt,
      double spacing = 10}) {
    final onTapDefault = () {
      if (routeName.isNotEmpty) {
        Navigator.pop(context);
        Navigator.pushNamed(context, routeName);
      }
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.white.withOpacity(0.1),
        overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.02)),
        onTap: shouldNavigate
            ? onTapDefault
            : onTapAlt ?? () => Navigator.pop(context),
        child: Container(
          padding: EdgeInsets.only(left: 40, right: 0, top: 20, bottom: 20),
          child: Row(
            children: [
              _icon(svgPath: svgPath, height: height, width: width),
              SizedBox(
                width: spacing,
              ),
              Text(
                title,
                style: Styles.textStyle(context,
                    color: Colors.white,
                    fontSize: 14.6,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        child: Container(
          color: Colors.colorPrimaryDark,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 1,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Colors.red,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff0B3275).withOpacity(0.5),
                          Color(0xff0B3275)
                        ],
                        stops: [
                          0.8,
                          1.0
                        ]),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 58),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 21),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _icon(
                            svgPath: "res/drawables/ic_moniepoint_cube_2.svg",
                            width: 40,
                            height: 40),
                        Row(
                          children: [
                            // Stack(
                            //   clipBehavior: Clip.none,
                            //   children: [
                            //     _icon(
                            //         svgPath:
                            //             "res/drawables/ic_dashboard_notifications.svg"),
                            //     Positioned(
                            //       top: -13,
                            //       right: -10,
                            //       child: Container(
                            //         padding: EdgeInsets.all(2),
                            //         decoration: BoxDecoration(
                            //             color: Colors.darkRed,
                            //             borderRadius:
                            //                 BorderRadius.all(Radius.circular(4))),
                            //         child: Text(
                            //           "99",
                            //           style: TextStyle(
                            //             color: Colors.white,
                            //             fontSize: 10,
                            //             fontWeight: FontWeight.w600,
                            //           ),
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            // SizedBox(width: 29),
                            _icon(
                                svgPath:
                                    "res/drawables/ic_dashboard_settings.svg",
                                onClick: () => Navigator.pushNamed(
                                    context, Routes.SETTINGS)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        SizedBox(height: 24),
                        _sectionTitle(context, "TRANSACTIONS"),
                        drawerListItem(
                            "Transfer Money",
                            "res/drawables/ic_dashboard_transfer_2.svg",
                            Routes.TRANSFER,
                            width: 21,
                            height: 17,
                            spacing: 5),
                        drawerListItem(
                            "Airtime & Data",
                            "res/drawables/ic_dashboard_airtime_2.svg",
                            Routes.AIRTIME,
                            height: 26),
                        drawerListItem(
                            "Bill Payments",
                            "res/drawables/ic_dashboard_bills_2.svg",
                            Routes.BILL),
                        SizedBox(
                          height: 21,
                        ),
                        _sectionTitle(context, "ACCOUNTS & CARDS"),
                        drawerListItem(
                            "Manage Account",
                            "res/drawables/ic_dashboard_manage_account.svg",
                            Routes.ACCOUNT_TRANSACTIONS,
                            height: 26,
                            spacing: 5),
                        drawerListItem(
                            "Manage Cards",
                            "res/drawables/ic_dashboard_manage_cards.svg",
                            Routes.CARDS,
                            height: 18),
                        SizedBox(
                          height: 21,
                        ),
                        _sectionTitle(context, "SAVINGS & LOANS"),
                        drawerListItem("Savings",
                            "res/drawables/ic_dashboard_savings.svg", "",
                            shouldNavigate: false,
                            onTapAlt: showComingSoonInfo,
                            height: 26,
                            spacing: 5),
                        drawerListItem("Get Loan",
                            "res/drawables/ic_dashboard_manage_cards.svg", "",
                            shouldNavigate: false,
                            onTapAlt: showComingSoonInfo,
                            height: 18),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 64,
                right: 36,
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: _icon(
                      svgPath: "res/drawables/ic_cancel_dashboard.svg",
                      onClick: () => Navigator.pop(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _sectionTitle(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.only(left: 39, right: 20),
      child: Row(
        children: [
          Text(
            title,
            style: Styles.textStyle(context,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.15),
                letterSpacing: 1.3),
          ),
          SizedBox(width: 10),
          Expanded(
              child: Divider(height: 1, color: Colors.white.withOpacity(0.3))),
        ],
      ),
    );
  }

  Future<Widget> _buildDashboardSlider() async {
    //Since we have only a single update page for now we can put it in here

    if (_hasCompletedAccountUpdate()) {
      return Container();
    }

    items.addAll([
      BannerItem(
          svgPath: 'res/drawables/ic_dashboard_edit.svg',
          primaryText: 'Upgrade Account',
          secondaryText:
              'Upgrade your savings account\nto enjoy higher limits'),
      // BannerItem(
      //     svgPath: 'res/drawables/ic_dashboard_edit.svg',
      //     primaryText: 'Upgrade Account',
      //     secondaryText: 'Upgrade your savings account\nto enjoy higher limits')
    ]);

    await Future.delayed(Duration(milliseconds: 100));

    return SizedBox(
      height: 140,
      child: PageView.builder(
          itemCount: items.length,
          controller: _mPageController,
          itemBuilder: (BuildContext context, int index) {
            // return items[index % items.length];
            final item = items[index];
            return Stack(
              children: [
                _dashboardUpdateItem(
                    svgPath: item.svgPath,
                    primaryText: item.primaryText,
                    secondaryText: item.secondaryText,
                    itemCount: items.length),
                // if (items.length > 1) SizedBox(height: 19),
                // if (items.length > 1)
                //   DotIndicator(
                //     itemCount: items.length,
                //     controller: _mPageController,
                //   ),
              ],
            );
          }),
    );
  }

  bool _hasCompletedAccountUpdate() {
    final viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    Customer? customer = viewModel.customer;
    AccountStatus? accountStatus = UserInstance().accountStatus;
    final flags = accountStatus?.listFlags() ?? customer?.listFlags();
    if (flags == null) return true;
    return flags.where((element) => element?.status != true).isEmpty;
  }

  Widget _dashboardUpdateItem({
    required String svgPath,
    required String primaryText,
    required String secondaryText,
    required int itemCount,
  }) {
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Text(primaryText,
            style: Styles.textStyle(context,
                fontWeight: FontWeight.bold,
                color: Colors.primaryColor,
                fontSize: 14.5)),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: itemCount > 1
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(secondaryText,
                style: Styles.textStyle(context,
                    color: Colors.textColorBlack,
                    fontSize: 12.6,
                    fontWeight: FontWeight.w300,
                    lineHeight: 1.5)),
            if (itemCount > 1)
              Container(
                margin: const EdgeInsets.only(right: 20, top: 4),
                child: SvgPicture.asset('res/drawables/ic_forward_arrow.svg',
                    height: 18, width: 18, color: Colors.primaryColor),
              )
          ],
        )
      ],
    );
    final uncentered = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 125, width: 125,
          child: Image.asset("res/drawables/ic_dashboard_edit.png", 
          fit: BoxFit.cover, height: 130, width: 130, 
          alignment: Alignment.center, scale: 2.0,),
          ),
        // SizedBox(width: 10),
        if (itemCount > 1)
          Expanded(
            child: column,
          ),

        if (itemCount <= 1) column
      ],
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onTap: () => (!_hasCompletedAccountUpdate())
              ? Navigator.of(context)
                  .pushNamed(Routes.ACCOUNT_UPDATE)
                  // .then((_) => subscribeUiToAccountStatus())
                  .then((_) => null)
              : setState(() => {}),
          child: Container(
            // padding: EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(height: itemCount > 1 ? 7 : 12),
                    uncentered,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    recentlyPaidBeneficiaries = _viewModel.getRecentlyPaidBeneficiary();
    passportUUID = UserInstance().getUser()?.customers?[0].passportUUID;
    _fileResultStream =
        _viewModel.getFile("7fc0dc1b-8ea3-448f-8f23-183b231b71bf");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final recentlyPaidColors = [
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

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      body: Container(
        width: double.infinity,
        color: Color(0XFFEBF2FA),
        child: ScrollView(
          child: Stack(
            children: [
              Container(
                width: width,
                height: height * 0.35,
                child: SvgPicture.asset(
                  "res/drawables/bg.svg",
                  fit: BoxFit.fill,
                  ),
              ),
              _buildTopIcons(context),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.16,
                    ),
                    AccountCard(viewModel: _viewModel, pageController: _pageController),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildItemCard(
                            color: Color(0xFF0361F0),
                            width: 25,
                            height: 19,
                            text: "Transfer",
                            iconString:
                                "res/drawables/ic_dashboard_transfer_2.svg",
                            routeName: Routes.TRANSFER),
                        _buildItemCard(
                            color: Color(0xffF08922),
                            width: 19.75,
                            height: 31,
                            text: "Airtime",
                            iconString:
                                "res/drawables/ic_dashboard_airtime_2.svg",
                            routeName: Routes.AIRTIME),
                        _buildItemCard(
                            color: Color(0xff1EB12D),
                            width: 22,
                            height: 25,
                            text: "Bills",
                            iconString:
                                "res/drawables/ic_dashboard_bills_2.svg",
                            routeName: Routes.BILL),
                      ],
                    ),
                    if (!_hasCompletedAccountUpdate()) SizedBox(height: 32),
                    FutureBuilder(
                        future: _buildDashboardSlider(),
                        builder: (ctx, AsyncSnapshot<Widget> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return snapshot.data!;
                          }

                          return Container();
                        }),
                    SizedBox(height: 32),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 17),
                      decoration: BoxDecoration(
                          color: Color(0xffF9FBFD),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Color(0xff1F0E4FB1).withOpacity(0.12),
                            ),
                          ]),
                      child: StreamBuilder(
                        stream: recentlyPaidBeneficiaries,
                        builder: (BuildContext context,
                            AsyncSnapshot<Resource<List<TransferBeneficiary>?>>
                                snapshot) {
                          if (!snapshot.hasData) return Container();

                          final resource = snapshot.data;
                          final hasData = resource?.data?.isNotEmpty == true;

                          if (resource is Loading && !hasData) {
                            return Container();
                          }

                          if ((snapshot.hasError || snapshot.data is Error)) {
                            Container();
                          }

                          if (resource == null ||
                              resource is Loading &&
                                  resource.data?.isEmpty == true) {
                            return Container();
                          }

                          if (resource is Success && !hasData) {
                            return Container();
                          }

                          final beneficiaries = resource.data;

                          if ((beneficiaries == null) ||
                              beneficiaries.length < 3) {
                            return Container();
                          }


          final sortedItems = BeneficiaryUtils.sortByFrequentlyUsed(beneficiaries).toList();

                          return _buildRecentlyPaidList(
                              recentlyPaidColors, sortedItems);
                        },
                      ),
                    ),
                    SizedBox(height: 32),
                    Text(
                      "Suggested for You",
                      style: Styles.textStyle(
                        context,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.2,
                        color: Color(0xff1A0C2F).withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        _buildSuggestedItem(
                          isTarget: true,
                          iconPath: "res/drawables/ic_dashboard_target.png",
                          primaryText: "Start",
                          secondaryText: "Saving.",
                          color: Color(0xff0361F0),
                        ),
                        SizedBox(width: 20.5),
                        _buildSuggestedItem(
                            iconPath: "res/drawables/ic_dashboard_calendar.png",
                            primaryText: "Get a",
                            secondaryText: "Loan.",
                            color: Color(0xff1EB12D))
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BannerItem {
  final String svgPath;
  final String primaryText;
  final String secondaryText;

  BannerItem(
      {required this.svgPath,
      required this.primaryText,
      required this.secondaryText});
}
