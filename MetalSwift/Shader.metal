//
//  Shader.metal
//  testMetalSwift
//
//  Created by Danny on 5/21/17.
//  Copyright © 2017 Danny. All rights reserved.
//

//https://www.raywenderlich.com/146414/metal-tutorial-swift-3-part-1-getting-started

#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertex(
const device packed_float3 * vertex_array [[buffer(0)]],
unsigned int vid [[vertex_id]]) {
    return float4(vertex_array[vid],1.0);
}


fragment half4 basic_fragment() {
    return half4(1.0);
}
