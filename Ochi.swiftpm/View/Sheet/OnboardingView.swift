//
//  SwiftUIView.swift
//
//
//  Created by Alex Cucos on 13.02.2024.
//

import SwiftUI

struct OnboardingView: View {
    @Bindable var navigation: NavigationManager
    
    var body: some View {
        SheetTint(isOpened: $navigation.isOnboardingOpened) {
            VStack {
                ScrollView {
                    VStack {
                        VStack(spacing: 10) {
                            Text("Welcome to Ochi")
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .appearEffect(delay: 0.2)
                            Text("Ochi is a visual simulator designed to provide a realistic, scientific representation of common vision impairments.")
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .appearEffect(delay: 0.4)
                        }
                        .padding([.top, .horizontal], 24)
                        
                        Spacer()
                        
                        VStack(spacing: 32) {
                            SheetInfoView(symbol: "eye.fill",
                                               title: "Explore common impairments",
                                               description: "Discover how people with glaucoma, cataracts and various color blindness types see the world around them")
                            .appearEffect(delay: 0.6)
                            SheetInfoView(symbol: "doc.plaintext.fill",
                                               title: "Based on science",
                                               description: "The effects are based on popular research papers and documents, linked in the credits file.")
                            .appearEffect(delay: 0.8)
                            SheetInfoView(symbol: "guitars.fill",
                                               title: "Powered by Metal Shaders",
                                               description: "Ochi uses the power of Metal for the best performance possible. Rockstar-level greatness!")
                            .appearEffect(delay: 0.9)
                        }
                        .padding(32)
                        .padding(.bottom, 16)
                        
                        Spacer()
                        
                        button
                            .appearEffect(delay: 0.9)
                    }
                    .padding(36)
                    .frame(minHeight: 650)
                }
                .scrollIndicators(.never)
            }
            .frame(maxWidth: 600, maxHeight: 650)
            .background(Material.regular)
            .clipShape(RoundedRectangle(cornerRadius: 68, style: .continuous))
            .scaleEffect(navigation.isOnboardingOpened ? 1 : 0.88)
            .blur(radius: navigation.isOnboardingOpened ? 0 : 52)
            .padding(20)
        }
    }
    
    var button: some View {
        Button(action: {
            withAnimation(.spring.speed(1.4)) {
                navigation.isOnboardingOpened = false
            }
        }, label: {
            Text("Continue")
                .fontWeight(.semibold)
                .foregroundStyle(.black)
        })
        .buttonStyle(SheetButtonStyle())
    }
}

// MARK: - Appear Effect
extension View {
    func appearEffect(delay: CGFloat) -> some View {
        self
            .modifier(AppearEffectModifier(delay: delay))
    }
}

struct AppearEffectModifier: ViewModifier {
    var delay: CGFloat
    @State var didAppear = false
    
    func body(content: Content) -> some View {
        content
            .blur(radius: didAppear ? 0 : 32)
            .opacity(didAppear ? 1 : 0)
            .animation(.spring.delay(delay), value: didAppear)
            .offset(y: didAppear ? 0 : 28)
            .scaleEffect(didAppear ? 1 : 1.2)
            .onAppear {
                didAppear = true
            }
            .animation(.spring.speed(1.2), value: didAppear)
    }
}

