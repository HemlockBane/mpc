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
    case FirstCaptureEvent(path: URL?)
    case MotionDetectedEvent(path: URL?)
    case NoMotionDetectedEvent(path: URL?)
    case DetectedFaceRectEvent(faceRect: CGRect)
    case FaceOutOfBoundsEvent
}


class CustomCamera2: NSObject, FlutterTexture, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let captureSession = AVCaptureSession()
    private let motionDetector = CaptureViewController()
    private let faceDectector: CIDetector!
    private var eventHandler: (_:CameraMotionEvent)->Void = {(_) in }
    private var onFrameAvailable: ()->Void = {}
    
    private var hasCapturedFirstImage: Bool = false
    private var hasCapturedMotionImage: Bool = false
    private var _pauseListening: Bool = false
    private var _beginCapture: Bool = false
    
    private var faceRect: CGRect?
    
    private var processing: Bool = false
    
    private let textureRegistry: FlutterTextureRegistry
    private(set) var latestPixelBuffer: CVPixelBuffer?
    
    private let previewSize: CGSize
    private var frameSize: CGRect?
    
    
    init(textureRegistry: FlutterTextureRegistry, previewSize: CGSize, frameSize: CGRect?) {
        self.textureRegistry = textureRegistry
        self.previewSize = previewSize
        self.frameSize = frameSize
        
        self.faceDectector = CIDetector.init(
            ofType: CIDetectorTypeFace,
            context: nil,
            options: [CIDetectorAccuracy:CIDetectorAccuracyHigh]
        )
        let preset: AVCaptureSession.Preset = .vga640x480
        captureSession.sessionPreset = preset
    }
    
    
    func pauseListening() {
        self._pauseListening = true
    }
    
    func resumeListening() {
        self._pauseListening = false
    }
    
    func beginCapture() { self._beginCapture = true }
    func endCapture() { self._beginCapture = false }

    func reset() {
        hasCapturedFirstImage = false
        hasCapturedMotionImage = false
        self.endCapture()
        self._pauseListening = false
        //eyeMidPoint.set(0f, 0f)
    }
    
    private func addCameraInput() {
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)!
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }
    
    private func addCameraOutput() {
        let outputDevice = AVCaptureVideoDataOutput()
        outputDevice.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        outputDevice.alwaysDiscardsLateVideoFrames = true
        outputDevice.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        let input = captureSession.inputs.first
        
        let aPorts = input?.ports
        
        if(aPorts != nil) {
            let connection = AVCaptureConnection(inputPorts: aPorts!, output: outputDevice)
        
            if(connection.isVideoOrientationSupported == true) {
                connection.isVideoMirrored = true
                connection.videoOrientation = .portrait
            }
            self.captureSession.addOutputWithNoConnections(outputDevice)
            self.captureSession.addConnection(connection)
        }
    }
    
    func setFrameAvailableHander(handler: @escaping ()->Void) {
        self.onFrameAvailable = handler
    }
    
    func startListening(eventHandler: @escaping(_: CameraMotionEvent)->Void) {
        self.eventHandler = eventHandler
    }
    
    private func initializeIO() {
        addCameraInput()
        addCameraOutput()
        print("Input and Output ADded")
    }

    func startCamera() {
        self.initializeIO()
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func stop() {
        self.reset()
        self.captureSession.stopRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Capturing DidDrop")
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        latestPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        
        onFrameAvailable()

        if(_pauseListening || processing) {
            return
        }
        
        let cImage = CIImage.init(cvImageBuffer: latestPixelBuffer!)
        //first lets check if we can detect faces

        processing = true;
        
        
        DispatchQueue.global().async {
            let passesGeneralProblems = self.validateGeneralProblems(cImage: cImage)
            
            if(!self._beginCapture){
                self.processing = false;
                return
            }
            
            if(!self.hasCapturedFirstImage && passesGeneralProblems) {
                let uiImage = self.motionDetector.image(from: sampleBuffer, orientation: UIImage.Orientation.up)
                self.motionDetector.createTemplate(uiImage)
                let savedImage = self.saveImageToDisk(uiImage: uiImage)
                self.hasCapturedFirstImage = true
                self.eventHandler(.FirstCaptureEvent(path: savedImage))
            } else if(self.hasCapturedFirstImage && passesGeneralProblems){
                let uiImage = self.motionDetector.image(from: sampleBuffer, orientation: UIImage.Orientation.up)
                let motionDetected = self.motionDetector.motionDetection(uiImage)
                if(motionDetected) {
                    self.pauseListening()
                    let savedImage = self.saveImageToDisk(uiImage: uiImage, prefix: "MOTION_CAP_")
                    self.hasCapturedMotionImage = true
                    self.eventHandler(.MotionDetectedEvent(path: savedImage))
                } else {
                    self.eventHandler(.NoMotionDetectedEvent(path: nil))
                }
            }
            self.processing = false;
        }
    }
    
    func saveImageToDisk(uiImage: UIImage?, prefix: String = "FIRST_CAP_")-> URL? {
        if(uiImage == nil) { return nil }
        let temp = FileManager.default.temporaryDirectory
        let random = UUID().uuidString
        if let data = uiImage?.jpegData(compressionQuality: 0.75) {
            let fileName = temp.appendingPathComponent("\(prefix)\(random).JPG")
            try? data.write(to: fileName)
            return fileName
        }
        return nil
    }
    
    func validateGeneralProblems(cImage: CIImage) -> Bool {
        let detectedFace = isFaceDetected(ciImage: cImage)
        
        if(!detectedFace) {
            self.eventHandler(.NoFaceDetectedEvent)
            return false
        }
        
        //Check if the face is within frameSize
        if(!isFaceWithinFrame(cImage: cImage)) {
            self.eventHandler(.FaceOutOfBoundsEvent)
            return false
        }
        
        //Check brigthness
        
        self.eventHandler(.FaceDetectedEvent)
        return true
    }
    
    func adjustImageOrientation() {
        
    }
    
    func isFaceWithinFrame(cImage: CIImage) -> Bool{
        if(frameSize == nil) {return true}
        let width = cImage.extent.width
        let height = cImage.extent.height
        
        let screenScale = previewSize.width / width
        
        eventHandler(.DetectedFaceRectEvent(faceRect: faceRect!))
        Thread.sleep(forTimeInterval: 0.4)
        
        let faceLeft = faceRect!.minX * screenScale
        let faceTop = faceRect!.minY * screenScale
        let faceRight = faceRect!.maxX * screenScale
        let faceBottom = faceRect!.maxY * screenScale
        
        if(faceLeft < frameSize!.minX
                    || faceRight > frameSize!.maxX
                    || faceTop < frameSize!.minY
                    || faceBottom > frameSize!.maxY) {
                    print("FaceOutOfBounds => \(faceLeft), \(faceTop), \(faceRight), \(faceBottom)")
                    return false
        }
        
        return true
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
            faceRect = CIFeature.bounds
        }
        
        return true
    }
    
    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        print("Calling CopyPixelBuffer <<<---->>> IIOOOSSS")
        let pixelBuffer = latestPixelBuffer
//        while !OSAtomicCompareAndSwapPtrBarrier(&pixelBuffer, nil, &(UnsafeMutableRawPointer **)latestPixelBuffer) {
//            pixelBuffer = latestPixelBuffer
//        }
        if(pixelBuffer == nil) {
            return nil
        }
        print("Calling CopyPixelBuffer <<<---->>> WITH VALUE BRUVVVVV")
        return Unmanaged.passRetained(pixelBuffer!)
    }
    
    deinit {
        if latestPixelBuffer != nil {
            latestPixelBuffer = nil
        }
   }

}
