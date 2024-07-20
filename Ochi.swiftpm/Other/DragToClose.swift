//
//  DragToClose.swift
//
//
//  Created by Alex Cucos on 13.02.2024.
//

import SwiftUI

struct DragToCloseModifier: ViewModifier {
    @Bindable var navigation: NavigationManager
    
    let maximumOffset: CGFloat = 75.0
    let rubberbandCoefficient: CGFloat = 0.5
    
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 4, coordinateSpace: .local)
                    .onChanged({ value in
                        if value.translation.height > 0 {
                            navigation.bottomSheetOffset = pow(abs(value.translation.height), rubberbandCoefficient)
                        } else {
                            navigation.bottomSheetOffset = -pow(abs(value.translation.height), rubberbandCoefficient)
                        }
//                        didUpdateDragGestureOffset(to: value.translation.height)
                    })
                    .onEnded({ value in
                        didUpdateDragGestureOffset(to: value.translation.height, velocity: value.velocity.height)
                        withAnimation(.spring) {
                            navigation.bottomSheetOffset = 0
                        }
                    })
            )
    }
    
    private func didUpdateDragGestureOffset(to offset: CGFloat, velocity: CGFloat) {
        withAnimation(.interpolatingSpring(.bouncy, initialVelocity: velocity)) {
            switch navigation.currentScreen {
            case .smallModesView:
                if offset < -maximumOffset {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    navigation.currentScreen = .expandedModesView
                }
            case .expandedModesView:
                if offset > maximumOffset {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    navigation.currentScreen = .smallModesView
                }
            case .infoView:
                if offset > maximumOffset {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    navigation.currentScreen = .smallModesView
                }
            case .adjustView:
                if offset > maximumOffset {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    navigation.currentScreen = .smallModesView
                }
            }
        }
    }
}

