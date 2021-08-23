import UIKit
import Flutter
import GoogleMaps
import Amplify
import AmplifyPlugins
import AWSPredictionsPlugin
import AWSRekognition
import AWSPredictionsPlugin
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
    //For Flutter download manager TODO remove we don't use it
    //For google maps
    GMSServices.provideAPIKey("AIzaSyAZ4YHxMdQYIzvEepEUVYdFUILdCN3LxA8")
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    BiometricMethodHandler(controller: controller).registerBiometricsMethodHandler()
    LivelinessMethodHandler(controller: controller).registerLivelinessMethodHandler()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
       
  private func initializeAmplify() {
    do {
        Amplify.Logging.logLevel = LogLevel.info
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.add(plugin: AWSPredictionsPlugin())
        try Amplify.configure()
        print("Amplify configured with Auth and Predictions plugins")
    } catch {
        print("Failed to initialize Amplify with \(error)")
    }
  }
}
