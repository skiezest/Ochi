//
//  ExpandedModesView.swift
//
//
//  Created by Alex Cucos on 05.02.2024.
//

import SwiftUI

// MARK: - Expanded Modes
struct ExpandedModesView: View {
    @State var model = ExpandedModeViewModel()
    @Bindable var navigation: NavigationManager
    
    var body: some View {
        ZStack(alignment: .top) {
            scroll
            header
                .modifier(DragToCloseModifier(navigation: navigation))
        }
        .frame(maxWidth: 500)
        .frame(height: 550)
        .opacity(navigation.currentScreen == .expandedModesView ? 1 : 0)
    }
    
    var header: some View {
        VStack(spacing: 12) {
            Capsule()
                .frame(width: 36, height: 5)
                .foregroundStyle(.white.opacity(0.1))
            Text("Modes")
                .foregroundStyle(.primary)
                .fontWeight(.semibold)
        }
        .frame(height: model.headerHeight)
        .frame(maxWidth: .infinity)
        .background(Material.ultraThin)
        .overlay(alignment: .bottom) {
            Color.white.opacity(0.05)
                .frame(height: 1)
        }
    }
    
    var scroll: some View {
        ScrollViewReader { value in
            ScrollView {
                VStack(spacing: 48) {
                    ForEach(Modes.types) { type in
                        VStack(spacing: 20) {
                            if let name = type.name {
                                Text(name)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 32)
                                    .fontWeight(.semibold)
                            }
                            
                            LazyVGrid(columns: model.adaptiveColumns, alignment: .leading, spacing: 20) {
                                ForEach(type.modes) { mode in
                                    CellView(model: CellViewModel(mode: mode), navigation: navigation)
                                        .id(mode.id)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                }
                .padding(.vertical, 28)
                .padding(.top, model.headerHeight)
            }
            .onAppear {
                value.scrollTo(navigation.selectedMode.id, anchor: .center)
            }
            .scrollIndicators(.hidden)
        }
    }
}

@Observable
class ExpandedModeViewModel {
    fileprivate let adaptiveColumns = [
        GridItem(.adaptive(minimum: 96, maximum: 300), alignment: .top)
    ]
    fileprivate let headerHeight: CGFloat = 72
}
