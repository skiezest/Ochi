//
//  Navigation.swift
//  
//
//  Created by Alex Cucos on 13.02.2024.
//

import Foundation
import SwiftUI
import AVFoundation

@Observable
class NavigationManager {
    var selectedMode: Mode = Modes.normalVision.modes.first!
    var currentScreen = NavigationScreen.smallModesView
    
    var isOnboardingOpened = true
    
    var bottomSheetOffset: CGFloat = 0
    
    var selectedBlindnessLevel = ColorBlindnessLevels.levels.first { $0.value == 12 }
    
    var cameraPosition = AVCaptureDevice.Position.back
    var isHandRecognitionEnabled = false
    
    var thumbsUpAction: () -> Void = {}
    var thumbsDownAction: () -> Void = {}
}

enum NavigationScreen {
    case smallModesView
    case expandedModesView
    case infoView
    case adjustView
}
