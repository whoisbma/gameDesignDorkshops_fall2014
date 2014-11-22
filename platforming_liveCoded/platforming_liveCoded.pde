//need a player object
//need platforms

import java.awt.Rectangle; 

Player p1; 

Rectangle[] solids = new Rectangle[3]; 
Pickup[] pickups = new Pickup[5]; 
Enemy[] enemies = new Enemy[2]; 


boolean upPressed, downPressed, leftPressed, rightPressed, spacePressed;
float gravity = 0.7;

void setup() {
  size(500,500); 
  frameRate(60);  
  
  p1 = new Player(width/2, height/2, 16,24);
  
  enemies[0] = new Enemy(350,430,36,16,0);
  enemies[1] = new Enemy(300,340,36,16,1); 
  
  solids[0] = new Rectangle(0, 450, width-1, 20);
  solids[1] = new Rectangle(110, 410, 40, 20);
  solids[2] = new Rectangle(width-110, 385, 40, 20); 
  
  pickups[0] = new Pickup(100,400); 
  pickups[1] = new Pickup(120,400); 
  pickups[2] = new Pickup(140,400); 
  pickups[3] = new Pickup(160,400); 
  pickups[4] = new Pickup(180,400); 
  
} 

void draw() {
  background(255); 
  p1.update(); 
  p1.display(); 
  
  for (int i = 0; i < solids.length; i++) {
    stroke(10); 
    fill(255); 
    rect(solids[i].x, solids[i].y, solids[i].width, solids[i].height);
  } 
  
  for(int i = 0; i < pickups.length; i++) {
    pickups[i].display(); 
  } 
  
  for (int i = 0; i < enemies.length; i++) {
    enemies[i].update(); 
    enemies[i].display(); 
  } 
}
