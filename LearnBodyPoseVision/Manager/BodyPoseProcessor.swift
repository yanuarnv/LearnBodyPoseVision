//
//  Vision.swift
//  LearnBodyPoseVision
//
//  Created by yanuar nauval ardian on 16/09/24.
//

import Vision
import CoreImage


class BodyPoseProcessor {
    
    let bodyPoseRequest = VNDetectHumanBodyPoseRequest()
    
    func processBodyPoseResults(pixelBuffer:CVImageBuffer,completion:([VNHumanBodyPoseObservation.JointName: CGPoint])->Void) throws{
        
        let handler = VNImageRequestHandler(ciImage: CIImage(cvPixelBuffer: pixelBuffer), orientation: .leftMirrored)
        
        do{
            try handler.perform([bodyPoseRequest])
        }catch {
            print("error \(error)")
        }
        
        guard let observation = bodyPoseRequest.results?.first as? VNHumanBodyPoseObservation else { return }
        
        let jointNames: [VNHumanBodyPoseObservation.JointName] = [
            .nose,.leftShoulder, .rightShoulder,
            .leftElbow, .rightElbow, .leftWrist, .rightWrist, .leftHip, .rightHip,
            .leftKnee, .rightKnee, .leftAnkle, .rightAnkle
        ]
        
        var detectedParts: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
        
        for jointName in jointNames {
            guard let point = try? observation.recognizedPoint(jointName) else { continue }
            if point.confidence > 0{
                detectedParts[jointName] = CGPoint(x: CGFloat(point.location.x), y: CGFloat(1 - point.location.y))
            }
        }
        
        completion(detectedParts)
        
    }
}
