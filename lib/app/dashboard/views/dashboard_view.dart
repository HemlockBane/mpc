import 'dart:math';

import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/dots_indicator.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController = PageController(viewportFraction: 1);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Container _buildRecentlyPaidSection(List<Color> recentlyPaidColors) {
    return Container(
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
      child: Column(children: [
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recently Paid",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xff1A0C2F),
              ),
            ),
            Text(
              "View all",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xff0361F0),
              ),
            )
          ],
        ),
        SizedBox(height: 25),
        Container(
          height: 130,
          child: Stack(
            children: [
              ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  final random = Random();
                  final randInt = random.nextInt(9);
                  final color = recentlyPaidColors[randInt];

                  return Row(
                    children: [
                      _buildRecentlyPaidItem(color: color),
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
      ]),
    );
  }

  Widget _buildNormalAccountCard() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xffF9FBFD),
              borderRadius: BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 13),
                  blurRadius: 21,
                  color: Color(0xff1F0E4FB1).withOpacity(0.12),
                ),
              ]),
          child: Column(
            children: [
              SizedBox(height: 30),
              SizedBox(
                height: 132,
                child: PageView.builder(
                    itemCount: 3,
                    controller: _pageController,
                    itemBuilder: (ctx, idx) {
                      return Column(children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Available Balance",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.textColorBlack),
                              ),
                              // SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('₦ 200,394.00',
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.textColorBlack)),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.visibility,
                                      size: 20,
                                      color:
                                          Color(0xffB8003382).withOpacity(0.4),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 18),
                          padding: EdgeInsets.symmetric(
                              horizontal: 11, vertical: 11),
                          decoration: BoxDecoration(
                            color: Color(0xff0361F0).withOpacity(0.04),
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Account Number',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                        color: Colors.textColorBlack),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text("0011357716",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                          color: Colors.primaryColor))
                                ],
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.share,
                                    size: 24,
                                    color:
                                        Color(0xffB8003382).withOpacity(0.4)),
                              )
                            ],
                          ),
                        ),
                      ]);
                    }),
              ),
              SizedBox(height: 17),
              DotIndicator(controller: _pageController, itemCount: 3),
              SizedBox(height: 20)
            ],
          ),
        ),
        Positioned.fill(
          top: -184,
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                    "res/drawables/ic_dashboard_account_label.svg"),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(height: 4),
              Text(
                'SAVINGS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Expanded _buildSuggestedItem(
      {required String iconPath,
      required String primaryText,
      required String secondaryText,
      required Color color}) {
    return Expanded(
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
                  height: 112,
                  width: 111,
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
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                        color: Colors.white),
                  ),
                  Text(
                    secondaryText,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
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
    );
  }

  Column _buildRecentlyPaidItem({required Color color}) {
    return Column(children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            "res/drawables/ic_m_bg.svg",
            fit: BoxFit.cover,
            height: 65,
            width: 65,
            color: color.withOpacity(0.1),
          ),
          Container(
            height: 65,
            width: 65,
            child: Center(
              // alignment: Alignment.center,
              child: Text(
                'AA',
                style: TextStyle(
                    fontSize: 19, fontWeight: FontWeight.w700, color: color),
              ),
            ),
          ),
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
        "Adrian",
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xff1A0C2F).withOpacity(0.8)),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 4),
      Text(
        "Agho",
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xff1A0C2F).withOpacity(0.8)),
        textAlign: TextAlign.center,
      ),
      // SizedBox(height: 19),
    ]);
  }

  Container _buildItemCard({
    required Color color,
    required String text,
    required String iconString,
  }) {
    return Container(
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
                width: 24,
                height: 24,
                color: color,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Color(0xff1A0C2F),
            ),
          ),
          SizedBox(height: 11)
        ],
      ),
    );
  }

  Container _buildTopIcons(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.074,
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
                'Hello, Leslie',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              SizedBox(width: 9),
              Container(
                height: 32,
                width: 32,
                padding: EdgeInsets.all(2),
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("res/drawables/dashboard_icon.png"),
                    ),
                  ),
                ),
              )
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
        width: width ?? 20,
        height: height ?? 20,
        color: color,
      ),
    );
  }

  Widget drawerListItem(String title, String svgPath, String routeName,
      {double? height, double? width}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.white.withOpacity(0.1),
        overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.02)),
        onTap: () {
          if (routeName.isNotEmpty) {
            Navigator.pop(context);
            Navigator.pushNamed(context, routeName);
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: 40, right: 0, top: 20, bottom: 20),
          child: Row(
            children: [
              _icon(svgPath: svgPath, height: height, width: width),
              SizedBox(
                width: 20,
                height: 20,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: Styles.defaultFont),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final recentlyPaidColors = [
      Color(0xff0361F0),
      Color(0xffECAB03),
      Color(0xff0B3275),
      Color(0xff1EB12D),
      Color(0xffF08922),
      Color(0xff9B51E0),
      Color(0xffE05196),
      Color(0xff51ADE0),
      Color(0xff51E070)
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: Colors.colorPrimaryDark,
          child: Stack(
            children: [
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
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                _icon(
                                    svgPath:
                                        "res/drawables/ic_dashboard_notifications.svg"),
                                Positioned(
                                  top: -13,
                                  right: -10,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.darkRed,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    child: Text(
                                      "99",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 29),
                            _icon(
                                svgPath:
                                    "res/drawables/ic_dashboard_settings.svg"),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 35),
                  Expanded(
                    child: ListView(
                      children: [
                        drawerListItem("Dashboard",
                            "res/drawables/ic_dashboard_dashboard.svg", "",
                            height: 17, width: 17),
                        drawerListItem(
                          "Transfer Money",
                          "res/drawables/ic_dashboard_transfer_2.svg",
                          Routes.TRANSFER,
                          width: 21,
                          height: 14,
                        ),
                        drawerListItem(
                            "Airtime & Data",
                            "res/drawables/ic_dashboard_airtime_2.svg",
                            Routes.AIRTIME),
                        drawerListItem(
                            "Bill Payments",
                            "res/drawables/ic_dashboard_bills_2.svg",
                            Routes.BILL),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          child: Divider(
                              height: 1, color: Colors.white.withOpacity(0.3)),
                        ),
                        drawerListItem(
                            "Manage Account",
                            "res/drawables/ic_dashboard_manage_account.svg",
                            Routes.ACCOUNT_TRANSACTIONS),
                        drawerListItem(
                            "Manage Cards",
                            "res/drawables/ic_dashboard_manage_cards.svg",
                            Routes.CARDS),
                        drawerListItem("Get Loan",
                            "res/drawables/ic_dashboard_manage_cards.svg", ""),
                        drawerListItem("Savings",
                            "res/drawables/ic_dashboard_savings.svg", ""),
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
              )
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Color(0XFFEBF2FA),
        child: ScrollView(
          child: Stack(
            children: [
              Container(
                width: width,
                height: height * 0.3,
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
                    _buildNormalAccountCard(),
                    SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildItemCard(
                          color: Color(0xFF0361F0),
                          text: "Transfer",
                          iconString:
                              "res/drawables/ic_dashboard_transfer_2.svg",
                        ),
                        _buildItemCard(
                          color: Color(0xffF08922),
                          text: "Airtime",
                          iconString:
                              "res/drawables/ic_dashboard_airtime_2.svg",
                        ),
                        _buildItemCard(
                          color: Color(0xff1EB12D),
                          text: "Bills",
                          iconString: "res/drawables/ic_dashboard_bills_2.svg",
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    _buildRecentlyPaidSection(recentlyPaidColors),
                    SizedBox(height: 32),
                    Text(
                      "Suggested for You",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xff1A0C2F).withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        _buildSuggestedItem(
                            iconPath: "res/drawables/ic_dashboard_target.png",
                            primaryText: "Start",
                            secondaryText: "Saving.",
                            color: Color(0xff0361F0)),
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
