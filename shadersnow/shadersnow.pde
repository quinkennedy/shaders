import processing.opengl.*;
import codeanticode.glgraphics.*;

GLTexturePingPong partPosTex;

GLTextureFilter movePartFilter;

int sec0;

void setup(){
  size(800,600,GLConstants.GLGRAPHICS);
  colorMode(RGB);
  
  initTextures();
  initFilters();
}

void draw(){
  //background(0);
  GLTexture inputTex = partPosTex.getReadTex();
  GLTexture outputTex = partPosTex.getWriteTex();
  
  movePartFilter.setParameterValue("additions", new float[]{random(20), random(20), random(20), random(20)});
  
  movePartFilter.apply(inputTex, outputTex);
  image(outputTex, 0, 0, width, height);
  partPosTex.swap();
  
  int sec = second();
  if (sec != sec0){println("FPS: "+frameRate);}
  sec0 = sec;
}

void initTextures(){
  GLTextureParameters filterTexParams = new GLTextureParameters();
  filterTexParams.minFilter = GLTexture.NEAREST_SAMPLING;
  filterTexParams.magFilter = GLTexture.NEAREST_SAMPLING;
  partPosTex = new GLTexturePingPong(new GLTexture(this, width, height, filterTexParams),
                                    new GLTexture(this, width, height, filterTexParams));
                                 
  partPosTex.getReadTex().setRandom(0, .6, 0, 0, 0, 0, 1, 1);
  println("size of texture: " + partPosTex.getReadTex().width + "x" + 
          partPosTex.getReadTex().height);
}

void initFilters(){
  movePartFilter = new GLTextureFilter(this, "MoveSnow.xml");
  movePartFilter.setParameterValue("dim", new float[]{width, height});
}
