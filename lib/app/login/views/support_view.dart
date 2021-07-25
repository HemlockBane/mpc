import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/login/views/support_shimmer_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/system_configuration.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:moniepoint_flutter/core/viewmodels/system_configuration_view_model.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
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
      {isSingleText = false, Widget? trailingIcon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0XFF3272E1).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    imageRes,
                    width: 47,
                    height: 47,
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
                        subTitle
                      ],
                    )
            ],
          ),
        ),
        trailingIcon ?? Container()
      ],
    );
  }

  Map<String, Tuple<Color, Function()>> _makeSupportLinks(
      String value, Function(String value) fn) {
    final Map<String, Tuple<Color, Function()>> initialValue = {};
    return value.split(",").fold(initialValue, (previousValue, element) {
      previousValue[element] = Tuple(Colors.primaryColor, () => fn(element));
      return previousValue;
    });
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
        final phoneItem = supportItem(
            "Give us a call on:",
            'res/drawables/ic_support_phone.svg',
            Text(e.value ?? "", style: textStyle).colorText(
                _makeSupportLinks(
                    e.value ?? "", (value) => dialNumber("tel:$value")),
                bold: false));
        widgets.add(phoneItem);
      }

      if (e.key == "support.whatsapp") {
        final supportLink = _makeSupportLinks(
          e.value ?? "",
          (value) => dialNumber("https://api.whatsapp.com/send?phone=$value"),
        );

        final trailingWidget = Text(
          e.value ?? "",
          style: textStyle.copyWith(fontWeight: FontWeight.w500),
        ).colorText(supportLink, bold: false);

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
            Text(e.value ?? "", style: textStyle).colorText(
                _makeSupportLinks(
                    e.value ?? "",
                    (value) => dialNumber(Uri(
                            scheme: "mailto",
                            path: "$value",
                            queryParameters: {
                              'subject': 'Hello Moniepoint',
                              'body': "Good day"
                            }).toString())),
                bold: false));
        _emailItem = emailItem;
        hasEmailItem = true;
      }
    });

    if (hasEmailItem) widgets.add(_emailItem);
    return widgets.foldIndexed(<Widget>[],
        (index, List<Widget> cumulativeValue, currentElement) {
      cumulativeValue.add(currentElement);
      if (index < widgets.length - 1) {
        cumulativeValue.add(SizedBox(height: 32));
      }
      return cumulativeValue;
    }).toList();
  }

  Widget supportContainer() {
    final viewModel =
        Provider.of<SystemConfigurationViewModel>(context, listen: false);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<SystemConfigurationViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.backgroundWhite,
      appBar: AppBar(
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
      body: ScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("We're here for you",
                  style: TextStyle(
                      color: Colors.textColorBlack,
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                  'Got a problem? Reach us via any of our \nsupport channels below.',
                  style: TextStyle(color: Colors.textColorBlack, fontSize: 15)),
              SizedBox(height: 32),
              supportContainer(),
              SizedBox(height: 44),
              Flexible(
                child: Row(
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
              ),
              SizedBox(height: 13),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                decoration: BoxDecoration(
                    //
                    ),
                child: StreamBuilder(
                  stream: viewModel.systemConfigStream,
                  builder: (context,
                      AsyncSnapshot<Resource<List<SystemConfiguration>>> a) {
                    if (!a.hasData) return Container();
                    if (a.hasData &&
                        (a.data is Loading && a.data?.data?.isEmpty == true))
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
                            return Visibility(
                                visible: false, child: Container());
                            //not a good approach we should consider moving this to a
                            //separate function and add what's required on a list as that's faster
                          })
                          .whereNot((element) => element is Visibility)
                          .toList(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
