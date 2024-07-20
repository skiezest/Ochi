//
//  File.swift
//  
//
//  Created by Alex Cucos on 25.02.2024.
//

import SwiftUI

struct SheetButtonStyle: ButtonStyle {
    @State var type: SheetButtonStyleType = .primary
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .foregroundStyle(type == .primary ? .black : .white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(type == .primary ? Color.white : Color.white.opacity(0.05))
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring.speed(1.4), value: configuration.isPressed)
    }
}

enum SheetButtonStyleType {
    case primary
    case secondary
}
