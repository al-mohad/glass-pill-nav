#version 460 core

#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uSize;
uniform vec4 uColor;
uniform vec2 uPillPos; // Normalized pill position (0 to 1)
uniform float uWarp;   // Warp intensity

out vec4 fragColor;

float metaball(vec2 p, vec2 center, float radius) {
    return radius / length(p - center);
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uSize;

    // Centers for the liquid blobs
    // Main pill blob
    vec2 pillCenter = uPillPos;

    // Dynamic trailing blobs based on movement could be added here,
    // but we'll start with an organic pulse/warp
    float d = metaball(uv, pillCenter, 0.15);

    // Add some noise/organic warping
    float noise = sin(uv.x * 10.0 + uTime * 2.0) * 0.02 * uWarp;
    d += metaball(uv + noise, pillCenter + vec2(sin(uTime)*0.05, 0.0), 0.1);

    // Thresholding for the sharp "liquid" edge
    float alpha = smoothstep(0.4, 0.5, d);

    // Final glass color
    vec4 color = uColor;
    color.a *= alpha * 0.4; // Soften the glass look

    fragColor = color;
}
