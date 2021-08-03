//
//  LivelinessMethodHandler.swift
//  Moniepoint
//
//  Created by Paul Okeke on 29/07/2021.
//

import Foundation
import Flutter


class LivelinessMethodHandler : NSObject, FlutterStreamHandler {

    let LIVELINESS_CHANNEL: String = "moniepoint.flutter.dev/liveliness"
    private let LIVELINESS_EVENT_CHANNEL = "moniepoint.flutter.dev/liveliness/events"
    let controller:FlutterViewController
    private var livelinessDetector: CustomCamera2?
    private var eventSink: FlutterEventSink?
    
    init(controller: FlutterViewController) {
        self.controller = controller
        
    }
    
    func registerLivelinessMethodHandler() {
        let livelinessChannel = FlutterMethodChannel(name:LIVELINESS_CHANNEL,
                                                     binaryMessenger:controller.binaryMessenger)
        let livelinessEventChannel = FlutterEventChannel(name: LIVELINESS_EVENT_CHANNEL,
                                                         binaryMessenger: controller.binaryMessenger)
        
        livelinessEventChannel.setStreamHandler(self)
        
        livelinessChannel.setMethodCallHandler { (call: FlutterMethodCall, reply:@escaping FlutterResult) in
            var mapResult : [String: Any?] = [:]
            print("Calling Method -> \(call.method)")
            do {
                switch call.method {
                case "create":
                    self.initializeCamera(call: call, reply: reply)
                    return
                case "close":
                    self.livelinessDetector?.stop()
                    reply([:])
                    return
                case "pause":
                    self.livelinessDetector?.pauseListening()
                    reply([:])
                    return
                case "resume":
                    self.livelinessDetector?.resumeListening()
                    reply([:])
                    return
                case "begin_capture":
                    self.livelinessDetector?.beginCapture()
                    reply([:])
                    return
                case "end_capture":
                    self.livelinessDetector?.endCapture()
                    reply([:])
                    return
                case "restart":
                    self.livelinessDetector?.reset()
                    reply([:])
                    return
                case "start":
                    reply([:])
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
        let texture: FlutterTextureRegistry = (registrar?.textures())!
        self.livelinessDetector = CustomCamera2(textureRegistry: texture)
        livelinessDetector?.startCamera()
        let cameraId = texture.register(livelinessDetector!)
        livelinessDetector?.setFrameAvailableHander {
            texture.textureFrameAvailable(cameraId)
        }
        print("CameraID => \(cameraId )")
        reply(["cameraId": cameraId])
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        print("Recevied an event.......=====================.........")
        livelinessDetector?.startListening(eventHandler: { CameraMotionEvent in
            print("This is the Event \(CameraMotionEvent)")
            switch CameraMotionEvent {
            case .NoFaceDetectedEvent:
                self.eventSink?([
                    "event_type":"NoFaceDetectedEvent",
                    "file_path" :""
                ])
                return
            case .FirstCaptureEvent(path: let path):
                self.eventSink?([
                    "event_type":"FirstCaptureEvent",
                    "file_path" :path?.path
                ])
                return
            case .MotionDetectedEvent(path: let path):
                self.eventSink?([
                    "event_type":"MotionDetectedEvent",
                    "file_path" :path?.path
                ])
            case .NoMotionDetectedEvent(path: let path):
                self.eventSink?([
                    "event_type":"NoMotionDetectedEvent",
                    "file_path" :""
                ])
            case .FaceDetectedEvent:
                self.eventSink?([
                    "event_type":"FaceDetectedEvent",
                    "file_path" :""
                ])
                return
            }
        })
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    
}
