//
//  File.swift
//  
//
//  Created by Alex Cucos on 25.02.2024.
//

import Foundation

class ShaderLibrary {
    static let all = """
/*
See License (AVCamFilter).txt file for this sample’s licensing information.
*/

#include <metal_stdlib>
using namespace metal;

// Vertex input/output structure for passing results from vertex shader to fragment shader
struct VertexIO
{
    float4 position [[position]];
    float2 textureCoord [[user(texturecoord)]];
};

// Vertex shader for a textured quad
vertex VertexIO vertexPassThrough(const device packed_float4 *pPosition  [[ buffer(0) ]],
                                  const device packed_float2 *pTexCoords [[ buffer(1) ]],
                                  uint                  vid        [[ vertex_id ]])
{
    VertexIO outVertex;
    
    outVertex.position = pPosition[vid];
    outVertex.textureCoord = pTexCoords[vid];
    
    return outVertex;
}

// Fragment shader for a textured quad
fragment half4 fragmentPassThrough(VertexIO         inputFragment [[ stage_in ]],
                                   texture2d<half> inputTexture  [[ texture(0) ]],
                                   sampler         samplr        [[ sampler(0) ]])
{
    return inputTexture.sample(samplr, inputFragment.textureCoord);
}

// MARK: - Blur
/// This is an adapted version from Paul Hudson's Inferno shaders collection: https://github.com/twostraws/Inferno/
/// Thanks for the resource!

/// The license for the following two functions can be found in "License (Inferno).txt"

inline float gaussian(float distance, float sigma) {
    const float gaussianExponent = -(distance * distance) / (2.0 * sigma * sigma);
    return (1.0 / (2.0 * M_PI_F * sigma * sigma)) * exp(gaussianExponent);
}

float4 gaussianBlur(uint2 gid [[thread_position_in_grid]],
                    texture2d<float, access::sample> inTexture [[texture(0)]],
                    sampler inTextureSampler [[sampler(0)]],
                    constant float2& size [[buffer(0)]],
                    float radius,
                    float maxSamples) {
    float2 position = (float2(gid) + 0.5) / size;
    
    const float interval = max(1.0, radius / maxSamples);
    const float weight = gaussian(0.0, radius / 2.0);
    
    float4 weightedColorSum = inTexture.sample(inTextureSampler, position) * weight;
    float totalWeight = weight;
    
    if (interval <= radius) {
        for (float distance = interval; distance <= radius; distance += interval) {
            const float weight = gaussian(distance, radius / 2.0);
            totalWeight += weight * 2.0;
            
            float2 offset = distance / size;
            weightedColorSum += inTexture.sample(inTextureSampler, position + offset) * weight;
            weightedColorSum += inTexture.sample(inTextureSampler, position - offset) * weight;
        }
    }
    
    return weightedColorSum / totalWeight;
}

// MARK: - Glaucoma
kernel void glaucoma(texture2d<float, access::sample> inTexture [[texture(0)]],
                     sampler inTextureSampler [[sampler(0)]],
                     texture2d<float, access::write> outTexture [[texture(1)]],
                     texture2d<float, access::sample> maskTexture [[texture(2)]],
                     sampler maskSampler [[sampler(2)]],
                     constant float2& size [[buffer(0)]],
                     uint2 gid [[thread_position_in_grid]]) {
    float2 position = float2(gid) + 0.5; // Center of pixel
    float2 uv = position / size;
    
    float maskBrightness = maskTexture.sample(maskSampler, uv).r;
    float blurIntensity = maskBrightness * 40.0f;
    
    float4 color;
    if (maskBrightness > 0.0f) {
        color = gaussianBlur(gid, inTexture, inTextureSampler, size, blurIntensity, 8);
    } else {
        color = inTexture.read(gid);
    }
    
    // Adjust color brightness
    color.rgb *= (0.9 - maskBrightness);

    color.rgb -= 0.1;
    
    outTexture.write(color, gid);
}


// MARK: - Cataracts
kernel void cataracts(texture2d<float, access::sample> inTexture [[texture(0)]],
                      sampler inTextureSampler [[sampler(0)]],
                      texture2d<float, access::write> outTexture [[texture(1)]],
                      texture2d<float, access::sample> maskTexture [[texture(2)]],
                      sampler maskSampler [[sampler(2)]],
                      constant float2& size [[buffer(0)]],
                      uint2 gid [[thread_position_in_grid]]) {
    float2 position = float2(gid) + 0.5; // Center of pixel
    float2 uv = position / size;
    
    float4 color = inTexture.sample(inTextureSampler, uv);
    float maskBrightness = maskTexture.sample(maskSampler, uv).r;
    
    // Setting contrast
    float contrast = 0.4;
    color.rgb = ((color.rgb - 0.5f) * max(contrast, 0.0f)) + 0.5f;
    
    float saturation = 0.5;
    color.rgb = mix(float3(dot(color.rgb, float3(0.299, 0.287, 0.114))), color.rgb, saturation);
    
    color.rgb += maskBrightness * 15;
    
    outTexture.write(color, gid);
}

// MARK: - Astigmatism
kernel void astigmatism(texture2d<float, access::sample> inTexture [[texture(0)]],
                        texture2d<float, access::write> outTexture [[texture(1)]],
                        constant float2& size [[buffer(0)]],
                        sampler inTextureSampler [[sampler(0)]],
                        uint2 gid [[thread_position_in_grid]]) {
    const float dist = 24.0;
    float2 uv = float2(gid) / size;
    float4 texColor = inTexture.sample(inTextureSampler, uv);
    
    for (float i = 1.0; i < dist; i += 10.0) {
        float x1 = i / size.x;
        float y1 = i / size.y;
        texColor = (texColor + inTexture.sample(inTextureSampler, uv + float2(-x1, 0))) / 2.0;
        texColor = (texColor + inTexture.sample(inTextureSampler, uv + float2(x1, 0))) / 2.0;
        texColor = (texColor + inTexture.sample(inTextureSampler, uv + float2(0, -y1))) / 2.0;
        texColor = (texColor + inTexture.sample(inTextureSampler, uv + float2(0, y1))) / 2.0;
    }
    
    outTexture.write(texColor, gid);
}

// MARK: - Diabetic retinopathy
kernel void diabeticRetinopathy(texture2d<float, access::sample> inTexture [[texture(0)]],
                                sampler inTextureSampler [[sampler(0)]],
                                texture2d<float, access::write> outTexture [[texture(1)]],
                                texture2d<float, access::sample> maskTexture [[texture(2)]],
                                sampler maskSampler [[sampler(2)]],
                                constant float2& size [[buffer(0)]],
                                uint2 gid [[thread_position_in_grid]]) {
    float2 position = float2(gid) + 0.5; // Center of pixel
    float2 uv = position / size;
    
    float maskBrightness = maskTexture.sample(maskSampler, uv).r;
    
    float4 color = inTexture.sample(inTextureSampler, uv);;
    
    // Add slight blur
    if (maskBrightness > 0) {
        const half blurIntensity = (maskBrightness + 0.1) * 20;
        color = gaussianBlur(gid, inTexture, inTextureSampler, size, blurIntensity, 6);
    }
    
    // Adjust color brightness
    color.rgb *= (1 - maskBrightness);

    // Setting contrast
    float contrast = 0.7;
    color.rgb = ((color.rgb - 0.5f) * max(contrast, 0.0f)) + 0.5f;
    
    outTexture.write(color, gid);
}


// MARK: - Macular degeneration
/// Swirl effect based on: https://www.shadertoy.com/view/Xscyzn
/// Changes were made to the original file to adapt it for a realistic macular degeneration sample
/// The original resource is licensed under CC BY-NC-SA 3.0 DEED: https://creativecommons.org/licenses/by-nc-sa/3.0/

kernel void macularDegeneration(texture2d<float, access::sample> inTexture [[texture(0)]],
                                sampler inTextureSampler [[sampler(0)]],
                                texture2d<float, access::write> outTexture [[texture(1)]],
                                texture2d<float, access::sample> maskTexture [[texture(2)]],
                                sampler maskSampler [[sampler(2)]],
                                constant float2& size [[buffer(0)]],
                                uint2 gid [[thread_position_in_grid]]) {
    const float pi = 3.141592;
    float effectRadius = 0.5;
    float effectAngle = 0.1f * pi;
    
    float2 position = float2(gid) + 0.5;
    
    float2 center = 0.5;
    float2 uv = position / size - center;
    
    float len = length(uv * float2(size.x / size.y, 1.0));
    float angle = atan2(uv.y, uv.x) + effectAngle * smoothstep(effectRadius, 0.0, len);
    float radius = length(uv);
    
    float2 coordinates = radius * float2(cos(angle), sin(angle)) + center;
    float4 color = inTexture.sample(inTextureSampler, coordinates);
    
    // Sample the mask texture
    float maskBrightness = maskTexture.sample(maskSampler, coordinates).r;
    
    // Adjust color brightness
    color.rgb *= maskBrightness;
    
    float saturation = 0.4;
    color.rgb = mix(float3(dot(color.rgb, float3(0.299, 0.287, 0.114))), color.rgb, saturation);
    
    outTexture.write(color, gid);
}

// MARK: - Protanomaly
kernel void protanopia(texture2d<float, access::read> inTexture [[ texture(0) ]],
                       texture2d<float, access::write> outTexture [[ texture(1) ]],
                       constant float& intensity [[ buffer(0) ]],
                       uint2 gid [[ thread_position_in_grid ]]) {
    float4 currentColor = inTexture.read(gid);
    
    float4 color = float4(mix(1, 0.152f, intensity) * currentColor.r + mix(0, 1.052f, intensity) * currentColor.g + mix(0, -0.204f, intensity) * currentColor.b,
                          mix(0, 0.114f, intensity) * currentColor.r + mix(1, 0.786f, intensity) * currentColor.g + mix(0, 0.099f, intensity) * currentColor.b,
                          mix(0, -0.003f, intensity) * currentColor.r + mix(0, -0.048f, intensity) * currentColor.g + mix(1, 1.051f, intensity) * currentColor.b,
                          1);
    outTexture.write(color, gid);
}

// MARK: - Deuteranomaly
kernel void deuteranopia(texture2d<float, access::read> inTexture [[ texture(0) ]],
                         texture2d<float, access::write> outTexture [[ texture(1) ]],
                         constant float& intensity [[ buffer(0) ]],
                         uint2 gid [[ thread_position_in_grid ]]) {
    float4 currentColor = inTexture.read(gid);
    
    float4 color = float4(mix(1, 0.367f, intensity) * currentColor.r + mix(0, 0.861f, intensity) * currentColor.g + mix(0, -0.228f, intensity) * currentColor.b,
                          mix(0, 0.280f, intensity) * currentColor.r + mix(1, 0.673f, intensity) * currentColor.g + mix(0, 0.047f, intensity) * currentColor.b,
                          mix(0, -0.012f, intensity) * currentColor.r + mix(0, 0.043f, intensity) * currentColor.g + mix(1, 0.969f, intensity) * currentColor.b,
                          1);
    
    outTexture.write(color, gid);
}

// MARK: - Tritanomaly
kernel void tritanopia(texture2d<float, access::read> inTexture [[ texture(0) ]],
                       texture2d<float, access::write> outTexture [[ texture(1) ]],
                       constant float& intensity [[ buffer(0) ]],
                       uint2 gid [[ thread_position_in_grid ]]) {
    float4 currentColor = inTexture.read(gid);
    
    float4 color = float4(mix(1, 1.255f, intensity) * currentColor.r + mix(0, -0.076f, intensity) * currentColor.g + mix(0, -0.178f, intensity) * currentColor.b,
                          mix(0, -0.078f, intensity) * currentColor.r + mix(1, 0.930f, intensity) * currentColor.g + mix(0, 0.147f, intensity) * currentColor.b,
                          mix(0, -0.004f, intensity) * currentColor.r + mix(0, 0.691f, intensity) * currentColor.g + mix(1, 0.303f, intensity) * currentColor.b,
                          1);
    
    outTexture.write(color, gid);
}

// MARK: - Monochromacy
kernel void monochromacy(texture2d<float, access::read> inTexture [[ texture(0) ]],
                         texture2d<float, access::write> outTexture [[ texture(1) ]],
                         uint2 gid [[ thread_position_in_grid ]]) {
    float4 currentColor = inTexture.read(gid);
    
    float4 color = float4((currentColor.r + currentColor.g + currentColor.b) / 3,
                          (currentColor.r + currentColor.g + currentColor.b) / 3,
                          (currentColor.r + currentColor.g + currentColor.b) / 3,
                          1);
    
    outTexture.write(color, gid);
}


"""
}
