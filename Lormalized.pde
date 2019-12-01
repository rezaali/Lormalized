import controlP5.*;
import peasy.*;
import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;
import toxi.geom.*;
import oscP5.*;
import netP5.*; 

OscP5 oscP5;
NetAddress myRemoteLocation;

int tailLength = 30; 
int particleCount = 10000; 
boolean up = true; 
boolean drawGUI = true; 
boolean randomize = false; 
int bgcolor = 255; 

PeasyCam cam; 
PMatrix3D currCameraMatrix;
PGraphics3D g3; 

// camera field of vision and desired clipping planes
float FOV = radians(60);
float CLIP_NEAR=1;
float CLIP_FAR=5000;
Tiler tiler;
int NUM_TILES=4;
String saveFileName = ""; 

ControlP5 controlP5;
Textlabel myTextlabelA; 
Textlabel myTextlabelB; 
Textlabel myTextlabelC;
float vlimit = 60; 
float radius = 400;
float sigma = -11.0; 
float rho = 9.; 
float beta = 6.0; 
float rotatex = 0.01; 


PGraphicsOpenGL pgl;
GL gl;

particle[] p = new particle[particleCount]; 

void setup()
{
//  size(screen.width,screen.height,OPENGL);
  size(1280,720,GLConstants.GLGRAPHICS);
  hint(DISABLE_OPENGL_2X_SMOOTH); 
  hint(ENABLE_OPENGL_4X_SMOOTH); 
  tiler=new Tiler((PGraphics3D)g, NUM_TILES);
  oscP5 = new OscP5(this,8080);
  myRemoteLocation = new NetAddress("127.0.0.1",2000);

  cam = new PeasyCam(this, 1000); 
  cam.setMinimumDistance(CLIP_NEAR);
  cam.setMaximumDistance(CLIP_FAR);  

  frameRate(1000);

  for(int i = 0; i < particleCount; i++)
  {
    p[i] = new particle(); 
  }

  g3 = (PGraphics3D)g;  
  controlP5 = new ControlP5(this);
  controlP5.setColorActive(0xa0090909);
  controlP5.setColorBackground(0x20aaaaaa);
  controlP5.setColorForeground(0xb0777777);
  controlP5.setColorLabel(0x20aaaaaa);
  controlP5.setColorValue(0xb0333333);

  int x = 10; 
  int y = 10; 
  controlP5.addSlider("PARTICLES",0,particleCount,particleCount,x,y,200,15).setId(0);    
  y+=25; 
  controlP5.addSlider("TAIL-LENGTH",0,50,tailLength,x,y,200,15).setId(1);    //Parameters(low,high,default_value,x,y,length,height)
  y+=25; 
  controlP5.addSlider("VELOCITY LIMIT",0,500,vlimit,x,y,200,15).setId(2);
  y+=25; 
  controlP5.addSlider("SPHERE RADIUS",0,1000,radius,x,y,200,15).setId(3);    //Parameters(low,high,default_value,x,y,length,height)
  y+=25; 
  controlP5.addSlider("SIGMA",-100,100,sigma,x,y,200,15).setId(4);
  y+=25; 
  controlP5.addSlider("RHO",-100,100,rho,x,y,200,15).setId(5);    //Parameters(low,high,default_value,x,y,length,height)
  y+=25; 
  controlP5.addSlider("BETA",-100,100,beta,x,y,200,15).setId(6);
  y+=25; 

  controlP5.addButton("SAVE IMAGE",1,x,height-30,60,20).setId(7);
  controlP5.addButton("RESET PARMS",1,width-70,height-30,62,20).setId(8);
  myTextlabelA = controlP5.addTextlabel("label","LORMALIZED BY REZA ALI",width-130,10);
  myTextlabelB = controlP5.addTextlabel("label2","PRESS 'R' to RANDOMIZE",width-130,25);
  myTextlabelC = controlP5.addTextlabel("label3","PRESS 'P' to PAUSE",width-130,40);  

  myTextlabelA.setColorValue(0xb0aaaaaa);
  myTextlabelB.setColorValue(0xb0aaaaaa);
  myTextlabelC.setColorValue(0xb0aaaaaa);

  controlP5.setAutoDraw(false);

  background(0);  
  pgl = (PGraphicsOpenGL) g; //processing graphics object
  gl = pgl.beginGL(); //begin opengl
  gl.setSwapInterval(1); //set vertical sync on
  pgl.endGL(); //end opengl
//  noCursor(); 

    frame.setLocation(0,0);
  //  frame.setAlwaysOnTop(false); 

  oscHandShake(); 
}


void draw()
{ 
  perspective(FOV, (float)width/height, CLIP_NEAR, CLIP_FAR);  
//  if(up)
//  {
////    cam.rotateX(rotatex); 
//  }
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.gl;
  pgl.beginGL();  
  gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
  gl.glEnable (GL.GL_LINE_SMOOTH);
  gl.glHint (GL.GL_LINE_SMOOTH_HINT, GL.GL_NICEST);
  gl.glLineWidth(1);   
  gl.glPointSize(1); 
  gl.glDepthMask(false); 
//  gl.glEnable(GL.GL_DEPTH_TEST);
  gl.glEnable ( GL.GL_LINE_SMOOTH );
  gl.glEnable(GL.GL_BLEND);
  gl.glShadeModel(gl.GL_SMOOTH);  

  //  gl.glEnable(GL.GL_BLEND);
  //  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE_MINUS_SRC_ALPHA);
  background(bgcolor); 

  tiler.pre();
  if( !tiler.isTiling() ) {
    for(int i = 0; i < particleCount; i++) {
      p[i].run();
    }
  }
  
  for(int i = 0; i < particleCount; i++) {
    p[i].draw(); 
  }

  pgl.endGL(); 
  if(drawGUI)
  {
    gui();   
  }
  tiler.post();
}

void axis()
{
  strokeWeight(2);
  stroke(255,0,0);
  line(255,0,0,0,0,0); 

  stroke(0,255,0);
  line(0,255,0,0,0,0); 

  stroke(0,0,255);
  line(0,0,255,0,0,0);  
}
void keyPressed()
{
  println(frameRate);
  if(key == 'p' || key == 'P')
  {
    up = !up;  
    return; 
  }

  if(key == 'o')
  {
    cam.lookAt(0,0,0, random(1000),10);
    return; 
  }

  if(key == 'q')
  {
    sigma++; 
    updateGUI(); 
    return; 
  }
  if(key == 'w')
  {
    rho++; 
    updateGUI();     
    return; 
  }
  if(key == 'e')
  {
    beta++; 
    updateGUI();     
    return; 
  }

  if(key == 'a')
  {
    sigma--;    
    updateGUI();     
    return; 
  }
  if(key == 's')
  {
    rho--;
    updateGUI();     
    return; 
  }
  if(key == 'S')
  {
    int dy = day();    
    int mth = month(); 
    int yr = year();   

    int sec = second();  // Values from 0 - 59
    int mn = minute();  // Values from 0 - 59
    int hr = hour();    // Values from 0 - 23
    saveFileName = "Lormalized-" + mth + "_" + dy + "_" + yr + "_" + hr + "" + mn + "" + sec; 
    pgl.save("images/"+saveFileName+".png"); 

    tiler.initTiles(FOV, CLIP_NEAR, CLIP_FAR);
    tiler.save(sketchPath("images"), saveFileName+ "_tiles", "png");
    //    dosave = true;     
    return; 
  }


  if(key == 'd')
  {
    beta--; 
    updateGUI();     
    return; 
  }
  if(key == '-')
  {
    vlimit-=15;
    updateGUI();
    return; 
  }
  if(key == '=')
  {
    vlimit+=15;
    updateGUI();
    return;  
  }
  if(key == '[')
  {
    radius-=10;
    updateGUI();
    return;  
  }
  if(key == ']')
  {
    radius+=10;
    updateGUI();
    return;  
  }
  if(key == ' ')
  {
    drawGUI = !drawGUI; 
    return;   
  }
  if(key == '\\')
  {
    randomizeSystem(); 
    return; 
  }
}

void gui() 
{  
  imageMode(CORNER);
  tint(255);
  noStroke(); 
  currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  controlP5.draw();
  g3.camera = currCameraMatrix; 
}

//public void init() {
// frame.dispose();  
// frame.setUndecorated(true);
// super.init();  
//} 

void randomizeSystem()
{
  vlimit = random(0,500); 
  radius = random(0,1000);
  sigma = random(-100,100); 
  rho = random(-100,100); 
  beta = random(-100,100); 
  updateGUI();
  up = true;     
}

void randomizeLorenz()
{
  sigma = random(-100,100); 
  rho = random(-100,100); 
  beta = random(-100,100); 
  updateGUI();    
}









