//
//  SheetTint.swift
//
//
//  Created by Alex Cucos on 25.02.2024.
//

import SwiftUI

// MARK: - Tint Container
struct SheetTint<Content: View>: View {
    @Binding var isOpened: Bool
    let content: Content
    
    init(isOpened: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._isOpened = isOpened
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            ZStack {
                content
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3).ignoresSafeArea(.all))
            .opacity(isOpened ? 1 : 0)
            .allowsHitTesting(isOpened)
            .onTapGesture {
                withAnimation(.spring) {
                    isOpened = false
                }
            }
        }
    }
}
