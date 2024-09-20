//
//  Camera.swift
//  LearnBodyPoseVision
//
//  Created by yanuar nauval ardian on 16/09/24.
//

import AVFoundation
import Vision


@Observable
class CameraManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var detectedBodyParts: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
    
    @ObservationIgnored let session = AVCaptureSession()
    @ObservationIgnored let output = AVCaptureVideoDataOutput()
    @ObservationIgnored let processor = BodyPoseProcessor()
    
    override init() {
        super.init()
        setupCamera()
    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.startSession()
                    }
                }
            }
        default:
            break
        }
    }
    
    private func setupCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(output) {
                session.addOutput(output)
                output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            }
        } catch {
            print("Failed to set up camera: \(error)")
        }
    }
    
    func startSession() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
         do{
             try processor.processBodyPoseResults(pixelBuffer: pixelBuffer){ result in
               detectedBodyParts = result
            }
         }catch{
             print("camera manager:\(error)")
         }
    }
    
}
