//
//  InfoView.swift
//
//
//  Created by Alex Cucos on 12.02.2024.
//

import SwiftUI

struct InfoView: View {
    @Bindable var navigation: NavigationManager
    
    var header: some View {
        VStack(spacing: 12) {
            Capsule()
                .frame(width: 36, height: 5)
                .foregroundStyle(.white.opacity(0.1))
            Text("About")
                .foregroundStyle(.primary)
                .fontWeight(.semibold)
        }
        .frame(height: 72)
        .frame(maxWidth: .infinity)
        .background(Material.ultraThin)
        .overlay(alignment: .bottom) {
            Color.white.opacity(0.05)
                .frame(height: 1)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            VStack(alignment: .leading, spacing: 8) {
                Text(navigation.selectedMode.name)
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let description = navigation.selectedMode.description {
                    Text(description)
                        .foregroundStyle(Color.white.opacity(0.25))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .contentShape(Rectangle())
            .padding([.horizontal, .bottom], 32)
            .padding(.top, 24)
        }
        .frame(maxWidth: 500)
    }
}
