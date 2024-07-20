//
//  File.swift
//  
//
//  Created by Alex Cucos on 21.02.2024.
//

import Foundation
import MetalKit

struct TextureLoader {
    static let textureLoader: MTKTextureLoader = {
        return MTKTextureLoader(device: MTLCreateSystemDefaultDevice()!)
    }()
    
    static func loadTexture(named filename: String) -> MTLTexture? {
        guard let cgImage = UIImage(named: filename)?.cgImage else {
            print("Couldn't create cgImage")
            return nil
        }
        guard let texture = try? textureLoader.newTexture(cgImage: cgImage) else {
            print("Couldn't create texture from cgImage")
            return nil
        }
        
        return texture
    }
}
