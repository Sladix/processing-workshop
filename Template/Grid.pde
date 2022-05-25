class Grid {
  int h, w;
  Cell[][] cells;
  Grid(int _width, int _height) {
    h = _height;
    w = _width;
    cells = new Cell[w][h];

    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        cells[x][y] = new Cell();
      }
    }
  }

  Cell getCell(int x, int y) {
    if (x < 0 || x >= w || y < 0 || y >= h) {
      return null;
    }
    return cells[x][y];
  }

  Cell setCell(int x, int y, int value) {
    return getCell(x, y).setValue(value);
  }
  
  int getCellValue(int x, int y){
    return getCell(x, y).getValue();
  }
  
  void xSymmetry(){
    int xMax = ceil(w / 2);
    for (int x = 0; x < xMax; x++) {
      for (int y = 0; y < h; y++) {
        Cell c = getCell(x, y);
        int otherX = w - 1 - x;
        setCell(otherX, y, c.getValue());
      }
    }
  }
}

class Cell {
  private int value = 0;

  Cell() {
  }
  
  Cell(int _value) {
    value = _value;
  }

  Cell setValue(int v) {
    value = v;
    return this;
  }
  
  int getValue(){
    return value;
  }
}
