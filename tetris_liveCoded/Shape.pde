class Shape {
  boolean[][] matrix; 
  int matrixSize = 4; 
  color c; 
  
  Shape(int[] blockNums) {
    matrix = new boolean[matrixSize][matrixSize];
    for (int x = 0; x < matrixSize; x++) {
      for (int y = 0; y < matrixSize; y++) { 
        matrix[x][y] = false;
      }
    }
    for (int i = 0; i < blockNums.length; i++) {
      int x = blockNums[i] % matrixSize;
      int y = blockNums[i] / matrixSize;
      matrix[x][y] = true;
    }
    c = color(255);
  }
  
  
  
}
