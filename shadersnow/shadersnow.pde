import processing.opengl.*;
import codeanticode.glgraphics.*;

GLTexturePingPong partPosTex;

GLTextureFilter movePartFilter;

int sec0;
int dropfrom;
boolean dropping = true;
int dropspread = 50;
int currdropspread = 50;

void setup(){
  size(800,600,GLConstants.GLGRAPHICS);
  colorMode(RGB);
  
  initTextures();
  initFilters();
  dropfrom = (int)random(width);
}

void mouseClicked(){
  dropping = !dropping;
  if (dropping){
    dropfrom = (int)random(width);
  } else {
    movePartFilter.setParameterValue("additions", new float[]{-1,-1,-1,-1});
  }
}

void draw(){
  //background(0);
  GLTexture inputTex = partPosTex.getReadTex();
  GLTexture outputTex = partPosTex.getWriteTex();
  
  if (dropping){
    movePartFilter.setParameterValue("additions", new float[]{random(dropspread)+dropfrom, random(dropspread)+dropfrom, random(dropspread)+dropfrom, random(dropspread)+dropfrom});
  }
  
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
                                 
  partPosTex.getReadTex().setRandom(0, 0, 0, 0, 0, 0, 1, 1);
  println("size of texture: " + partPosTex.getReadTex().width + "x" + 
          partPosTex.getReadTex().height);
}

void initFilters(){
  movePartFilter = new GLTextureFilter(this, "MoveSnow.xml");
  movePartFilter.setParameterValue("dim", new float[]{width, height});
}
