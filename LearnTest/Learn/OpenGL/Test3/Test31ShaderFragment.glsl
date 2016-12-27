precision mediump float;
uniform vec4 SourceColor;
uniform sampler2D Texture;
varying vec2 TextureCoordsOut;

void main()
{
    vec4 mask = texture2D(Texture, TextureCoordsOut);
    float grey = dot(mask.rgb, vec3(0.3, 0.6, 0.1));
    gl_FragColor = vec4(SourceColor.rgb, grey);
}
