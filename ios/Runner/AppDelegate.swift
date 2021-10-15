import UIKit
import Flutter
import GoogleMaps
import LocalAuthentication


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let LIVELINESS_CHANNEL: String = "moniepoint.flutter.dev/liveliness"
  let BIOMETRICS_CHANNEL: String = "moniepoint.flutter.dev/biometric"

    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
//    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))

    //For google maps
    GMSServices.provideAPIKey("AIzaSyAZ4YHxMdQYIzvEepEUVYdFUILdCN3LxA8")
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    BiometricMethodHandler(controller: controller).registerBiometricsMethodHandler()
    LivelinessMethodHandler(controller: controller).registerLivelinessMethodHandler()
    DeviceManagerHandler(controller: controller).registerDeviceManagerHandler()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    

}
