#extension GL_ARB_draw_buffers : enable

uniform sampler2D src_tex_unit0; // Position texture

uniform vec2 dim;
uniform vec4 additions;

void main(void)
{
    vec2 tex_coord = gl_TexCoord[0].st;

    // Updating particle position.
    vec4 old_pos = texture2D(src_tex_unit0, tex_coord);
    bool meEmpty = old_pos[0] < .5;
    bool willBeEmpty = meEmpty;
    float stepSize = 1.0/dim.y;

    bool belowEmpty = false;
    float belowY = tex_coord.y+(1.0/dim.y);
    if (belowY < 1.0){
        vec4 below = texture2D(src_tex_unit0, vec2(tex_coord.x, belowY));
        belowEmpty = below[0] < .5;
    }

    //if I am not empty, and nothing is directly below me
    //then I will be empty next time (I don't care exactly where I end up)
    if (!meEmpty && belowEmpty){
        willBeEmpty = true;
    } else if (!meEmpty && !belowEmpty){
        willBeEmpty = false;
    } else {
        //otherwise, is there anything in the 3 spaces above me?
        float newY = tex_coord.y;
        vec4 currPix;
        bool somethingAbove = false;
        int numToDo = 4;
        for(int i = 0; i<numToDo && !somethingAbove; i++){
            newY -=  stepSize;
            if (newY < 0.0){
                currPix[0] = 0.0;
                break;
            }
            currPix = texture2D(src_tex_unit0, vec2(tex_coord.x, newY));
            if (currPix[0] >= .5 && i < numToDo-1){
                //we don't want to count the 4th pixel, 
                //just retreive for future ref
                somethingAbove = true;
            }
        }
        //if something above, and nothing below, I will be empty
        if (somethingAbove && belowEmpty){
            willBeEmpty = true;
        } else if (somethingAbove){
        //if something above, and something below, I will be full
            willBeEmpty = false;
        } else if (currPix[0] >= .5){
        //if something 4 spaces up, I will be full
            willBeEmpty = false;
        } else {
        //otherwise, nothing above and nothing 4 spaces up
            willBeEmpty = true;
        }
    } 
    if (tex_coord.y < stepSize/2.0){
        for(int i = 0; i < 4; i++){
            if (additions[i]/dim.y < tex_coord.x + stepSize/2.0 && additions[i]/dim.y > tex_coord.x - stepSize/2.0){
                willBeEmpty = false;
            }
        }
    }
/*
    int numBelow = 0;
    float deltaY = tex_coord.y + (4.0*stepSize);
    for(int i = 0; i<4; i++){
        if (deltaY < 1.0){
            vec4 below = texture2D(src_tex_unit0, vec2(tex_coord.x, deltaY));
            if (below[0] < .5){
                numBelow++;
            }
        }
        deltaY -= stepSize;
    }
    if (meEmpty){
        numBelow++;
    }
    deltaY = tex_coord.y;
    for(int i = 0; i<4 && numBelow > 0; i++){
        deltaY -= stepSize;
        if (deltaY > 0.0){
            currPix = texture2D(src_tex_unit0, vec2(tex_coord.x, deltaY));
            if (currPix[0] > .5){
                numBelow--;
            }
        } else {
            break;
        }
    }
*/
    if (willBeEmpty){
        gl_FragData[0] = vec4(0.0,0.0,0.0,1.0);
    } else {
        gl_FragData[0] = vec4(1.0,1.0,1.0,1.0);
    }
}
