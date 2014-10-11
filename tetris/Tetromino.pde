// PART 1 ------------------------------------------
//the Tetromino is the current shape that we control and move as it goes down the screen
//it has an x and y position that will correspond to the grid cells
//it also will need a final row to see if its above on top of an occupied cell and thus stop its movement
//most importantly, it also has a shape that it gets from a shape object.

//functions -
//step down - move down the board unless it its the finalRow
//draw- - use the object's shape matrix to call the board's fill square on its positions

class Tetromino {
  Shape shape;
  int x, y;
  
  int finalRow;
  
  
  Tetromino(Shape _shape) {
    shape = _shape;  //inherit the shape
    x = 3;
    y = -2;   //start at the middle/top of screen
    finalRow = getFinalRow();
    
    //part 4
    gameOver = !isLegal(shape.matrix, 3, -1);
  }
  
  //step down - move down the board unless it its the finalRow
  void stepDown() {    
    //if (y >= 17) {
    if (y >= finalRow) {
      board.endTurn();
      snd_land.play();
      snd_land.rewind();
    } else {
      y++;
      currTime = 0;
    }
  }
  
  //draw - use the object's shape matrix to call the board's fill square on its positions
  void draw() {
    for (int i = 0; i < shape.matrix.length; i++) {
      for (int j = 0; j < shape.matrix.length; j++) {
        if (shape.matrix[i][j] == true) {
          board.fillSquare(x+i,y+j,shape.c);
        }
      }
    }
  }
  
  //here we're going to check where the final row is and do a couple of other things that need to be checked every frame
  // add this in part 2? after getFinalRow
  void update() {
    finalRow = getFinalRow();
    //reset the timer if player is at the bottom for wiggle room before it locks
    if (y == finalRow) {
      currTime = -20; 
    } 
  } 
  
  
  
// PART 2 ------------------------------------------
//lets add some temporary movement
  void left() {
    if (isLegal(shape.matrix, x-1, y)) {
      x--;
      snd_move.play();
      snd_move.rewind();
    }
    update();
  }
  
  void right() {
    if (isLegal(shape.matrix, x+1, y)) {
      x++;
      snd_move.play();
      snd_move.rewind();
    }
    update();
  }
  
  void down() {
    stepDown();
  }
  
  //we also now can use the "is occupied" method on the grid to check 
  //  for all positions inside the current matrix positions
  boolean isLegal(boolean[][] matrix, int col, int row) {  //array takes the shape matrix, and the desired position
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix.length; j++) {
        if (matrix[i][j] && board.isOccupied(col+i, row+j)) {
          return false;  //return false for every position that is currently occupied or is outside the grid
        }
      }
    }
    return true;   // return true if none of the above positions were occupied
  }
  
  //rotation! 
  void rotate() {
    boolean[][] rotated = new boolean[shape.matrix.length][shape.matrix.length];
    for (int x = 0; x < rotated.length; x++) {
      for (int y = 0; y < rotated.length; y++) {
        rotated[x][y] = shape.matrix[y][rotated.length - 1 - x]; //rotate matrix - http://stackoverflow.com/questions/42519/how-do-you-rotate-a-two-dimensional-array
      }
    }
    if (isLegal(rotated, x, y)) {
      shape.matrix = rotated;
      snd_rotate.play();
      snd_rotate.rewind();
      update();  //add this once we have an update function
    }
    else if (isLegal(rotated, x+1, y)) {  //if can't rotate in place but can rotate to right
      shape.matrix = rotated;
      snd_rotate.play();
      snd_rotate.rewind();
      right();
    }
    else if (isLegal(rotated, x-1, y)) {  //if can't rotate in place but can rotate to left
      shape.matrix = rotated;
      snd_rotate.play();
      snd_rotate.rewind();
      left();
    }   
  }
  
  //return the last row that a shape can land on
  int getFinalRow() {
    int start = max(0,y); 
    for (int row = start; row <= board.rows; row++) {
      if (!isLegal(shape.matrix, x, row)) {
        return row - 1;
      }
    }
    return -1;
  }
  
}
