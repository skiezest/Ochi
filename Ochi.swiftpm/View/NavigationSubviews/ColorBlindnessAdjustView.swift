//
//  ColorBlindnessAdjustView.swift
//
//
//  Created by Alex Cucos on 23.02.2024.
//

import SwiftUI

struct ColorBlindnessAdjustView: View {
    @Bindable var navigation: NavigationManager
    
    var body: some View {
        VStack {
            header
                .modifier(DragToCloseModifier(navigation: navigation))
            VStack(spacing: 0) {
                ForEach(ColorBlindnessLevels.levels, id: \.value) { level in
                    DividerView()
                    SelectableCell(level: level, navigation: navigation)
                }
            }
            .padding(.bottom, 24)
        }
        .frame(maxWidth: 500)
    }
    
    var header: some View {
        VStack(spacing: 12) {
            Capsule()
                .frame(width: 36, height: 5)
                .foregroundStyle(.white.opacity(0.1))
            Text("Adjust severity")
                .foregroundStyle(.primary)
                .fontWeight(.semibold)
        }
        .frame(height: 72)
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.01))
    }
}

private struct SelectableCell: View {
    @State var level: ColorBlindnessLevel
    @Bindable var navigation: NavigationManager
    
    var isSelected: Bool {
        navigation.selectedBlindnessLevel == level
    }
    
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark")
                .opacity(isSelected ? 1 : 0)
                .offset(.init(width: 0, height: isSelected ? 0 : 8))
                .blur(radius: isSelected ? 0 : 12)
                .animation(.snappy, value: isSelected)
            Text(level.value == 20 ? navigation.selectedMode.finalFormName ?? "Final Form" : "\(String(level.value)) nm")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 52)
        .background(
            Color.white.opacity(isPressed ? 0.25 : 0)
        )
        .overlay(
            Rectangle()
                .opacity(0.001)
                .contentShape(Rectangle())
                .onTapGesture {
                    navigation.selectedBlindnessLevel = level
                }
                .onLongPressGesture(minimumDuration: .infinity,
                                    maximumDistance: 100,
                                    perform: { },
                                    onPressingChanged: { pressed in
                                        withAnimation(.spring.speed(1.2)) {
                                            isPressed = pressed
                                        }
                                    })
        )
    }
}

private struct DividerView: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.white.opacity(0.05))
    }
}

@Observable
class ColorBlindnessLevels {
    static let levels: [ColorBlindnessLevel] = [
        ColorBlindnessLevel(4),
        ColorBlindnessLevel(8),
        ColorBlindnessLevel(12),
        ColorBlindnessLevel(16),
        ColorBlindnessLevel(20),
    ]
}

struct ColorBlindnessLevel: Hashable, Equatable {
    let value: Int
    
    init(_ value: Int) {
        self.value = value
    }
}
