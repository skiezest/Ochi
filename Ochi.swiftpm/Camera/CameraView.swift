//
//  CameraView.swift
//
//

import SwiftUI

struct CameraView: View {
    @Bindable var navigation: NavigationManager
    
    var body: some View {
        CameraPreview(navigation: navigation)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            .allowsHitTesting(false)
    }
}

struct CameraPreview: UIViewRepresentable {
    @Bindable var navigation: NavigationManager
    private let viewController = CameraViewController()

    func makeUIView(context: Context) -> UIView {
        return viewController.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        viewController.updateRenderer(navigation.selectedMode.renderer)
        
        viewController.updateCameraPosition(navigation.cameraPosition)
        
        if navigation.selectedMode.supportsValues, let level = navigation.selectedBlindnessLevel {
            viewController.updateColorBlindnessLevel(level)
        }
    }
}
