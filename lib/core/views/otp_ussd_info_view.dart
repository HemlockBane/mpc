import 'dart:convert';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/ussd_configuration.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

import '../styles.dart';
import '../tuple.dart';

class OtpUssdInfoView extends StatelessWidget{

  final String ussdKey;
  final String? defaultCode;

  static Tuple<String, String> getUSSDDialingCodeAndPreview(String ussdKey, {String defaultCode = ""}) {
    String? value = PreferenceUtil.getValueForLoggedInUser(PreferenceUtil.USSD_CONFIG);
    List<dynamic> savedConfig = (value != null) ? jsonDecode(value) : [];
    List<USSDConfiguration> configs = savedConfig.map((e) => USSDConfiguration.fromJson(e)).toList();
    final List<USSDConfiguration>? mainConfig = configs.where((element) => element.name == ussdKey).toList();
    return Tuple(_getDialingCode(mainConfig, defaultCode: defaultCode), _getPreviewCode(mainConfig, defaultCode: defaultCode));
  }

  static String _getDialingCode(List<USSDConfiguration>? configs, {String defaultCode = ""}) {
    if (configs != null && configs.isNotEmpty == true) {
      final configuration = configs.first;
      final baseCode = configuration.baseCode;
      final body = configuration.body;
      return "*$baseCode*$body${Uri.encodeComponent("#")}";
    }
    return "${defaultCode.replaceAll("#", Uri.encodeComponent("#"))}";
  }


  static String _getPreviewCode(List<USSDConfiguration>? configs, {String defaultCode = ""}) {
    if(configs!= null && configs.isNotEmpty == true) {
      final configuration = configs.first;
      return configuration.preview ?? "${defaultCode.replaceAll("#", Uri.encodeComponent("#"))}";
    }
    return defaultCode;
  }


  OtpUssdInfoView(this.ussdKey, {this.defaultCode});

  @override
  Widget build(BuildContext context) {
    final Tuple<String, String> codes = getUSSDDialingCodeAndPreview(ussdKey, defaultCode: this.defaultCode??"");

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          SvgPicture.asset('res/drawables/ic_info.svg'),
          SizedBox(width: 14),
          Expanded(child: Text('Didn’t get a code? Dial ${codes.second} to get an OTP',
              style: TextStyle(
                  fontFamily: Styles.defaultFont,
                  color: Colors.colorPrimaryDark,
                  fontWeight: FontWeight.normal,
                  fontSize: 14))
              .colorText({
            codes.second: Tuple(
                Colors.primaryColor,
                    () => dialNumber("tel:${codes.first}"))
          }))
        ],
      ),
    );
  }

}