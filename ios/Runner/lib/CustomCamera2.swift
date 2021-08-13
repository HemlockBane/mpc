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
    case FaceDetectedEvent(exposure: Double? = nil)
    case NoFaceDetectedEvent
    case FirstCaptureEvent(path: URL?)
    case MotionDetectedEvent(path: URL?)
    case NoMotionDetectedEvent(path: URL?)
    case DetectedFaceRectEvent(faceRect: CGRect)
    case FaceOutOfBoundsEvent(faceRect: CGRect? = nil)
    case FaceTooFarEvent(faceRect: CGRect?)
    case ImageUnderExposed(exposure: Double)
    case ImageOverExposed(exposure: Double)
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
            
            let adjustedImage = self.adjustImageOrientation(ciImage: cImage)
            
            let passesGeneralProblems = self.validateGeneralProblems(cImage: adjustedImage)
            
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
            self.eventHandler(.FaceOutOfBoundsEvent())
            return false
        }
        
        //Check if the face is too far
        if(isFaceTooFarFromFrame(imageWidth: cImage.extent.width)) {
            self.eventHandler(.FaceTooFarEvent(faceRect: faceRect))
            return false
        }
        
        let (exposureState, level) = isExposureWithinRange(ciImage: cImage)
        
        if(exposureState == -1) {
            self.eventHandler(.ImageUnderExposed(exposure: level))
            return false
        }
        
        if(exposureState == 1) {
            self.eventHandler(.ImageOverExposed(exposure: level))
            return false
        }
        
        //Check brigthness
        self.eventHandler(.FaceDetectedEvent(exposure: level))
        return true
    }
    
    func adjustImageOrientation(ciImage: CIImage) -> CIImage{
        let input = captureSession.inputs.first as? AVCaptureDeviceInput
        if(input?.device.position == .front){
            return ciImage.oriented(.downMirrored)
        }
        return ciImage
    }
    
    private func isExposureWithinRange(ciImage: CIImage) -> (isValid:Int, level: Double){
        //guard let ptr = CFDataGetBytePtr(ciImage) else {return false}
        let context = CIContext.init(options: nil)
        print("Inside Exposure Function!!!!")
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent),
              let data = cgImage.dataProvider?.data,
              let bytes = CFDataGetBytePtr(data) else {
            print("Failed to get Exposure Values")
            return (0, 0.0)
        }
        
        let x = Int(ciImage.extent.width - 1)
        let y = Int(ciImage.extent.height - 1)
        
        let numberOfChannels = 3//r,g,b
        let pixelData =  ((Int(ciImage.extent.width) * y) + x) * numberOfChannels
        
        let r = CGFloat(bytes[pixelData])
        let g = CGFloat(bytes[pixelData + 1])
        let b = CGFloat(bytes[pixelData + 2])
                
        let perceivedLight = (r * 0.299) + (0.587 * g) + (0.114 * b)
        
        let min = CGFloat(90)
        let max = CGFloat(220)
        
        if(perceivedLight < min) {
            return (-1, Double(perceivedLight))
        }
        
        if(perceivedLight > max) {
            return (1, Double(perceivedLight))
        }
        
        return (0, Double(perceivedLight))
    }
    
    private func isFaceTooFarFromFrame(imageWidth: CGFloat) -> Bool {
        if(frameSize == nil) {return false}
        
        let screenScale = previewSize.width / imageWidth

        let faceLeft = faceRect!.minX * screenScale
        let faceRight = faceRect!.maxX * screenScale

        let frameScale = (faceRight - faceLeft) / frameSize!.width
        if(frameScale < 0.5) {
            return true
        }
        return false
    }
    
    private func isFaceWithinFrame(cImage: CIImage) -> Bool{
        if(frameSize == nil) {return true}
        let width = cImage.extent.width
        
        let widthScale = previewSize.width / width
        
        let insetTop = (faceRect!.minY * 1.3) - faceRect!.minY
        
        faceRect = faceRect?.inset(by: UIEdgeInsets.init(top: -insetTop, left: 0, bottom: 0, right: 0))
        
        eventHandler(.DetectedFaceRectEvent(faceRect: faceRect!))
        Thread.sleep(forTimeInterval: 0.4)
        
        let faceLeft = faceRect!.minX * widthScale
        let faceTop = faceRect!.minY * widthScale
        let faceRight = faceRect!.maxX * widthScale
        let faceBottom = faceRect!.maxY * widthScale
        
        if(faceLeft < frameSize!.minX
                    || faceRight > frameSize!.maxX
                    || faceTop < frameSize!.minY
                    || faceBottom > frameSize!.maxY) {
                    return false
        }
        
        return true
    }
    
    func isFaceDetected(ciImage: CIImage) -> Bool {
        let features = self.faceDectector.features(
            in: ciImage,
            options: [CIDetectorImageOrientation: 4]
        )

        if (features.count == 0) {
            print("No Face Detected Here!!!!")
            return false
        }
        
        features.forEach { CIFeature in
            faceRect = CIFeature.bounds
        }
        
        return true
    }
    
    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        let pixelBuffer = latestPixelBuffer
        if(pixelBuffer == nil) {
            return nil
        }
        return Unmanaged.passRetained(pixelBuffer!)
    }
    
    deinit {
        if latestPixelBuffer != nil {
            latestPixelBuffer = nil
        }
   }

}
