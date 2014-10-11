class Shape {
  boolean[][] matrix;
  color c;
  int matrixSize = 4;
  
  Shape(int[] blockNums, color _c) {
  //Shape(int n, int[] blockNums) {
    matrix = new boolean[matrixSize][matrixSize];
    for (int x = 0; x < matrixSize; x++) {
      for (int y = 0; y < matrixSize; y++) {
        matrix[x][y] = false;
      }
    }
    for (int i =0; i < blockNums.length; i++) {
      int x = blockNums[i] % matrixSize;  //can get rid of these, but its less confusing looking
      int y = blockNums[i] / matrixSize;
      matrix[x][y] = true; 
    }
    c = _c;
  }
  
  //custom sizes - optional
  Shape(int n, int[] blockNums, color c) {
    matrix = new boolean[n][n];
    for (int x = 0; x < n; ++x)
      for (int y = 0; y < n; ++y) 
        matrix[x][y] = false;
    for (int i = 0; i < blockNums.length; ++i)
      matrix[blockNums[i]%n][blockNums[i]/n] = true;
    this.c = c;
  }

  
}
