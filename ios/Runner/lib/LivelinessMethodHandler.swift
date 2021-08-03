//
//  LivelinessMethodHandler.swift
//  Moniepoint
//
//  Created by Paul Okeke on 29/07/2021.
//

import Foundation
import Flutter


struct LivelinessMethodHandler {
    
    let LIVELINESS_CHANNEL: String = "moniepoint.flutter.dev/liveliness"
    let controller:FlutterViewController
    
    init(controller: FlutterViewController) {
        self.controller = controller
    }
    
    func registerLivelinessMethodHandler() {
        let livelinessChannel = FlutterMethodChannel(name:LIVELINESS_CHANNEL,
                                                     binaryMessenger:controller.binaryMessenger)
        
        livelinessChannel.setMethodCallHandler { (call: FlutterMethodCall, reply:@escaping FlutterResult) in
            var mapResult : [String: Any?] = [:]
            do {
                switch call.method {
                case "create":
                    initializeCamera(call: call, reply: reply)
                    return
                default:
                    return
                }
            } catch {
                print("Unexpected Error: \(error)")
            }
        }
    }
    
    func initializeCamera(call: FlutterMethodCall, reply:@escaping FlutterResult) {
        print("Calling initialize cameraaooooo")
        weak var registrar = controller.engine?.registrar(forPlugin: "test")
        let texture:FlutterTextureRegistry = (registrar?.textures())!
        let camera = CustomCamera2(textureRegistry: texture)
        camera.startCamera()
        let cameraId = texture.register(camera)
        print("CameraID => \(cameraId ?? -1)")
        reply(["cameraId": cameraId])
    }
}
