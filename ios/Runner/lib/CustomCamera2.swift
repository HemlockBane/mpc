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
    
    private var processing: Bool = false
    
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
    
    
    func pauseListening() {
        self._pauseListening = true
    }
    
    func resumeListening() {
        self._pauseListening = false
    }
    
    func beginCapture() { self._beginCapture = true }
    func endCapture() { self._beginCapture = false }

    func reset(){
        hasCapturedFirstImage = false
        hasCapturedMotionImage = false
        self.endCapture()
        self._pauseListening = false
        //eyeMidPoint.set(0f, 0f)
    }
//    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
//        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
//        preview.videoGravity = .resizeAspect
//        return preview
//    }()
    

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
        
        let input = captureSession.inputs[0]
        
        let aPorts = input.ports
        let connection = AVCaptureConnection(inputPorts: aPorts, output: outputDevice)
        
        if(connection.isVideoOrientationSupported == true) {
            print("We Are Setting up the portraint part")
            connection.isVideoMirrored = true
            connection.videoOrientation = .portrait
        }
        
        self.captureSession.addOutputWithNoConnections(outputDevice)
        self.captureSession.addConnection(connection)
    }
    
    func setFrameAvailableHander(handler: @escaping ()->Void) {
        self.onFrameAvailable = handler
    }
    
    func startListening(eventHandler: @escaping(_: CameraMotionEvent)->Void) {
        self.eventHandler = eventHandler
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

        if(_pauseListening || processing){
            return
        }
        
        
        let cImage = CIImage.init(cvImageBuffer: latestPixelBuffer!)
        //first lets check if we can detect faces
        //UIImageOrientation imageOrientation = UIImageOrientationRight;
        //let deviceOrientation = UIDevice.current.orientation
        
        processing = true;
        
        let passesGeneralProblems = validateGeneralProblems(cImage: cImage)
        
        if(!_beginCapture){
            processing = false;
            return
        }
        
        if(!hasCapturedFirstImage && passesGeneralProblems) {
            let uiImage = motionDetector.image(from: sampleBuffer, orientation: UIImage.Orientation.up)
            motionDetector.createTemplate(uiImage)
            let savedImage = saveImageToDisk(uiImage: uiImage)
            self.hasCapturedFirstImage = true
            self.eventHandler(.FirstCaptureEvent(path: savedImage))
        } else if(hasCapturedFirstImage && passesGeneralProblems){
            let uiImage = motionDetector.image(from: sampleBuffer, orientation: UIImage.Orientation.up)
            let motionDetected = motionDetector.motionDetection(uiImage)
            if(motionDetected) {
                pauseListening()
                let savedImage = saveImageToDisk(uiImage: uiImage, prefix: "MOTION_CAP_")
                self.hasCapturedMotionImage = true
                self.eventHandler(.MotionDetectedEvent(path: savedImage))
            }else {
                self.eventHandler(.NoMotionDetectedEvent(path: nil))
            }
        }
        processing = false;
    }
    
    func saveImageToDisk(uiImage: UIImage?, prefix: String = "FIRST_CAP_")-> URL? {
        if(uiImage == nil) { return nil }
        let temp = FileManager.default.temporaryDirectory
        let random = UUID().uuidString
        if let data = uiImage?.jpegData(compressionQuality: 0.8) {
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
        
        
        //Check brigthness
        
        self.eventHandler(.FaceDetectedEvent)
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
    
//    private var pointer:UnsafeMutableRawPointer? = UnsafeMutableRawPointer.allocate(byteCount: 90, alignment: 1)
    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        print("Calling CopyPixelBuffer <<<---->>> IIOOOSSS")
        var pixelBuffer = latestPixelBuffer
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

        }
   }

}
