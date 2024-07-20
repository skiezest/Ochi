//
//  Mode.swift
//
//
//  Created by Alex Cucos on 08.02.2024.
//

import Foundation

struct Mode: Identifiable, Equatable {
    var id = UUID()
    let name: String
    let finalFormName: String?
    let renderer: FilterRenderer?
    let description: String?
    let imageType: ModeImageType
    
    let supportsValues: Bool // Means shader supports values from 0 to 1, representing different stages of the impairment development
    
    init(_ name: String, finalFormName: String? = nil, renderer: FilterRenderer?, description: String?, imageType: ModeImageType, supportsValues: Bool = false) {
        self.id = UUID()
        self.name = name
        self.finalFormName = finalFormName
        self.renderer = renderer
        self.description = description
        self.imageType = imageType
        self.supportsValues = supportsValues
    }
    
    static func == (lhs: Mode, rhs: Mode) -> Bool {
        lhs.name == rhs.name
    }
}

enum ModeImageType {
    case image(String)
    case icon(String)
}
