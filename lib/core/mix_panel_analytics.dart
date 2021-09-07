import 'package:mixpanel_flutter/mixpanel_flutter.dart';


final mixpanelToken = "3d3ad53a6b34a934569e8a30a3190b61";

class MixpanelManager {

  static Mixpanel? _instance;

  static Future<Mixpanel> initAsync() async {
    if (_instance == null) {
      _instance = await Mixpanel.init(mixpanelToken,
        optOutTrackingDefault: false);
    }
    return _instance!;
  }

}