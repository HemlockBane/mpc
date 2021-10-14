
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/login/views/support_shimmer_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/system_configuration.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:collection/collection.dart';


class SupportContactView extends StatelessWidget {

  SupportContactView({required this.systemConfigStream});

  final Stream<Resource<List<SystemConfiguration>>> systemConfigStream;

  Map<String, Tuple<Color, Function()>> _makeSupportLinks(String value, Function(String value) fn) {
    final Map<String, Tuple<Color, Function()>> initialValue =  {};
    return value.split(",").fold(initialValue, (previousValue, element) {
      previousValue[element] = Tuple(Colors.primaryColor, () => fn(element));
      return previousValue;
    });
  }

  List<Widget> _makeSupportItemList(List<SystemConfiguration> systemConfigurations) {
    final List<Widget> widgets = [];
    final textStyle = TextStyle(
        color: Colors.primaryColor,
        fontFamily: Styles.defaultFont,
        fontSize: 15,
        fontWeight: FontWeight.w600
    );

    systemConfigurations.forEach((e) {
      if (e.key == "support.email") {
        final emailItem = _SupportItem(
            title: "Send us an Email",
            imageRes: 'res/drawables/ic_support_message_filled.svg',
            subTitle:  Text(e.value ?? "", style: textStyle).colorText(_makeSupportLinks(e.value ?? "", (value) => openUrl(Uri(
                scheme: "mailto",
                path: "$value",
                queryParameters: {
                  'subject': 'Hello Moniepoint',
                  'body':"Good day"
                }).toString())
            ), bold: false
            )
        );
        widgets.add(emailItem);
      }
      if (e.key == "support.phone") {
        final phoneItem = _SupportItem(
            title: "Give us a call",
            imageRes:'res/drawables/ic_support_phone.svg',
            subTitle:Text(e.value ?? "", style: textStyle).colorText(
                _makeSupportLinks(e.value ?? "", (value) => openUrl("tel:$value")),
                bold: false
            ));
        widgets.insert(0, phoneItem);
      }
      if (e.key == "support.whatsapp") {
        final phoneItem = _SupportItem(
            title:"Chat on Whatsapp",
            imageRes:'res/drawables/ic_support_whatsapp_filled.svg',
            subTitle: Text(e.value ?? "", style: textStyle).colorText(
                _makeSupportLinks(e.value ?? "", (value) => openUrl("https://api.whatsapp.com/send?phone=$value")),
                bold: false
            ));
        widgets.insert(1, phoneItem);
      }
    });

    return widgets.foldIndexed(<Widget>[], (index, List<Widget> previousValue, element) {
      previousValue.add(element);
      if(index < widgets.length - 1) {
        previousValue.add(SizedBox(height: 23));
        previousValue.add(Divider(height : 1, color: Colors.solidDarkBlue.withOpacity(0.12),));
        previousValue.add(SizedBox(height: 19));
      }
      return previousValue;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 21),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 0.7, color: Color(0XFF0357EE).withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
                color: Color(0XFF0E4FB1).withOpacity(0.12),
                offset: Offset(0,1),
                blurRadius: 2
            )
          ]
      ),
      child: StreamBuilder(
        stream: systemConfigStream,
        builder: (context, AsyncSnapshot<Resource<List<SystemConfiguration>>> a) {
          if(!a.hasData) return Container();
          if(a.hasData && (a.data is Loading && a.data?.data?.isEmpty == true)) return SupportShimmer();
          if(a.hasData && (a.data is Error && a.data?.data?.isEmpty == true || a.data?.data == null)) return Container();
          return Column(
            children: _makeSupportItemList(a.data?.data ?? []),
          );
        },
      ),
    );
  }
}

///_SupportItem
///
///
///
///
class _SupportItem extends StatelessWidget {

  _SupportItem({
    required this.title,
    required this.imageRes,
    required this.subTitle
  });

  final String title;
  final String imageRes;
  final Widget subTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          padding: EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Color(0XFF3272E1).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(imageRes, width: 50, height: 50,),
          ),
        ),
        SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
              style: TextStyle(
                color: Colors.darkBlue.withOpacity(0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(height: 6,),
            subTitle
          ],
        )
      ],
    );
  }
}
