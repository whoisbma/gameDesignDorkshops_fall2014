class Grid {
  int x, y; 
  int w, h;
  int rows, cols;
  int[][] colors;
  ArrayList<Integer> clearedRows = new ArrayList<Integer>(); 
  
  Grid(int _x, int _y, int _w, int _h, int _rows, int _cols) {
    x = _x;
    y = _y; 
    w = _w;
    h = _h;
    rows = _rows;
    cols = _cols;
    
    colors = new int[cols][rows];
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        colors[i][j] = 0;
      }
    }
  }
  
  void draw() {
    stroke(150);
    fill(0); 
    rect(x, y, w, h);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        
        fillSquare(i,j,colors[i][j]);
      }
    }
  }
  
  void fillSquare(int col, int row, color c) {
    noStroke(); 
    fill(c); 
    rect(x+col*(w/cols), y+row*(h/rows), w/cols, h/rows);
    
  }
  
  void endTurn( ) {
    //tell the current Tetromino's shape to stay where it is
    //loadNext
    for (int i = 0; i < curr.shape.matrix.length; i++) {
      for (int j =0; j < curr.shape.matrix.length; j++) {
        if (curr.shape.matrix[i][j] == true && (j + curr.y >= 0)) {
          colors[i + curr.x][j + curr.y] = curr.shape.c;
        }
      }
    }
    if (checkLines()) {
      curr = null;
      eraseCleared(); 
      loadNext(); 
    } else {
      loadNext();
    }
  }
  
  boolean isOccupied(int i, int j) {
    if (j < 0 && i < cols && i >= 0) {
      return false; 
    }
    return (i >= cols ||
            i < 0 ||
            j >= rows ||
            colors[i][j] != 0);
  }
  
  boolean checkLines() {
    clearedRows.clear();
    for (int j = 0; j < rows; j++) {
      int count = 0;
      for (int i = 0; i < cols; i++) {
        if (isOccupied(i,j)) {
          count++;
        }
      }
      if (count >= cols) {
        clearedRows.add(j); 
      }
    }
    if (clearedRows.isEmpty()) {
      return false;
    }
    return true;
  }
  
  void eraseCleared() {
    for (int row : clearedRows) {
      for (int j = row - 1; j > 0; j--) {
        int[] rowCopy = new int[cols];
        for (int i = 0; i < cols; i++) {
          rowCopy[i] = colors[i][j];
        }
        for (int i = 0; i < cols; i++) {
          colors[i][j+1] = rowCopy[i];
        }
      }
    }
  } 
  
}
