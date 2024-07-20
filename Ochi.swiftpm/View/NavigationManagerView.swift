//
//  NavigationManagerView.swift
//
//
//  Created by Alex Cucos on 07.02.2024.
//

import Foundation
import SwiftUI

// MARK: - Navigation
struct NavigationManagerView: View {
    var navigation: NavigationManager
    
    var body: some View {
        ZStack {
            switch navigation.currentScreen {
            case .expandedModesView:
                ExpandedModesView(navigation: navigation)
                .transition(.opacity)
            case .smallModesView:
                SmallModesView(navigation: navigation)
                .transition(.scale(scale: 0.5))
                .modifier(DragToCloseModifier(navigation: navigation))
            case .infoView:
                InfoView(navigation: navigation)
                .transition(.blurReplace)
                .modifier(DragToCloseModifier(navigation: navigation))
            case .adjustView:
                ColorBlindnessAdjustView(navigation: navigation)
                    .transition(.opacity)
            }
        }
        .background(Material.regular)
        .clipShape(RoundedRectangle(cornerRadius: 44, style: .continuous))
        .offset(y: navigation.bottomSheetOffset)
        .animation(.spring.speed(1.2), value: navigation.currentScreen)
//        .scaleEffect(x: 1 - abs(navigation.bottomSheetOffset) * 0.003,
//                     y: 1.0,
//                     anchor: .center)
    }
}

