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
            
        }
    }
    
    func initializeCamera(call: FlutterMethodCall, reply:@escaping FlutterResult) {
        weak var registrar = controller.registrar(forPlugin: "liveliness-camera")
        let texture = registrar?.textures()
        
//        let cameraId: Int64 = texture?.register()
    }
}
