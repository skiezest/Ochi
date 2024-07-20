//
//  CellView.swift
//  
//
//  Created by Alex Cucos on 07.02.2024.
//

import SwiftUI

// MARK: - Cell
struct CellView: View {
    @State var model: CellViewModel
    @Bindable var navigation: NavigationManager
    
    var isActive: Bool {
        model.mode == navigation.selectedMode
    }

    var body: some View {
        VStack(spacing: 12) {
            // Circle
            ZStack {
                ZStack {
                    ZStack {
                        switch model.mode.imageType {
                        case .icon(let iconName):
                            Image(systemName: iconName)
                                .font(.system(size: 32))
                                .frame(width: 44, height: 44, alignment: .center)
                                .fontWeight(.semibold)
                                .foregroundStyle(isActive ? .primary : .tertiary)
                            
                        case .image(let imageName):
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .clipShape(Circle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(isActive ? 0 : 8)
                }
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .padding(isActive ? 8 : 0)
            }
            .frame(width: 88,
                   height: 88,
                   alignment: .center)
            .overlay {
                Circle()
                    .stroke(isActive ? .white : .clear,
                            lineWidth: isActive ? 3 : 1)
            }
            
            // Text
            Text(model.mode.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundStyle(isActive ? .primary : .secondary)
        }
        .scaleEffect(model.isPressed ? 0.91 : 1)
        .overlay(
            Rectangle()
                .opacity(0)
                .contentShape(Rectangle())
                .onTapGesture {
                    if navigation.selectedMode != model.mode {
                        DispatchQueue.global(qos: .userInitiated).async {
                            let mode = model.mode
                            DispatchQueue.main.async {
                                navigation.selectedMode = mode
                            }
                        }
                    }
                    navigation.currentScreen = .smallModesView
                }

                .onLongPressGesture(minimumDuration: .infinity,
                                    maximumDistance: 100,
                                    perform: { },
                                    onPressingChanged: { pressed in
                                        withAnimation(.spring.speed(1.2)) {
                                            model.isPressed = pressed
                                        }
                                    })
        )
        .animation(.spring, value: isActive)
    }
}

@Observable
class CellViewModel {
    var mode: Mode
    
    var isPressed = false
    
    init(mode: Mode) {
        self.mode = mode
    }
}
