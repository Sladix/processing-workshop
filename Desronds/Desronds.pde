import processing.svg.*;
import java.util.Calendar;

float currentDist = 10;
int currentSubDiv;
float maxSubDivs = 120;
float minSubDivs = 10;


ArrayList<Shape> shapes;

void setup() {
  size(800, 800, P2D);
  shapes = new ArrayList<Shape>();
  noFill();
  rectMode(CENTER);
}

void draw() {
  group("global");
  if (button("gen")) {
    gen();
  }
  background(255);
  push();
  translate(width/2, height/2);

  if (button("export")) {
    beginRecord(SVG, "out/exports/svg/"+Utils.timestamp()+".svg");
    for (Shape s : shapes) {
      s.draw();
    }
    endRecord();
  } else {
    for (Shape s : shapes) {
      s.draw();
    }
  }
  pop();
  group("settings");
  maxSubDivs = slider("maxSubDivs", 120);
  minSubDivs = slider("minSubDivs", 10);
  currentDist = slider("startingDist", 10);
  rec();
  gui();
}

void gen() {
  float ld = currentDist;
  shapes = new ArrayList<Shape>();
  float lastDist = 0;
  while (ld < width/2) {
    currentSubDiv = floor(random(minSubDivs, maxSubDivs));
    float a = TAU/currentSubDiv;
    float s = (TAU * ld) / currentSubDiv;
    int type = floor(random(4));
    for (int i = 0; i < currentSubDiv; i++) {
      float x = cos(a*i) * ld;
      float y = sin(a*i) * ld;
      shapes.add(new Shape(new PVector(x, y), a*i, s, type));
    }
    ld += s/2+lastDist/2;
    lastDist = s;
  }
}

class Shape {
  float x, y, r, s;
  int shape;
  Shape(PVector pos, float rotation, float size, int _s) {
    x = pos.x;
    y = pos.y;
    r = rotation;
    s = size;
    shape = _s;
  }

  void drawShape() {
    switch(shape) {
    case 0:
      rect(0, 0, s, s);
      break;
    case 1:
      ellipse(0, 0, s, s);
      break;
    case 2:
      line(-s/2, 0, s/2, 0);
      break;
    default:
      line(-s/4, 5, s/4, 5);
      line(-s/4, -5, s/4, -5);
      break;
    }
  }

  void draw() {
    push();
    translate(x, y);
    rotate(r);
    drawShape();
    pop();
  }
}

static class Utils
{
  static String timestamp()
  {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
  }
}
