//
//  SmallButton.swift
//  
//
//  Created by Alex Cucos on 13.02.2024.
//

import SwiftUI

struct SmallButton: View {
    var systemName: String
    var action: () -> Void
    
    init(_ systemName: String, action: @escaping () -> Void) {
        self.systemName = systemName
        self.action = action
    }
    
    @State var model = OnboardingButtonViewModel()
    
    var body: some View {
        ZStack {
            Image(systemName: systemName)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.primary)
        }
        .frame(width: 48, height: 48)
        .background(Material.ultraThin)
        .clipShape(Circle())
        .onTapGesture {
            withAnimation(.spring.speed(1.5)) {
                action()
            }
        }
        .onLongPressGesture(minimumDuration: .infinity,
                            maximumDistance: 52,
                            perform: { },
                            onPressingChanged: { pressed in
                                withAnimation(.spring.speed(1.2)) {
                                    model.isPressed = pressed
                                }
                            })
        .scaleEffect(model.isPressed ? 0.9 : 1)
    }
}

@Observable class OnboardingButtonViewModel {
    var isPressed = false
}
