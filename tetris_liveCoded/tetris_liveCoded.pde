//TETRIS
//for MFADT Game Design Dorkshop 2 2014
//live coded version
//bryan ma - @whoisbma
//thanks to Karl Hiner's code at http://www.openprocessing.org/sketch/34481
//also used this javascript code before scrapping in favor of Karl's approach http://codeincomplete.com/posts/2011/10/10/javascript_tetris/
//also found this helpful: http://gamedevelopment.tutsplus.com/tutorials/implementing-tetris-collision-detection--gamedev-852


Shape[] shapes = new Shape[7];
Grid board;
Tetromino curr;
int currTime = 0; 
int timer = 5; 
Shape next;
boolean gameOver = false; 


void setup() {
  size(400, 700); 
  noSmooth(); 
  shapes[0] = new Shape(new int[] {1,5,9,13}); //I
  shapes[1] = new Shape(new int[] {4,8,9,10}); //J
  shapes[2] = new Shape(new int[] {7,9,10,11}); //L
  shapes[3] = new Shape(new int[] {5,6,9,10}); //O
  shapes[4] = new Shape(new int[] {5,6,8,9}); //S
  shapes[5] = new Shape(new int[] {5,8,9,10}); //T
  shapes[6] = new Shape(new int[] {4,5,9,10}); //Z
  board = new Grid(30, 15, width-60, height-30, 20, 10);
  next = shapes[(int)random(7)];
  loadNext();
}

void draw() {
  background(0);
  
  if (gameOver) { 
    fill(255); 
    textSize(70);
    textAlign(CENTER);
    text("game over", width/2, height/2);
    return;
  } 
  
  currTime++;
  if (currTime >= timer) {
    curr.stepDown(); 
  }
  board.draw(); 
  curr.draw(); 
  
}

void loadNext() {
  curr = new Tetromino(next);
  next = shapes[(int)random(7)];
  currTime = 0; 
  
}

void keyPressed() { 
  switch(keyCode) {
    case LEFT : curr.left(); break;
    case RIGHT : curr.right(); break;
    case DOWN : curr.down(); break;
    case UP : curr.rotate(); break; 
  }
} 
