//
//  CustomCamera2.swift
//  Moniepoint
//
//  Created by Paul Okeke on 29/07/2021.
//

import Foundation
import AVFoundation


class CustomCamera2: NSObject, FlutterTexture, AVCaptureVideoDataOutputSampleBufferDelegate, FlutterStreamHandler {
    
    private let captureSession = AVCaptureSession()
    
    private let textureRegistry: FlutterTextureRegistry
    private(set) var latestPixelBuffer: CVPixelBuffer?
    
    init(textureRegistry: FlutterTextureRegistry) {
        self.textureRegistry = textureRegistry
        
        var preset: AVCaptureSession.Preset = .medium
        captureSession.sessionPreset = preset
    }
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.videoGravity = .resizeAspect
        return preview
    }()
    

    private func addCameraInput() {
        let device = AVCaptureDevice.default(for: .video)!
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        var newBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
//        var old = latestPixelBuffer
////        var pointer = UnsafeMutableBufferPointer
//        while !OSAtomicCompareAndSwapPtrBarrier(&old, &newBuffer, latestPixelBuffer) {
//                 old = latestPixelBuffer
//             }
//             if old != nil {
//
//             }
    }
    
    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        var pixelBuffer = latestPixelBuffer
        let data = pixelBuffer
        while !OSAtomicCompareAndSwapPtrBarrier(&pixelBuffer, nil, latestPixelBuffer) {
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
