//shift to run
//down to duck
//otherwise the same

import java.awt.Rectangle;

Player p1;

boolean upPressed = false; 
boolean downPressed = false; 
boolean rightPressed = false; 
boolean leftPressed = false; 
boolean spacePressed = false; 
boolean shiftPressed = false;

float gravity = 0.7;

Pickup[] pickups = new Pickup[5]; 
Rectangle[] solids = new Rectangle[3];

void setup() {
  size(500, 500); 
  noSmooth(); 
  frameRate(60); 
  p1 = new Player(width/2, height/2, 16, 24);
  solids[0] = new Rectangle(0, 450, width-1, 20);
  solids[1] = new Rectangle(110, 410, 40, 20);
  solids[2] = new Rectangle(width-110, 385, 40, 20); 
  
  pickups[0] = new Pickup(100, 400);
  pickups[1] = new Pickup(120, 400);
  pickups[2] = new Pickup(140, 400);
  pickups[3] = new Pickup(160, 400);
  pickups[4] = new Pickup(180, 400);
} 

void draw() {
  background(245); 
  p1.update(); 
  p1.display();
  fill(250);
  for (int i = 0; i < solids.length; i++) {
    solids[i].x = (int)solids[i].x;
    solids[i].y = (int)solids[i].y;
    solids[i].width = (int)solids[i].width;
    solids[i].height = (int)solids[i].height;
    rect(solids[i].x, solids[i].y, solids[i].width, solids[i].height);
  }
  
  for (int i = 0; i < pickups.length; i++) {
    pickups[i].display(); 
  } 
    //println(frameRate);
} 
