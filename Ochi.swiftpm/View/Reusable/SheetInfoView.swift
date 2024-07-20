//
//  File.swift
//  
//
//  Created by Alex Cucos on 25.02.2024.
//

import SwiftUI

// MARK: - Info Cell
struct SheetInfoView: View {
    var symbol: String
    var title: String
    var description: String
    
    var body: some View {
        HStack(spacing: 36) {
            Image(systemName: symbol)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28, alignment: .center)
            VStack(spacing: 4) {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.primary)
                    .font(.system(size: 18, weight: .semibold))
                Text(description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.white.opacity(0.5))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
