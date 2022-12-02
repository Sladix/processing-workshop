import java.util.Collections;
import java.util.*;
import processing.svg.*;

Grid grid;

int gridRes = 3;

void setup() {
  size(1027, 768, P2D);
  rectMode(CENTER);
  init();
}

void init() {
  grid = new Grid(gridRes, gridRes);
  // Fill the grid with random values
  for (int i = 0; i < grid.w; i++) {
    for (int j = 0; j < grid.h; j++) {
      grid.setCell(i, j, random(0, 1));
    }
  }
  grid.xSymmetry();
}

void update() {
}

void draw() {
  group("general");
  if (button("init")) {
    init();
  }
  gridRes = sliderInt("Grid Resolution", 1, 50, gridRes);
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
  push();
  
  // Draw the grid
  float cellSize = min(width, height) / max(grid.w, grid.h);
  // Compute padding
  float paddingX = (width - cellSize * grid.w) / 2;
  float paddingY = (height - cellSize * grid.h) / 2;

  translate(paddingX, paddingY);
  
  for (int i = 0; i < grid.w; i++) {
    for (int j = 0; j < grid.h; j++) {
      float x = i * cellSize;
      float y = j * cellSize;
      float w = cellSize;
      float h = cellSize;
      float v = grid.getCellValue(i, j);
      fill(v * 255);
      push();
      translate(x + w/2, y + h/2);
      rect(0, 0, w, h);
      pop();
    }
  }
  pop();
}

static class Utils
{
  static String timestamp()
  {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
  }
}
