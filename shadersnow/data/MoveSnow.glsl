#extension GL_ARB_draw_buffers : enable

uniform sampler2D src_tex_unit0; // Position texture

uniform vec2 dim;

void main(void)
{
    vec2 tex_coord = gl_TexCoord[0].st;

    // Updating particle position.
    vec4 old_pos = texture2D(src_tex_unit0, tex_coord);
    bool meEmpty = old_pos[0] < .5;
    float stepSize = 1.0/dim.y;

    bool belowEmpty = false;
    float belowY = tex_coord.y+(1.0/dim.y);
    if (belowY < 1.0){
        vec4 below = texture2D(src_tex_unit0, vec2(tex_coord.x, belowY));
        belowEmpty = below[0] < .5;
    }

    bool aboveEmpty = true;
    float aboveY = tex_coord.y-(1.0/dim.y);
    if (aboveY > 0.0){
        vec4 above = texture2D(src_tex_unit0, vec2(tex_coord.x, aboveY));
        aboveEmpty = above[0] < .5;
    }

    if ((meEmpty && !aboveEmpty) || (!meEmpty && !belowEmpty)){
        gl_FragData[0] = vec4(1.0,1.0,1.0,1.0);
    } else {
        gl_FragData[0] = vec4(0.0,0.0,0.0,1.0);
    }
}
