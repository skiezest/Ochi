//
//  ContentView.swift
//
//
//  Created by Alex Cucos on 07.02.2024.
//

import SwiftUI

struct ContentView: View {
    @State var navigation = NavigationManager()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                background
                content
                additionalButtons
                onboarding
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // Background
    var background: some View {
        CameraView(navigation: navigation)
            .background(Color.black)
            .onTapGesture {
                if navigation.currentScreen != .smallModesView {
                    navigation.currentScreen = .smallModesView
                }
            }
            .modifier(DragToCloseModifier(navigation: navigation))
    }
    
    // Content
    var content: some View {
        VStack {
            Spacer()
            NavigationManagerView(navigation: navigation)
        }
        .padding(.bottom, 24)
        .padding(.horizontal, 28)
    }
    
    // Onboarding Button
    var additionalButtons: some View {
        ZStack {
            HStack(spacing: 12) {
                SmallButton("questionmark.circle.fill") {
                    navigation.isOnboardingOpened = true
                }
            }
        }
        .padding(.top, 8)
        .padding(.trailing, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
    
    // Onboarding
    var onboarding: some View {
        OnboardingView(navigation: navigation)
    }
}
