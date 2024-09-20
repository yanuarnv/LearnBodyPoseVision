//
//  SkeletonBodyView.swift
//  LearnBodyPoseVision
//
//  Created by yanuar nauval ardian on 16/09/24.
//

import SwiftUI
import Vision



struct SkeletonBodyView: View {
    let bodyParts: [VNHumanBodyPoseObservation.JointName: CGPoint]
    
    // Define the connections between body parts (joints)
    let bodyPartConnections: [(VNHumanBodyPoseObservation.JointName, VNHumanBodyPoseObservation.JointName)] = [
        (.leftShoulder, .leftElbow),
        (.leftElbow, .leftWrist),
        (.rightShoulder, .rightElbow),
        (.rightElbow, .rightWrist),
        (.leftShoulder, .rightShoulder),
        (.leftHip, .leftKnee),
        (.leftKnee, .leftAnkle),
        (.rightHip, .rightKnee),
        (.rightKnee, .rightAnkle),
        (.leftHip, .rightHip),
        (.nose, .leftEye),
        (.nose, .rightEye),
        (.leftEye, .leftEar),
        (.rightEye, .rightEar)
    ]
    
    func calculateAngle(shoulder: CGPoint, elbow: CGPoint, wrist: CGPoint) -> CGFloat {
        let upperArmVector = CGVector(dx: elbow.x - shoulder.x, dy: elbow.y - shoulder.y)
        let forearmVector = CGVector(dx: wrist.x - elbow.x, dy: wrist.y - elbow.y)
        
        let dotProduct = upperArmVector.dx * forearmVector.dx + upperArmVector.dy * forearmVector.dy
        let magnitudeUpperArm = sqrt(upperArmVector.dx * upperArmVector.dx + upperArmVector.dy * upperArmVector.dy)
        let magnitudeForearm = sqrt(forearmVector.dx * forearmVector.dx + forearmVector.dy * forearmVector.dy)
        
        let cosTheta = dotProduct / (magnitudeUpperArm * magnitudeForearm)
        let angleInRadians = acos(cosTheta)
        
        return angleInRadians * (180 / .pi) // Convert to degrees
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                // Draw lines connecting body parts
                if let shoulder = bodyParts[.rightShoulder],
                   let elbow = bodyParts[.rightElbow],
                   let wrist = bodyParts[.rightWrist] {
                    
                    
                    // Kamu bisa menghitung sudut antara tiga poin ini
                    Text("\(calculateAngle(shoulder: shoulder, elbow: elbow, wrist: wrist))")
                }
                if let shoulder = bodyParts[.rightShoulder],
                   let elbow = bodyParts[.rightElbow],
                   let wrist = bodyParts[.rightWrist]{
                
                    ForEach(Array(bodyPartConnections.indices), id: \.self){ index in
                        
                        if bodyPartConnections[index].0 == .rightShoulder && bodyPartConnections[index].1 == .rightElbow{
                            Path { path in
                                
                                if let startPoint = bodyParts[bodyPartConnections[index].0],
                                   let endPoint = bodyParts[bodyPartConnections[index].1]{
                                    let startPosition = CGPoint(
                                        x: startPoint.x * geometry.size.width,
                                        y: startPoint.y * geometry.size.height
                                    )
                                    let endPosition = CGPoint(
                                        x: endPoint.x * geometry.size.width,
                                        y: endPoint.y * geometry.size.height
                                    )
                                    path.move(to: startPosition)
                                    path.addLine(to: endPosition)
                                }
                                
                            }
                            
                            .stroke(calculateAngle(shoulder: shoulder, elbow: elbow, wrist: wrist) < 21 ? .blue : .red,lineWidth: 2)
                        }
                        
                        if bodyPartConnections[index].0 == .rightElbow && bodyPartConnections[index].1 == .rightWrist {
                            Path { path in
                                
                                if let startPoint = bodyParts[bodyPartConnections[index].0],
                                   let endPoint = bodyParts[bodyPartConnections[index].1]{
                                    let startPosition = CGPoint(
                                        x: startPoint.x * geometry.size.width,
                                        y: startPoint.y * geometry.size.height
                                    )
                                    let endPosition = CGPoint(
                                        x: endPoint.x * geometry.size.width,
                                        y: endPoint.y * geometry.size.height
                                    )
                                    path.move(to: startPosition)
                                    path.addLine(to: endPosition)
                                }
                                
                            }
                            .stroke(calculateAngle(shoulder: shoulder, elbow: elbow, wrist: wrist) < 21 ? .blue : .red,lineWidth: 2)
                        }
                    }
                }
                //                Path { path in
                //                    for connection in bodyPartConnections {
                //                        if connection.0 == .leftShoulder && connection.1 == .leftElbow{
                //
                //                            if let startPoint = bodyParts[connection.0],
                //                               let endPoint = bodyParts[connection.1] {
                //                                let startPosition = CGPoint(
                //                                    x: startPoint.x * geometry.size.width,
                //                                    y: startPoint.y * geometry.size.height
                //                                )
                //                                let endPosition = CGPoint(
                //                                    x: endPoint.x * geometry.size.width,
                //                                    y: endPoint.y * geometry.size.height
                //                                )
                //                                path.move(to: startPosition)
                //                                path.addLine(to: endPosition)
                //                            }
                //
                //                        }else if let startPoint = bodyParts[connection.0],
                //                           let endPoint = bodyParts[connection.1] {
                //                            let startPosition = CGPoint(
                //                                x: startPoint.x * geometry.size.width,
                //                                y: startPoint.y * geometry.size.height
                //                            )
                //                            let endPosition = CGPoint(
                //                                x: endPoint.x * geometry.size.width,
                //                                y: endPoint.y * geometry.size.height
                //                            )
                //                            path.move(to: startPosition)
                //                            path.addLine(to: endPosition)
                //                        }
                //                    }
                //                }
                //                .stroke(Color.blue, lineWidth: 2) // Style the line
                
                // Draw circles at each body part (joint)
                ForEach(Array(bodyParts.keys), id: \.self) { joint in
                    if let position = bodyParts[joint] {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 20, height: 20)
                            .position(
                                x: position.x * geometry.size.width,
                                y: position.y * geometry.size.height
                            )
                        
                    }
                }
            }
        }
    }
}
