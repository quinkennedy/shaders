#extension GL_ARB_draw_buffers : enable

uniform sampler2D src_tex_unit0; // Position texture

uniform vec2 dim;
uniform vec4 additions;

bool leansRight(vec4 pixel){
    return (pixel[0] > .999 || (pixel[0] <= .6 && pixel[0] > .55));
}

bool isEmpty(vec4 pixel){
    return pixel[0] < .5;
}

void main(void)
{
    vec2 tex_coord = gl_TexCoord[0].st;

    // Updating particle position.
    vec4 old_pos = texture2D(src_tex_unit0, tex_coord);
    bool meEmpty = isEmpty(old_pos);//old_pos[0] < .5;
    bool leanRight = leansRight(old_pos);//!meEmpty && (old_pos[0] > .999 || (old_pos[0] <= .6 && old_pos[0] > .55));
    bool willBeEmpty = meEmpty;
    float yStepSize = 1.0/dim.y;
    float xStepSize = 1.0/dim.x;
    int numToDo = 4;

    bool belowEmpty = false;
    float belowY = tex_coord.y+(1.0/dim.y);
    bool atBottom = belowY >= 1.0;
    if (!atBottom){
        vec4 below = texture2D(src_tex_unit0, vec2(tex_coord.x, belowY));
        belowEmpty = isEmpty(below);//below[0] < .5;
    }

    //if I am not empty, and nothing is directly below me
    //then I will be empty next time (I don't care exactly where I end up)
    if (!meEmpty){
        if (belowEmpty){
            willBeEmpty = true;
        } else if (!atBottom){
            //check to the left or right depending on leanRight
            float checkX = tex_coord.x + (leanRight ? 1.0 : -1.0)/dim.x;
            //check one below to see if empty
            vec4 below = texture2D(src_tex_unit0, vec2(checkX, belowY));
            if (below[0] < .5){
                //check n above to see if empty
                float checkY = belowY;
                for(int i = 0; i < numToDo; i++){
                    checkY -= yStepSize;
                    vec4 toCheck = texture2D(src_tex_unit0, vec2(checkX, checkY));
                    if (!isEmpty(toCheck)){//toCheck[0] >= .5){
                        break;
                    } else if (i == numToDo-1){
                        willBeEmpty = true;
                    }
                }
            }
        } else {
            //at bottom
            willBeEmpty = false;
        }
        //otherwise, wibBeEmtpy is already false
    } else {
        //otherwise, I am currently empty
        // is there anything in the spaces above me?
        float newY = tex_coord.y;
        vec4 currPix;
        bool somethingAbove = false;
        for(int i = 0; i<numToDo && !somethingAbove; i++){
            newY -=  yStepSize;
            if (newY < 0.0){
                currPix[0] = 0.0;
                break;
            }
            currPix = texture2D(src_tex_unit0, vec2(tex_coord.x, newY));
            if (!isEmpty(currPix)/*currPix[0] >= .5*/ && i < numToDo-1){
                //we don't want to count the 4th pixel, 
                //just retreive for future ref
                somethingAbove = true;
                leanRight = leansRight(currPix);
            }
        }
        //if something above, and nothing below, I will be empty
        if (somethingAbove){
            willBeEmpty = belowEmpty;
            //if something above, and something below, I will be full
        } else if (!isEmpty(currPix)){//currPix[0] >= .5){
        //if something exactly n spaces up, I will be full
            willBeEmpty = false;
            leanRight = leansRight(currPix);
        } else {
            //check diagonals
            float checkX = tex_coord.x - xStepSize;
            bool atEdge = checkX <= 0.0;
            float checkY = tex_coord.y - yStepSize;
            if (!atEdge){
                vec4 currPix = texture2D(src_tex_unit0, vec2(checkX, checkY));
                if (leansRight(currPix)){
                    //make sure pixel is blocked from below
                    currPix = texture2D(src_tex_unit0, vec2(checkX, tex_coord.y));
                    if (!isEmpty(currPix)){
                        willBeEmpty = false;
                        leanRight = true;
                    }
                }
            }
            if (willBeEmpty){
                checkX += 2.0 * xStepSize;
                atEdge = checkX >= 1.0;
                if (!atEdge){
                    currPix = texture2D(src_tex_unit0, vec2(checkX, checkY));
                    if (!isEmpty(currPix) && !leansRight(currPix)){
                        //make sure pixel is blocked from below
                        currPix = texture2D(src_tex_unit0, vec2(checkX, tex_coord.y));
                        if (!isEmpty(currPix)){
                            willBeEmpty = false;
                            leanRight = false;
                        }
                    }
                }
            }
            //otherwise, nothing above and nothing 4 spaces up
            //and nothing diagonal that wants to be here
            // --- willBeEmpty should already be true
        }
    } 
    if (tex_coord.y < yStepSize/2.0){
        for(int i = 0; i < 4; i++){
            if (additions[i]/dim.x < tex_coord.x + yStepSize/2.0 && additions[i]/dim.x > tex_coord.x - yStepSize/2.0){
                willBeEmpty = false;
                leanRight = additions[i]/dim.x >= tex_coord.x;
            }
        }
    }
/*
    int numBelow = 0;
    float deltaY = tex_coord.y + (4.0*yStepSize);
    for(int i = 0; i<4; i++){
        if (deltaY < 1.0){
            vec4 below = texture2D(src_tex_unit0, vec2(tex_coord.x, deltaY));
            if (below[0] < .5){
                numBelow++;
            }
        }
        deltaY -= yStepSize;
    }
    if (meEmpty){
        numBelow++;
    }
    deltaY = tex_coord.y;
    for(int i = 0; i<4 && numBelow > 0; i++){
        deltaY -= yStepSize;
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
        gl_FragData[0] = vec4((leanRight ? 1.0 : .995),1.0,1.0,1.0);
    }
}
