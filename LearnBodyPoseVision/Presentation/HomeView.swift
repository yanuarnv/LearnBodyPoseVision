import SwiftUI
import AVFoundation
import Vision

struct HomeView: View {
    @State private var cameraManager = CameraManager()
    
    var body: some View {
        ZStack {
            CameraUIPreview(session: cameraManager.session)
                .ignoresSafeArea()
            
            SkeletonBodyView(bodyParts: cameraManager.detectedBodyParts)
                .ignoresSafeArea()
        }
        .onAppear {
            cameraManager.checkPermissions()
        }
    }
}


