class Enemy {
  PVector pos; 
  PVector vel; 
  boolean alive; 
  int counter; 
  int movement; 
  Rectangle hitbox; 
  int type; 


  Enemy(int x, int y, int w, int h, int type) {
    pos = new PVector(x, y); 
    vel = new PVector(0, 0); 
    alive = true; 
    hitbox = new Rectangle(x, y, w, h);    
    counter = 0;
    movement = 0; 
    this.type = type;
  } 

  public void display() {
    if (alive) {
      fill(255, 0, 0); 
      rect(hitbox.x, hitbox.y, hitbox.width, hitbox.height);
    }
  } 

  public void update() {
    pos.add(vel); 
    counter++;
    if (counter < 70) {
      movement = 1;
    } else if (counter >= 70 && counter < 140) {
      movement = -1;
    } else {
      counter = 0;
    } 

    if (type == 0) {
      vel.x = movement;
    } else {
      vel.y = movement;
    }
    pos.x = (int)pos.x;
    pos.y = (int)pos.y; 
    hitbox.x = (int)pos.x;
    hitbox.y = (int)pos.y; 
  }
}
