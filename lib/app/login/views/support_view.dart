import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/login/views/support_shimmer_view.dart';
import 'package:moniepoint_flutter/app/login/views/support_contact_view.dart';
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
    final viewModel = Provider.of<SystemConfigurationViewModel>(context, listen: false);
    viewModel.getSystemConfigurations().listen((event) {});
    super.initState();
  }

  Widget _buildSocialMediaIcons(SystemConfigurationViewModel viewModel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 54, vertical: 18),
      decoration: BoxDecoration(),
      child: StreamBuilder(
        stream: viewModel.systemConfigStream,
        builder: (context, AsyncSnapshot<Resource<List<SystemConfiguration>>> a) {
          if (!a.hasData) return Container();
          if (a.hasData && (a.data is Loading && a.data?.data?.isEmpty == true))
            return Container();
          if (a.hasData && (a.data is Error && a.data?.data?.isEmpty == true ||
                  a.data?.data == null)) return Container();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: a.data!.data!.map((e) {
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
                        onClick: () => openUrl(e.value ?? ""));
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
                        onClick: () => openUrl(e.value ?? ""));
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
                        onClick: () => openUrl(e.value ?? ""));
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
                        onClick: () => openUrl(e.value ?? "")
                    );
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Expanded(child: Container(
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
                    SizedBox(height: 60),
                    SupportContactView(systemConfigStream: viewModel.systemConfigStream,),
                  ],
                ),
              )),
              Container(
                padding: EdgeInsets.only(top: 17, bottom: 40),
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.solidDarkBlue.withOpacity(0.12), width: 0.8))
                ),
                child: SupportItem(
                    imageRes: 'res/drawables/ic_virtual_card_web.svg',
                    title: "Visit our website",
                    subTitle: TextButton(
                        onPressed: () => openUrl("https://api.whatsapp.com/send?phone="),
                        child: Text(
                          "Open Website",
                          style: SupportContactView.linkStyle,
                        )
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
