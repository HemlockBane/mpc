//
//  CustomCamera2.swift
//  Moniepoint
//
//  Created by Paul Okeke on 29/07/2021.
//

import Foundation
import AVFoundation
import UIKit

enum CameraMotionEvent {
    case FaceDetectedEvent
    case NoFaceDetectedEvent
}


class CustomCamera2: NSObject, FlutterTexture, AVCaptureVideoDataOutputSampleBufferDelegate, FlutterStreamHandler {
    
    private let captureSession = AVCaptureSession()
    private let motionDetector = CaptureViewController()
    private let faceDectector: CIDetector!
    
    private let textureRegistry: FlutterTextureRegistry
    private(set) var latestPixelBuffer: CVPixelBuffer?
    
    init(textureRegistry: FlutterTextureRegistry) {
        self.textureRegistry = textureRegistry
        self.faceDectector = CIDetector.init(
            ofType: CIDetectorTypeFace,
            context: nil,
            options: [CIDetectorAccuracy:CIDetectorAccuracyLow]
        )
        let preset: AVCaptureSession.Preset = .medium
        captureSession.sessionPreset = preset
    }
    
//    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
//        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
//        preview.videoGravity = .resizeAspect
//        return preview
//    }()
    

    private func addCameraInput() {
        let device = AVCaptureDevice.default(for: .video)!
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }
    
    private func addCameraOutput() {
        let outputDevice = AVCaptureVideoDataOutput()
        outputDevice.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        outputDevice.alwaysDiscardsLateVideoFrames = true
        outputDevice.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        self.captureSession.addOutput(outputDevice)
    }
    
    private func initalizeIO() {
        addCameraInput()
        addCameraOutput()
        print("Input and Output ADded")
    }

    func startCamera() {
        self.initalizeIO()
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Capturing DidDrop")
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let cImage = CIImage.init(cvImageBuffer: imageBuffer)
        //first lets check if we can detect faces
        //    UIImageOrientation imageOrientation = UIImageOrientationRight;
        //let deviceOrientation = UIDevice.current.orientation
        
        validateGeneralProblems(cImage: cImage)
    }
    
    func validateGeneralProblems(cImage: CIImage) -> Bool {
        let detectedFace = isFaceDetected(ciImage: cImage)
        
        if(!detectedFace) {
            
        }
        
        return true
    }
    
    func adjustImageOrientation() {
        
    }
    
    func isFaceDetected(ciImage: CIImage) -> Bool {
        let _ : [String:Any] = [:]
//        numberWithInt
        let features = self.faceDectector.features(
            in: ciImage,
            options: [
                "forKey": CIDetectorImageOrientation,
            ]
        )

        if (features.count == 0) {
            print("No Face Detected Here!!!!")
            return false
        }
        
        features.forEach { CIFeature in
            print("Your face bounds is \(CIFeature.bounds)")
        }
        
        return true
    }
    
    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        print("Calling CopyPixelBuffer --->>> IIOOOSSS")
        var pixelBuffer = latestPixelBuffer
        while !OSAtomicCompareAndSwapPtrBarrier(&pixelBuffer, nil, nil) {
            pixelBuffer = latestPixelBuffer
        }
        return Unmanaged.passRetained(pixelBuffer!)
    }
    
    
    deinit {
        if latestPixelBuffer != nil {

        }
   }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }

}
//extension CVPixelBuffer {
//    func castToCPointer<T>() -> T {
//        let mem = UnsafeMutablePointer<T>.allocate(capacity: 1)
//        _ = UnsafeMutableBufferPointer<CVPixelBuffer>(sta)
//        //self.(to: UnsafeMutableBufferPointer(start: mem, count: 1))
//        let val =  mem.move()
////        mem.deallocate(capacity: 1)
//        return val
//    }
//}
