//
//  SmallModesView.swift
//
//
//  Created by Alex Cucos on 05.02.2024.
//

import SwiftUI

// MARK: - Small Modes
struct SmallModesView: View {
    @State var model = SmallModesViewModel()
    @Bindable var navigation: NavigationManager
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 12) {
                switch navigation.selectedMode.imageType {
                case .icon(let iconName):
                    Image(systemName: iconName)
                        .padding(.leading, 4)
                case .image(let imageName):
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 28, height: 28)
                        .clipShape(Circle())
                }
                Text(navigation.selectedMode.name)
                    .foregroundStyle(.primary)
                    .fontWeight(.medium)
                Image(systemName: "chevron.up")
                    .foregroundStyle(Color.white.opacity(0.35))
                    .fontWeight(.bold)     
            }
            .frame(height: 52)
            .padding(.leading, 12)
            .padding(.trailing, 16)
            .overlay {
                Color.black.opacity(0.01)
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        navigation.currentScreen = .expandedModesView
                    }
            }
            
            if navigation.selectedMode.description != nil {
                DividerView()
                Button(action: {
                    navigation.currentScreen = .infoView
                }, label: {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(width: 52, height: 52)
                })
            }
            
            if navigation.selectedMode.supportsValues {
                DividerView()
                Button(action: {
                    navigation.currentScreen = .adjustView
                }, label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 20))
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(width: 52, height: 52)
                })
            }
        }
        .padding(.trailing, navigation.selectedMode.description != nil || navigation.selectedMode.supportsValues ? 4 : 0)
        .opacity(navigation.currentScreen == .smallModesView ? 1 : 0)
        .blur(radius: navigation.currentScreen == .smallModesView ? 0 : 24)
        .scaleEffect(model.isPressed ? 0.93 : 1)
        .onLongPressGesture(minimumDuration: .infinity,
                            maximumDistance: 100,
                            perform: { },
                            onPressingChanged: { pressed in
            withAnimation(.spring.speed(1.2)) {
                model.isPressed = pressed
            }
        })
    }
}

fileprivate struct DividerView: View {
    var body: some View {
        Color.white
            .opacity(0.05)
            .frame(width: 1, height: 28)
    }
}

@Observable
class SmallModesViewModel {
    var isPressed = false
}
