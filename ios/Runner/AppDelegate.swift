import UIKit
import Flutter
import GoogleMaps
import Amplify
import AmplifyPlugins
import AWSPredictionsPlugin
import AWSRekognition
import AWSPredictionsPlugin


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let LIVELINESS_CHANNEL: String = "moniepoint.flutter.dev/liveliness"
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    //For Flutter download manager TODO remove we don't use it
    //For google maps
    GMSServices.provideAPIKey("AIzaSyAZ4YHxMdQYIzvEepEUVYdFUILdCN3LxA8")
    self.initializeAmplify()
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    self.registerLiveliness(controller:controller)
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
    
  private func registerLiveliness(controller: FlutterViewController){
    let livelinessChannel = FlutterMethodChannel(name: LIVELINESS_CHANNEL, binaryMessenger: controller.binaryMessenger)
    
    guard let predictionPlugin = try? Amplify.Predictions.getPlugin(for: "awsPredictionsPlugin") as? AWSPredictionsPlugin else{
        print("Unable to create AWS Prediction Plugin")
        return
    }
    
    guard let awsRekognition = predictionPlugin.getEscapeHatch(key: .rekognition) as? AWSRekognition else {
        print("Unable to create AWSRekognition Plugin")
        return
    }
    
    livelinessChannel.setMethodCallHandler({(call: FlutterMethodCall, reply: @escaping FlutterResult) -> Void in
        if call.method != "analyzeImage" {
            return reply("")
        }
            
        guard let args = call.arguments else {
            return
        }
            
        let mainArgs = args as? [String: Any]
               
        let imageData = mainArgs!["imageByte"] as? FlutterStandardTypedData

        var mapResult: [String: Any] = [:]
        
        let request: AWSRekognitionDetectFacesRequest = AWSRekognitionDetectFacesRequest()
        let rekognitionImage: AWSRekognitionImage = AWSRekognitionImage()
        
        rekognitionImage.bytes = imageData?.data
        request.image = rekognitionImage
        request.attributes = ["ALL"]
        
        awsRekognition.detectFaces(request) { (response: AWSRekognitionDetectFacesResponse?, error: Error?) in
            guard error == nil else {
                mapResult["error"] = ["message" : error.debugDescription]
                return reply(mapResult)
            }
            
            guard response != nil else { return reply(nil) }
            
            guard let faces = response?.faceDetails else {
                mapResult["facenotdetected"] = ["value" : true, "confidence" : 100.0]
                return reply(mapResult)
            }
            
            if faces.isEmpty {
                mapResult["facenotdetected"] = ["value" : true, "confidence" : 100.0]
                reply(mapResult)
                return
            }
            
            mapResult["numberOfFaces"] = faces.count

            for face in faces {
                guard let pose = face.pose else { continue }
                
                mapResult["pose"] = [
                    "yaw" : pose.yaw,
                    "roll" : pose.roll,
                    "pitch" : pose.pitch,
                ]
                
                mapResult["smile"] = [
                    "value": face.smile?.value,
                    "confidence": face.smile?.confidence,
                ]
                
                mapResult["mouthopen"] = [
                    "value": face.mouthOpen?.value,
                    "confidence": face.mouthOpen?.confidence,
                ]
                
                mapResult["sunglasses"] = [
                    "value": face.sunglasses?.value,
                    "confidence": face.sunglasses?.confidence,
                ]
                
                mapResult["eyeglasses"] = [
                    "value": face.eyeglasses?.value,
                    "confidence": face.eyeglasses?.confidence,
                ]
                
                mapResult["eyesopen"] = [
                    "value": face.eyesOpen?.value,
                    "confidence": face.eyesOpen?.confidence,
                ]
            }
            reply(mapResult)
            return
        }
    })
  }
}
