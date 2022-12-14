

import 'package:url_launcher/url_launcher.dart';

void openUrl(String url) async {
  print(url);
  if(await canLaunch(url)) {
      await launch(url);
  }else {
    throw 'Could not launch $url';
  }
}