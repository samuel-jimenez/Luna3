#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    int transparent;
    float shadow_Opacity;

};
layout(binding = 1) uniform sampler2D source;
layout(binding = 2) uniform sampler2D light;
layout(binding = 3) uniform sampler2D mask;

void main() {
        float translucentShadow = 1 - shadow_Opacity
                            + shadow_Opacity * texture(light, qt_TexCoord0).a;
        fragColor =
            vec4(
                (texture(source, qt_TexCoord0)
                *((1 - transparent)
                        * translucentShadow
                    + transparent )).rgb,
                texture(source, qt_TexCoord0).a)
            * ((1 - transparent)
                + transparent
                    * translucentShadow)
            * texture(mask, qt_TexCoord0).a
            * qt_Opacity ;

}
