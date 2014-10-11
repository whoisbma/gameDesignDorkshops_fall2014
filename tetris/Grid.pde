//GRID CLASS

//needs - position, size, array of colors for cells
//functions - draw, fillSquare, endTurn.

//draw will draw the grid itself, and any grid effects, and call fillSquare on every cell:
//fillSquares will draw a rectangle using the color array at all cells
//end turn will loop through the current shape, and apply its colors to the color grid

//PART 1!----------------------------------------------------------------------

class Grid {
  int x, y;  //x and y for starting position of grid (currently hardcoded)
  int w, h;  //w and h for width and height of grid
  int rows, cols;  // track number of cells across and down
  int[][] colors;   // stores all colors for every grid and col position 

  //in part 3:
  ArrayList<Integer> clearedRows = new ArrayList<Integer>();  //track all cleared rows at a given time
  boolean lineClear = false;

//  Grid(int _x, int _y, int _w, int _h, int _rows, int _cols) {
//    x = _x;
//    y = _y;
//    w = _w;
//    h = _h;
//    rows = _rows;
//    cols = _cols;
//
//    //initialize all cells based on cols and rows    
//    colors = new int[cols][rows];
//    // set all cell colors to black
//    for (int i = 0; i < cols; i++) {
//      for (int j = 0; j < rows; j++) {
//        colors[i][j] = 0;
//      }
//    }
//  }

  //simpler constructor
  Grid() {
    x = 30; 
    y = 15;
    w = width-60; 
    h = height-30;
    rows = 20;
    cols = 10;

    //initialize all cells based on cols and rows    
    colors = new int[cols][rows];
    // set all cell colors to black
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        colors[i][j] = 0;
      }
    }
  }
  
  //draw will draw the grid itself, and any grid effects, and call fillSquare on every cell:
  void draw() {
    stroke(150);
    noFill();
    rect(x-1, y-1, w+1, h+1);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        fillSquare(i, j, colors[i][j]);
      }
    }
    
    //part 3 - for line clearing
    if (lineClear == true) {
      lineClear = false; 
      eraseCleared();
      loadNext();
    }
  }

  //fillSquares will draw a rectangle using the color array at all cells
  void fillSquare(int col, int row, color c) {
    //only fill the squares inside the grid
    if (col < 0 || col >= cols || row < 0 || row >= rows) {
      return;
    }
    //draw rectangle at x position of grid + cell column * (grid width/number of columns), etc.
    noStroke();
    if (c == 0) {
      noFill();
    } else {
      fill(c);
    }
    rect(x + col*(w/cols), y + row*(h/rows), w/cols, h/rows);
  }

//end turn will loop through the current shape, and apply its colors to the color grid, then load a 
  void endTurn() {
    for (int i = 0; i < curr.shape.matrix.length; i++) {
      for (int j = 0; j < curr.shape.matrix.length; j++) {
        if ((curr.shape.matrix[i][j]) == true && (j + curr.y >= 0)) {
          colors[i + curr.x][j + curr.y] = curr.shape.c;
        }
      }
    }
    //this next part for part 3
    if (checkLines()) {
      curr = null;
      lineClear = true;
    } else {
      loadNext();
    }
  }
  
  
//PART 2!!! ----------------------------------------------------------------------
//we need to know when positions inside the grid are occupied, 
//  that's how we can find out if a move is legal.
  boolean isOccupied(int x, int y) {
    if (y < 0 && x < cols && x >= 0) { 
      return false;   //allow movement/flipping to spaces above the board
    }
    return (x >= cols ||
            x < 0 ||
            y >= rows ||
            colors[x][y] != 0);
  }

//PART 3!!!!_________________cleared lines, etc. ____
  boolean checkLines() {
    clearedRows.clear();  //clear all the rows from the arraylist
    for (int j = 0; j < rows; j++) {     //for every y position
      int count = 0;                       
      for (int i = 0; i < cols; i++) {
        if (isOccupied(i,j)) {
          count++;                      //count up for each x position that is occupied
        }
      }
      if (count >= cols) {              //if the count is bigger or equal than the columns
        clearedRows.add(j);             //add that row to the clearedRows arraylist
      }
    }
    if (clearedRows.isEmpty()) {       //if there's nothing in the arrayList return false
      return false;
    }
    //lines += clearedRows.size();  //for keeping score
    return true;                        //returns true if there is at least one row in the arraylist
  }
  
  void eraseCleared() {
    for (int row : clearedRows) {           // different kind of for loop!
      for (int j = row - 1; j > 0; j--) {   //for each row above the cleared row
        int[] rowCopy = new int[cols];         
        for (int i = 0; i < cols; i++) {
          rowCopy[i] = colors[i][j];        //make a copy of the columns in the row
        }
        for (int i = 0; i < cols; i++) {    
          colors[i][j+1] = rowCopy[i];      //shift all the rows down
        }  
      }
    }
  }


}
