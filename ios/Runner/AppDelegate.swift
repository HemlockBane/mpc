import UIKit
import Flutter
import GoogleMaps
import LocalAuthentication
import Firebase


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let LIVELINESS_CHANNEL: String = "moniepoint.flutter.dev/liveliness"
  let BIOMETRICS_CHANNEL: String = "moniepoint.flutter.dev/biometric"

    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    FirebaseApp.configure()
    
    GeneratedPluginRegistrant.register(with: self)
    
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*5))

    //For google maps
    GMSServices.provideAPIKey("AIzaSyBaWvpAZu9ODUJqNMpJ_ycud2BBh-D2HGE")
//    GMSServices.provideAPIKey("AIzaSyAZ4YHxMdQYIzvEepEUVYdFUILdCN3LxA8")

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    BiometricMethodHandler(controller: controller).registerBiometricsMethodHandler()
    LivelinessMethodHandler(controller: controller).registerLivelinessMethodHandler()
    DeviceManagerHandler(controller: controller).registerDeviceManagerHandler()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    

}
