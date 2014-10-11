class Tetromino {
  Shape shape; 
  int x, y;
  int finalRow; 
  
  Tetromino(Shape _shape) {
    shape = _shape;
    x = 3; 
    y = -2;
    finalRow = getFinalRow(); 
    gameOver = !isLegal(shape.matrix,3,-1); 
  }
  
  void draw() {
    for (int i = 0; i < shape.matrix.length; i++) {
      for (int j = 0; j < shape.matrix.length; j++) {
        if (shape.matrix[i][j] == true) {
          board.fillSquare(x+i,y+j,shape.c);
        }
      }
    } 
  }
  
  void stepDown() {
    if (y >= finalRow) {
      board.endTurn();
    } else {
      y++;
      currTime = 0; 
    }
  } 
  
  void left() {
    if (isLegal(shape.matrix, x-1,y)) {//is move to left legal?
      x--;
    }
    update(); 
  } 
  
  void right() {
    if (isLegal(shape.matrix, x+1,y)) {//is move to right legal
      x++;
    }
    update(); 
  } 
  
  void down() {
    stepDown(); 
  } 
  
  void rotate() {
    boolean[][] rotated = new boolean[shape.matrix.length][shape.matrix.length];
    for (int i = 0; i < rotated.length; i++) {
      for (int j = 0; j < rotated.length; j++) {
        rotated[i][j] = shape.matrix[j][rotated.length- 1-i];
      }
    }
    if (isLegal(rotated, x, y)) {
      shape.matrix = rotated;
      //update in here somewhere
    } else if (isLegal(rotated, x+1, y)) {
      shape.matrix = rotated;
      right();
    } else if (isLegal(rotated, x-1,y)) {
      shape.matrix = rotated;
      left(); 
    } 
    
  }
  
  boolean isLegal(boolean[][] matrix, int col, int row) { //some arguments in here?? position, col, row
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix.length; j++) {
        if (matrix[i][j] == true && board.isOccupied(col+i, row+j)) {
          return false;
        }
      }
    }
    return true; 
  }
  
  int getFinalRow() {
    int start = max(0, y);
    for (int row = start; row <= board.rows; row++) {
      if (!isLegal(shape.matrix, x, row)) {
        return row - 1;
      }
    }
    return -1;    
  }
  
  void update() {
    finalRow = getFinalRow();
    if (y == finalRow) {
      currTime = -20;
    }
  }
  
}
