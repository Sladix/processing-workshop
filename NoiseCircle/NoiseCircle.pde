import java.util.Collections;
import java.util.*;
import processing.svg.*;


void setup() {
  size(1027, 768, P2D);
}

void draw() {
  background(255);
  group("capture");
  if (button("export")) {
    beginRecord(SVG, "out/exports/svg/" + Utils.timestamp() + ".svg");
    drawScene();
    endRecord();
  } else {
    drawScene();
  }
  gui();
  rec();
}

float to = 0;
void drawScene() {
  group("Scene");
  int res = sliderInt("resolution", 100);
  int numRotations = sliderInt("numRotations", 50);
  float startingDist = slider("startingDist");
  float distInc = slider("distInc", 0.03, 0.01);
  int numPoints = floor(numRotations * res);
  float dist = startingDist;
  float a = TAU / res;
  group("Noise");
  float disturbAmount = slider("disturbAmount", 10., 10.);
  float ns = slider("NosieScale", 0.01, 0.001);


  pushMatrix();
  translate(width/2, height/2);
  noFill();
  stroke(0);
  beginShape();
  for (int i = 0; i < numPoints; i++) {
    float x = cos(a*i) * dist;
    float y = sin(a*i) * dist;
    float nx = x;
    float ny = y;
    float nv = noise(nx*ns,ny*ns+to);
    float nv2 = noise(nx*(ns/10)-1337,ny*(ns/10)+to+1337);
    float b = 0;
    b = map(nv+nv2, 0, 2, -disturbAmount, disturbAmount);//; * sin(i+cos(x-sin(y)));//* cos(i+sin(noise(y,x))/cos(x)*sin(x));
    PVector p = new PVector(x, y);
    //np.setMag(np.mag()+b*morphDist);
    if(dist < disturbAmount){
      b *= 0.1+(dist/disturbAmount);
    }
    
    p.setMag(p.mag()+b);
    vertex(p.x, p.y);
    dist+= distInc;
  }
  if(!toggle("paused")){
    to+=slider("timePasses", 0.001, 0.001);
  }
  endShape();
  popMatrix();
}

static class Utils
{
  static String timestamp()
  {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
  }
}
