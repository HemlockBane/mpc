import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/login/views/support_shimmer_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/system_configuration.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:moniepoint_flutter/core/viewmodels/system_configuration_view_model.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class SupportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SupportScreen();
}

class _SupportScreen extends State<SupportScreen> {
  initState() {
    final viewModel =
        Provider.of<SystemConfigurationViewModel>(context, listen: false);
    viewModel.getSystemConfigurations().listen((event) {});
    super.initState();
  }

  Widget supportItem(String title, String imageRes, Widget subTitle,
      {isSingleText = false,
      bool isClickableTile = false,
      VoidCallback? clickableFn,
      Widget? trailingIcon,
      String supportChannelValue = ""}) {
    return GestureDetector(
      onTap: clickableFn,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0XFF3272E1).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      imageRes,
                      width: 18,
                      height: 18,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                isSingleText
                    ? Text(
                        title,
                        style: TextStyle(
                            color: Colors.textColorBlack,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                color: Colors.deepGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            supportChannelValue,
                            style: TextStyle(
                              color: Colors.textColorBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
              ],
            ),
          ),
          trailingIcon ?? Container()
        ],
      ),
    );
  }

  List<Widget> _makeSupportItemList(
      List<SystemConfiguration> systemConfigurations) {
    final List<Widget> widgets = [];
    final textStyle =
        TextStyle(color: Colors.primaryColor, fontFamily: Styles.defaultFont);

    late Widget _emailItem;
    bool hasEmailItem = false;

    systemConfigurations.forEach((e) {
      if (e.key == "support.phone") {
        final trailingIcon = TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.primaryColor),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset('res/drawables/ic_support_phone_white.svg'),
              SizedBox(width: 7),
              Text(
                "Call",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          onPressed: () {
            dialNumber("tel:${e.value}");
          },
        );

        final phoneItem = supportItem("Give us a call",
            'res/drawables/ic_support_phone.svg', Text(e.value ?? ""),
            trailingIcon: trailingIcon, supportChannelValue: e.value ?? "");
        widgets.add(phoneItem);
      }

      if (e.key == "support.whatsapp") {
        final trailingWidget = InkWell(
          child: Text(
            "Send Message",
            style: textStyle,
          ),
          onTap: () {
            dialNumber("https://api.whatsapp.com/send?phone=${e.value}");
          },
        );

        final phoneItem = supportItem(
          "Chat on WhatsApp",
          'res/drawables/ic_support_whatsapp_filled.svg',
          Text(e.value ?? "", style: textStyle),
          trailingIcon: trailingWidget,
          isSingleText: true,
        );
        widgets.add(phoneItem);
      }

      if (e.key == "support.email") {
        final emailItem = supportItem(
          "Send us an email",
          'res/drawables/ic_support_message_filled.svg',
          Text(e.value ?? "", style: textStyle),
          clickableFn: () {
            final uri = Uri(
                scheme: "mailto",
                path: "${e.value}",
                queryParameters: {
                  'subject': 'Hello Moniepoint',
                  'body': "Good day"
                }).toString();
            dialNumber(uri);
          },
          supportChannelValue: e.value ?? "",
        );
        _emailItem = emailItem;
        hasEmailItem = true;
      }
    });

    if (hasEmailItem) widgets.add(_emailItem);
    return widgets.foldIndexed(<Widget>[],
        (index, List<Widget> cumulativeValue, currentElement) {
      cumulativeValue.add(currentElement);
      if (index < widgets.length - 1) {
        cumulativeValue.add(
          Column(
            children: [
              SizedBox(height: 20),
              Divider(height: 1),
              SizedBox(height: 20),
            ],
          ),
        );
      }
      return cumulativeValue;
    }).toList();
  }

  Widget supportContainer() {
    final viewModel =
        Provider.of<SystemConfigurationViewModel>(context, listen: false);

    return Container(
      decoration: BoxDecoration(),
      child: StreamBuilder(
        stream: viewModel.systemConfigStream,
        builder:
            (context, AsyncSnapshot<Resource<List<SystemConfiguration>>> a) {
          if (!a.hasData) return Container();
          if (a.hasData && (a.data is Loading && a.data?.data?.isEmpty == true))
            return SupportShimmer();
          if (a.hasData &&
              (a.data is Error && a.data?.data?.isEmpty == true ||
                  a.data?.data == null)) return Container();
          return Column(
            children: _makeSupportItemList(a.data?.data ?? []),
          );
        },
      ),
    );
  }

  Widget _buildSocialMediaIcons(SystemConfigurationViewModel viewModel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 54, vertical: 18),
      decoration: BoxDecoration(),
      child: StreamBuilder(
        stream: viewModel.systemConfigStream,
        builder:
            (context, AsyncSnapshot<Resource<List<SystemConfiguration>>> a) {
          if (!a.hasData) return Container();
          if (a.hasData && (a.data is Loading && a.data?.data?.isEmpty == true))
            return Container();
          if (a.hasData &&
              (a.data is Error && a.data?.data?.isEmpty == true ||
                  a.data?.data == null)) return Container();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: a.data!.data!
                .map((e) {
                  if (e.key == "support.facebook") {
                    return Styles.imageButton(
                        color: Colors.white,
                        padding: EdgeInsets.all(0),
                        image: SvgPicture.asset(
                          'res/drawables/ic_support_facebook.svg',
                          width: 40,
                          height: 40,
                        ),
                        borderRadius: BorderRadius.circular(80),
                        onClick: () => dialNumber(e.value ?? ""));
                  }
                  if (e.key == "support.twitter") {
                    return Styles.imageButton(
                        color: Colors.white,
                        padding: EdgeInsets.all(0),
                        image: SvgPicture.asset(
                          'res/drawables/ic_support_twitter.svg',
                          width: 40,
                          height: 40,
                        ),
                        borderRadius: BorderRadius.circular(80),
                        onClick: () => dialNumber(e.value ?? ""));
                  }
                  if (e.key == "support.instagram") {
                    return Styles.imageButton(
                        color: Colors.white,
                        padding: EdgeInsets.all(0),
                        image: SvgPicture.asset(
                          'res/drawables/ic_support_instagram.svg',
                          width: 40,
                          height: 40,
                        ),
                        borderRadius: BorderRadius.circular(80),
                        onClick: () => dialNumber(e.value ?? ""));
                  }
                  if (e.key == "support.telegram") {
                    return Styles.imageButton(
                        color: Colors.white,
                        padding: EdgeInsets.all(0),
                        image: SvgPicture.asset(
                          'res/drawables/ic_support_telegram.svg',
                          width: 40,
                          height: 40,
                        ),
                        borderRadius: BorderRadius.circular(80),
                        onClick: () => dialNumber(e.value ?? ""));
                  }
                  return Visibility(visible: false, child: Container());
                  //not a good approach we should consider moving this to a
                  //separate function and add what's required on a list as that's faster
                })
                .whereNot((element) => element is Visibility)
                .toList(),
          );
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<SystemConfigurationViewModel>(context, listen: false);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height - kToolbarHeight;

    return Scaffold(
      backgroundColor: Colors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: Colors.backgroundWhite,
        elevation: 0,
        leading: Container(),
      ),
      body: ScrollView(
        child: Container(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: width,
                  height: height * 0.27,
                  child: SvgPicture.asset(
                    "res/drawables/support_bg.svg",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: height * 0.81),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Reach us on social media',
                          style: TextStyle(
                            color: Colors.textColorBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    _buildSocialMediaIcons(viewModel),
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      centerTitle: false,
                      titleSpacing: -3,
                      iconTheme: IconThemeData(color: Colors.primaryColor),
                      title: Text(
                        'Support',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.darkBlue,
                          fontFamily: Styles.defaultFont,
                          fontSize: 16,
                        ),
                      ),
                      backgroundColor: Colors.backgroundWhite,
                      elevation: 0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "We're here for you.",
                            style: TextStyle(
                                color: Colors.textColorBlack,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Got a problem? Reach us via any of our \nsupport channels below.',
                            style: TextStyle(
                                color: Colors.textColorBlack, fontSize: 15),
                          ),
                          SizedBox(height: 42),
                          supportContainer(),
                        ],
                      ),
                    )
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
