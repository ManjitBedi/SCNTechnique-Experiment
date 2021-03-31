//
//  SceneFilterTechnique.metal
//  ARSCNViewImageFiltersExample
//
//  Orignal code created by Lësha Turkowski on 4/29/18.
//  Copyright © 2018 Lësha Turkowski. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>

struct VertexInput {
    float4 position [[ attribute(SCNVertexSemanticPosition) ]];
    float2 texcoord [[ attribute(SCNVertexSemanticTexcoord0) ]];
};

struct VertexOut {
    float4 position [[position]];
    float2 texcoord;
};

vertex VertexOut scene_filter_vertex(VertexInput in [[stage_in]])
{
    VertexOut out;
    out.position = in.position;
    out.texcoord =  float2((in.position.x + 1.0) * 0.5 , (in.position.y + 1.0) * -0.5);
    return out;
}

fragment half4 scene_filter_fragment(VertexOut vert [[stage_in]],
                                texture2d<half, access::sample> scene [[texture(0)]])
{
    constexpr sampler samp = sampler(coord::normalized, address::repeat, filter::nearest);
    constexpr half3 weights = half3(0.2126, 0.7152, 0.0722);
    
    half4 color = scene.sample(samp, vert.texcoord);
    color.rgb = half3(dot(color.rgb, weights));
    
    return color;
}

// Based on code from
// https://github.com/JohnCoates/Slate
fragment half4 scene_filter_fragment_chromatic_abberation(VertexOut vert [[stage_in]],
                                texture2d<half, access::sample> scene [[texture(0)]])
{
    float2 coordinates = vert.texcoord;
    constexpr sampler samp = sampler(coord::normalized, address::repeat, filter::nearest);

    half4 color = scene.sample(samp, coordinates);

    float2 offset = (coordinates - 0.4) * 2.0;
    float offsetDot = dot(offset, offset);

    const float strength = 5.0;
    float2 multiplier = strength * offset * offsetDot;
    float2 redCoordinate = coordinates - 0.003 * multiplier;
    float2 blueCoordinate = coordinates + 0.01 * multiplier;
    half4 adjustedColor;
    adjustedColor.r = scene.sample(samp, redCoordinate).r;
    adjustedColor.g = color.g;
    adjustedColor.b = scene.sample(samp, blueCoordinate).b;
    adjustedColor.a = color.a;
    return adjustedColor;
}
