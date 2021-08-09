//
//  LivelinessMethodHandler.swift
//  Moniepoint
//
//  Created by Paul Okeke on 29/07/2021.
//

import Foundation
import Flutter
import UIKit



class LivelinessMethodHandler : NSObject, FlutterStreamHandler {

    private let LIVELINESS_CHANNEL: String = "moniepoint.flutter.dev/liveliness"
    private let LIVELINESS_EVENT_CHANNEL = "moniepoint.flutter.dev/liveliness/events"
    private let LIVELINESS_REGISTRAR = "moniepoint.flutter.dev/liveliness/liveliness_test"
    
    private let controller: FlutterViewController
    private var livelinessDetector: CustomCamera2?
    private var eventSink: FlutterEventSink?
    weak private var registrar: FlutterPluginRegistrar?
    
    init(controller: FlutterViewController) {
        self.controller = controller
        self.registrar = self.controller.engine?.registrar(forPlugin: LIVELINESS_REGISTRAR)
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
        if(registrar == nil) {
            self.registrar = self.controller.engine?.registrar(forPlugin: LIVELINESS_REGISTRAR)
        }
        
        print("ARGUMENTS ==>>> \(call.arguments)")
        
        let texture: FlutterTextureRegistry = (registrar?.textures())!

        if let args = call.arguments as? Dictionary<String, Any>,
           let channelFrameSize = args["frameSize"] as? Dictionary<String?, Double?>?,
           let channelPreviewSize = args["previewSize"] as? Dictionary<String?, Double?>? {
            
            var frameSize: CGRect? = nil
            var previewSize: CGSize = CGSize(width:480, height:640)
            
            if(channelFrameSize != nil) {
                let left = channelFrameSize!["left"]
                let top = channelFrameSize!["top"]
                let right = channelFrameSize!["right"]
                let bottom = channelFrameSize!["bottom"]

                if((left != nil) && (top != nil) && (right != nil) && (bottom != nil)) {
                    frameSize = CGRect(
                        x: left!!,
                        y: (top ?? 0.0)!,
                        width: (right ?? 0.0)!,
                        height: (bottom ?? 0.0)!
                    )
                }
            }

            if(channelPreviewSize != nil) {
                let  width = channelPreviewSize!["width"]
                let height = channelPreviewSize!["height"]

                if(width != nil && height != nil) {
                    previewSize = CGSize(width: width!!, height: height!!)
                }
            }

            self.livelinessDetector = CustomCamera2(
                textureRegistry: texture, previewSize: previewSize, frameSize: frameSize)
            
            livelinessDetector?.startCamera()
            
            let cameraId = texture.register(self.livelinessDetector!)
            
            livelinessDetector?.setFrameAvailableHander {
                texture.textureFrameAvailable(cameraId)
            }
            
            print("CameraID => \(cameraId )")
            reply(["cameraId": cameraId])
        }
        else {
            
        }
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        livelinessDetector?.startListening(eventHandler: { CameraMotionEvent in
            print("This is the Event \(CameraMotionEvent)")
            switch CameraMotionEvent {
            case .NoFaceDetectedEvent:
                self.eventSink?([
                    "event_type":"NoFaceDetectedEvent",
                    "event_data" :""
                ])
                return
            case .FirstCaptureEvent(path: let path):
                self.eventSink?([
                    "event_type":"FirstCaptureEvent",
                    "event_data" :path?.path
                ])
                return
            case .MotionDetectedEvent(path: let path):
                self.eventSink?([
                    "event_type":"MotionDetectedEvent",
                    "event_data" :path?.path
                ])
                return
            case .NoMotionDetectedEvent(path: let path):
                self.eventSink?([
                    "event_type": "NoMotionDetectedEvent",
                    "event_data": ""
                ])
                return
            case .FaceDetectedEvent:
                self.eventSink?([
                    "event_type":"FaceDetectedEvent",
                    "event_data" :""
                ])
                return
            case .DetectedFaceRectEvent(faceRect: let faceRect):
                self.eventSink?([
                    "event_type":"DetectedFaceRectEvent",
                    "event_data" :"\(faceRect.minX),\(faceRect.minY),\(faceRect.maxX),\(faceRect.maxY)"
                ])
                return
            case .FaceOutOfBoundsEvent:
                self.eventSink?([
                    "event_type":"FaceOutOfBoundsEvent",
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
