#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    int transparent;

};
layout(binding = 1) uniform sampler2D source;
layout(binding = 2) uniform sampler2D shadow;
layout(binding = 3) uniform sampler2D mask;

void main() {    fragColor = texture(source, qt_TexCoord0)
                    * texture(mask, qt_TexCoord0).a
                    * (1 - texture(shadow, qt_TexCoord0).a * transparent)
                    * qt_Opacity ;
}

