//TETRIS
//for MFADT Game Design Dorkshop 2 2014
//bryan ma - @whoisbma
//thanks to Karl Hiner's code at http://www.openprocessing.org/sketch/34481
//also used this javascript code before scrapping in favor of Karl's approach http://codeincomplete.com/posts/2011/10/10/javascript_tetris/
//also found this helpful: http://gamedevelopment.tutsplus.com/tutorials/implementing-tetris-collision-detection--gamedev-852

import ddf.minim.*;
Minim minim;
AudioPlayer snd_rotate;
AudioPlayer snd_move;
AudioPlayer snd_land;
AudioPlayer snd_music;

Grid board;
Tetromino curr;
Shape next;
Shape[] shapes = new Shape[12];
int currTime = 0; 
int timer = 10; 
boolean gameOver = false;

PImage fade;
float rWidth;
float rHeight;
float rWidthMod;
float rHeightMod; 
int counter = 0;

void setup() {
  minim = new Minim(this); 
  snd_rotate = minim.loadFile("turn.wav"); 
  snd_move = minim.loadFile("move.wav"); 
  snd_land = minim.loadFile("land.wav");
  snd_music = minim.loadFile("Tetris.mp3");
  snd_music.play();
  snd_music.loop(); 
  
  size(500, 900);
  textSize(48);
  textAlign(CENTER);
  noSmooth();

  shapes[0] = new Shape(new int[] {8,9,10,11}, color(255)); //I
  shapes[1] = new Shape(new int[] {4,8,9,10}, color(240)); //J
  shapes[2] = new Shape(new int[] {7,9,10,11}, color(225)); //L
  shapes[3] = new Shape(new int[] {5,6,9,10}, color(210)); //O
  shapes[4] = new Shape(new int[] {5,6,8,9}, color(195)); //S
  shapes[5] = new Shape(new int[] {5,8,9,10}, color(180)); //T
  shapes[6] = new Shape(new int[] {4,5,9,10}, color(165)); // Z

  shapes[7] = new Shape(5, new int[] {0,4,5,6,8,9,10,12,14,15,19,20,24}, color(255,0,0));
  shapes[8] = new Shape(5, new int[] {0,1,2,3,4,5,10,11,12,13,15,20}, color(200,150,0));
  shapes[9] = new Shape(5, new int[] {1,2,3,5,9,10,11,12,13,14,15,19,20,24}, color(100,255,0));
  shapes[10] = new Shape(5, new int[] {0,1,2,3,5,9,10,14,15,19,20,21,22,23}, color(0, 200, 100));
  shapes[11] = new Shape(5, new int[] {0,1,2,3,4,7,12,17,22}, color(50, 50, 255));
  /*
  shapes[0] = new Shape(4, new int[] {8,9,10,11});  // I
   shapes[1] = new Shape(3, new int[] {0,3,4,5});  // J
   shapes[2] = new Shape(3, new int[] {2,3,4,5});  // L
   shapes[3] = new Shape(2, new int[] {0,1,2,3});  // O
   shapes[4] = new Shape(4, new int[] {5,6,8,9});  // S
   shapes[5] = new Shape(3, new int[] {1,3,4,5,});  // T
   shapes[6] = new Shape(4, new int[] {4,5,9,10});  // Z
   */

  //board = new Grid(20,20,321,642,20,10);
  board = new Grid();
  next = shapes[(int)random(7)];
  loadNext();
  
  rWidthMod = .99;
  rHeightMod = .995;
  rWidth = width * rWidthMod; 
  rHeight = height * rHeightMod;
  fade = get(0, 0, width, height);
}

void draw() {
  background(0); 
  
//  if (frameCount % 30 == 0) { 
//    rWidth -= 0.01;
//    rHeight -= 0.01;
//  }
    
  tint(random(150,255), random(150,255), random(150,255), 240);
  image(fade, (width-rWidth)/2, (height-rHeight)/2, rWidth, rHeight); 
  noTint(); 
  
  
  //part 4- game over
  if (gameOver) {
    fill(255);
    textSize(80+cos(frameCount*0.1)*20);
    text("BUMMER", width/2, height/2+sin(frameCount*0.03)*50);
    textSize(24);
    text("MFADT GAME DESIGN DORKSHOP #2", width/2, height/2+200);
    text("Tetris, 10 AM October 11 2014", width/2, height/2+230);
    text("Bryan Ma || @whoisbma", width/2, height-100); 
    fade = get(0, 0, width, height);
    return;
  }

  
  currTime++;
  if (currTime >= timer && !board.lineClear) {
    curr.stepDown();
  }
  board.draw();
  
  //if (curr != null) {
    curr.draw();
  //}
  fade = get(0, 0, width, height);
  fill(200);
  
}

//makes the next turn - loads a new shape into the current, and resets the time
void loadNext() {
  curr = new Tetromino(next); 
  /*
  if (counter < 7) {
    next = shapes[(int)random(7)];
    counter++;
  }
  else if (counter >= 7 && counter < 12) {
    next = shapes[counter];
    counter++;
  }
  else {*/
    next = shapes[(int)random(7)];
//  }
  currTime = 0;
}



//PART 2------------------------------------------
void keyPressed() {
  switch(keyCode) {
    case LEFT : curr.left(); break;
    case RIGHT : curr.right(); break;
    case DOWN : curr.down(); break;
    case UP : curr.rotate(); break;
  }
}
