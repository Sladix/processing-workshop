import java.util.Collections;
import java.util.*;
import processing.svg.*;

void setup() {
  size(1027, 768, P2D);
  init();
}

void init() {
  
}

void update() {
}

void draw() {
  group("general");
  if (button("init")) {
    init();
  }
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


void drawScene() {
  background(255);
}

static class Utils
{
  static String timestamp()
  {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
  }
}
