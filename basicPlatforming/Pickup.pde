class Pickup { 
  PVector pos; 
  boolean collected;
  
  Pickup(int x, int y) {
    pos = new PVector(x,y); 
  
  }
  
  public void display() {
   if (!collected) { 
      ellipse(pos.x,pos.y,10,13);
    } 
  } 
  
  public void update() {
    
    
  } 
  
} 
