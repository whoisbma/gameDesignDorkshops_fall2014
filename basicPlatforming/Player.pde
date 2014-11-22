public class Player {
  float w;
  float h;
  PVector pos;
  PVector vel;
  PVector accel;
  float topSpeed = 3; 
  float jumpVel = -8; 
  int accelRate = 2;
  int facing = 1;
  int duckY;
  boolean movingLeft = false; 
  boolean movingRight = false; 
  boolean idle = false; 
  boolean jumping = false; 
  boolean duck = false;
  boolean standUp = false; 
  int jumpCount = 0;
  boolean onGround = false;
  boolean canJump = false; 
  private boolean canMoveRight = true;
  private boolean canMoveLeft = true; 
  java.awt.Rectangle hitbox; 
  color c = color(255, 255, 240);
  //final int sweepDist = 200; 

  Rectangle futureHitbox;

  Player(int x, int y, int w, int h) {
    pos = new PVector(x, y); 
    vel = new PVector(0, 0); 
    accel = new PVector(0, 0);
    this.w = w;
    this.h = h;
    hitbox = new java.awt.Rectangle(x, y, w, h);
  }

  public void update() {
    stateUpdate(); 
    updateMotion(); 
    updateHitbox();
    displayDebug();
    resetVars();
  } 

  public void display() {
    stroke(0);
    fill(c);
    rectMode(CORNER); 
    rect(hitbox.x, hitbox.y, hitbox.width, hitbox.height);
    if (facing == 0) {
      rect(hitbox.x, hitbox.y, hitbox.width/2, hitbox.height/2);
    } else {
      rect((hitbox.x + hitbox.width/2), hitbox.y, hitbox.width/2, hitbox.height/2);
    }
  } 

  private void stateUpdate() {
    if (leftPressed && !rightPressed) {
      if (canMoveLeft) {  //stage 2 implementation
        movingLeft = true; 
        movingRight = false; 
        idle = false;
      } else {
        movingLeft = false;
        movingRight = false; 
        idle = false;
      }
      facing = 0;
    }
    if (rightPressed && !leftPressed) {
      if (canMoveRight) {
        movingRight = true; 
        movingLeft = false; 
        idle = false;
      } else {
        movingRight = false;
        movingLeft = false; 
        idle = false;
      }
      facing = 1;
    } 
    if (!leftPressed && !rightPressed) {
      idle = true; 
      movingRight = false; 
      movingLeft = false;
    } 
    if (shiftPressed && (leftPressed || rightPressed)) {
      topSpeed = 5;
    } else { 
      topSpeed = 3;
    }

    if (downPressed) {
      duck = true;
      println("duck");
    } 
    if (duck && !downPressed) {
      standUp = true;
      println("stand");
    } 

    //DO THIS BEFORE IMPLEMENTING TOTAL ADJACENT METHOD
    //    if (!checkStandingOn(solids)) {
    //      onGround = false; 
    //      c = color(255, 20, 40);
    //    } else { 
    //      onGround = true;
    //      canJump = true;
    //      c = color(205, 240, 240);
    //    }

    //Check adjacency - SECOND IMPLEMENTATION
    boolean[] adjacency = checkAdjacentToSolids(solids); 
    if (adjacency[0]) {  //bottom
      onGround = true;
      jumping = false;
      jumpCount = 0;
      c = color(205, 240, 240);
    } else {
      onGround = false; 
      c = color(255, 20, 40);
    }
    if (adjacency[1]) {  //top
      jumping = false;
    }
    if (adjacency[2]) {  //right
      jumping = false;  //lose momentum against walls
      canMoveRight = false;
      c = color(30, 255, 40);
    } else {
      canMoveRight = true;
    }
    if (adjacency[3]) {  //left
      jumping = false; //lose momentum against walls
      canMoveLeft = false;
      c = color(30, 255, 40);
    } else {
      canMoveLeft = true;
    }
    if (spacePressed && onGround && canJump) {
      jumping = true;  
      onGround = false;
      canJump = false;
    }
    if (!spacePressed) {
      canJump = true;
      jumping = false;
    }

    //held jump key results in a high jump
    if (jumping) {
      if (jumpCount < 7) {
        jumpCount ++;
      } else {
        jumping = false;
      }
    }
  }

  public void updateMotion() {
    //Stop if on ground, otherwise apply gravity
    if (onGround) {
      vel.y = 0;
    } else {
      if (vel.y < -jumpVel) {
        accel.y = gravity;
      }
    }

    //Idle deceleration
    if (idle || duck) { 
      accel.x = 0; 
      if (abs(vel.x) > .1) {
        vel.x -= vel.x * 0.5;
      } else { 
        vel.x = 0;
      }
    } 

    //apply accel to move left
    if (movingLeft) {
      if (vel.x > -topSpeed && canMoveLeft) {
        accel.x = -accelRate;
      }
    }

    //apply accel to move right
    if (movingRight) {
      if (vel.x < topSpeed && canMoveRight) { 
        accel.x = accelRate;
      }
    }

    //leave ground to jump
    if (jumping) {
      onGround = false;
      vel.y = jumpVel;
      canJump = false;
    }

    //limit horizontal speed
    if (vel.x > topSpeed) {
      vel.x = topSpeed;
    } else if (vel.x < -topSpeed) {
      vel.x = -topSpeed;
    }

    if (duck) {
//      this.hitbox.y = (int)pos.y + (int)h/2;
      this.hitbox.height = (int)h/2;
    }

    if (standUp) {
      //hitbox.y = (int)pos.y - (int)h; 
      this.pos.y -= (int)h;
      this.hitbox.y -= (int)h;
      hitbox.height = (int)h;
      standUp = false;
      duck = false;
    }

    futureHitbox = this.hitbox; 
    futureHitbox.x += vel.x*2;
    futureHitbox.y += vel.y*2;

    fill(50, 50, 255); 
    rect(futureHitbox.x, futureHitbox.y, futureHitbox.width, futureHitbox.height); 



    pos.add(vel);  
    vel.add(accel);

    //check for intersections with solids and adjust positions
    for (int i = 0; i < solids.length; i++) {
      if (hitbox.intersects(solids[i])) {
        moveToContactWith(solids[i]);
      }
    }
    checkPickups(pickups);
  }

  //FIRST IMPLEMENTATION - maybe do without array argument for first
  //  public boolean checkStandingOn(java.awt.Rectangle[] solids) {
  //    for (int i = 0; i < solids.length; i++) {
  //      Rectangle offsetRect = new Rectangle(solids[i].x, solids[i].y-1, solids[i].width, solids[i].height);
  //      if (this.hitbox.intersects(offsetRect) && !this.hitbox.intersects(solids[i])) {
  //        return true;
  //      }
  //    }
  //    return false;
  //  }

  //SECOND IMPLEMENTATION - get all adjacency
  public boolean[] checkAdjacentToSolids(java.awt.Rectangle[] solids) {
    //bottom top right left
    boolean[] adjacency = {
      false, false, false, false
    };

    for (int i = 0; i < solids.length; i++) {

      Rectangle offsetRect = new Rectangle(solids[i].x, solids[i].y-1, solids[i].width, solids[i].height);
      stroke(255, 0, 0, 100);
      rect(solids[i].x, solids[i].y-1, solids[i].width, solids[i].height); 
      if (this.hitbox.intersects(offsetRect) && !this.hitbox.intersects(solids[i])) {
        adjacency[0] = true;  //solid underneath
      } 
      offsetRect.y = solids[i].y+1;
      stroke(0, 255, 0, 100);
      rect(solids[i].x, solids[i].y+1, solids[i].width, solids[i].height); 
      if (this.hitbox.intersects(offsetRect) && !this.hitbox.intersects(solids[i])) {
        adjacency[1] = true;  //solid on top
      }
      offsetRect.y = solids[i].y;
      offsetRect.x = solids[i].x - 1;
      stroke(0, 0, 255, 100);
      rect(solids[i].x-1, solids[i].y, solids[i].width, solids[i].height); 
      if (this.hitbox.intersects(offsetRect) && !this.hitbox.intersects(solids[i])) {
        adjacency[2] = true;  //solid to right
      }
      offsetRect.x = solids[i].x + 1;
      stroke(255, 255, 0, 100);
      rect(solids[i].x+1, solids[i].y, solids[i].width, solids[i].height); 
      if (this.hitbox.intersects(offsetRect) && !this.hitbox.intersects(solids[i])) {
        adjacency[3] = true;  //solid to left
      }
    }
    return adjacency;
  }

  //this will also need expanding if the getCollisionDirection(solid) method gets improved. multiple directions/angles
  public void moveToContactWith(java.awt.Rectangle contactObject) {
    if (this.hitbox.intersects(contactObject)) { 
      //Rectangle collRect = new Rectangle(this.hitbox.intersection(contactObject));  //this is an effort to fix those pesky corner collisions
      switch (getCollisionDirection(contactObject)) {
      case 0 : 
        break;
      case 1 :  //left
        vel.x = 0; 
        accel.x = 0;
        this.pos.x = contactObject.x - this.hitbox.width;
        break;
      case 2 : //right
        vel.x = 0;
        accel.x = 0;
        this.pos.x = contactObject.x + contactObject.width; 
        break;  
      case 3 : // top
        onGround = true;  
        vel.y = 0;
        accel.y = 0;
        this.pos.y = contactObject.y - this.hitbox.height;
        break;
      case 4 :  // bottom
        vel.y = 0;
        accel.y = 0; 
        this.pos.y = contactObject.y + contactObject.height;
        break;
      }
    }
  }



  //  //check for multiple results
  //  public void moveToContactWith(java.awt.Rectangle contactObject) {
  //    if (this.hitbox.intersects(contactObject)) { 
  //      //Rectangle collRect = new Rectangle(this.hitbox.intersection(contactObject));  //this is an effort to fix those pesky corner collisions
  //      boolean[] collisionDirection = getCollisionDirection(contactObject);
  //      if (collisionDirection[0] == true) { //horizontal
  //        if (collisionDirection[1] == true) { //left
  //          vel.x = 0;
  //          accel.x = 0;
  //          this.pos.x = contactObject.x - this.hitbox.width;
  //        } else {  //right
  //          vel.x = 0;
  //          accel.x = 0;
  //          this.pos.x = contactObject.x + contactObject.width;
  //        }
  //      } else if (collisionDirection[2] == true) { //vertical
  //        if (collisionDirection[3] == true) { //top
  //          onGround = true;  
  //          vel.y = 0;
  //          accel.y = 0;
  //          this.pos.y = contactObject.y - this.hitbox.height;
  //        } else { //bottom
  //          vel.y = 0;
  //          accel.y = 0; 
  //          this.pos.y = contactObject.y + contactObject.height;
  //        }
  //      }
  //    }
  //  }

  //  //  //an attempt for better results below. didn't quite work. maybe worth discussing though.
  //  private int getXorYFirstCollision(java.awt.Rectangle collisionRect, java.awt.Rectangle solid) {
  //    float distX = collisionRect.width; 
  //    float distY = collisionRect.height; 
  //    float timeX = distX / this.vel.x;
  //    float timeY = distY / this.vel.y; 
  //    if (timeY > timeX) {
  //      println("x collided first"); 
  //      return 0; //collided X axis first
  //    } else if (timeX > timeY) {
  //      println("y collided first"); 
  //      return 1; //collided Y axis first
  //    } else {
  //      //collided at corner -NOT IMPLEMENTED BELOW
  //      return -1;
  //    }
  //  } 

  //this one is very rudimentary and flawed - might need to return an array of bools to get angular results to check against,
  //but probably good enough for the workshop. 
  //alternatively could write two methods, to check vertical & horizontal collisions separately
  //kind of fun to leapfrog up and under things anyway.
  private int getCollisionDirection(java.awt.Rectangle solid) {
    Rectangle collRect = new Rectangle(futureHitbox.intersection(solid));
    //left side
    if (collRect.x == solid.x 
      && (collRect.width < collRect.height || this.vel.y == 0)) {
      // && rightPressed) {
      return 1;
    } 
    //right side
    else if (collRect.x + collRect.width == solid.x + solid.width  && leftPressed 
      && (collRect.width < collRect.height || this.vel.y == 0)) {
      //) {
      return 2;
    } 
    //top
    else if (collRect.y == solid.y 
      && collRect.width > collRect.height) {
      //) {
      return 3;
    } 
    //on the bottom
    else if (collRect.y + collRect.height == solid.y + solid.height 
      && collRect.width > collRect.height) {
      //) {
      return 4;
    }
    return 0;
  }

  /*
  //get multiple results
   private boolean[] getCollisionDirection(java.awt.Rectangle solid) {
   Rectangle collRect = new Rectangle(this.hitbox.intersection(solid));
   boolean vertical = false; 
   boolean horizontal = false; 
   boolean isLeft = false; 
   boolean isTop = false;
   //left side
   if (collRect.x == solid.x) {
   horizontal = true; 
   isLeft = true;
   } 
   //right side
   else if (collRect.x + collRect.width == solid.x + solid.width ) {
   horizontal = true;
   } 
   //top
   else if (collRect.y == solid.y ) {
   vertical = true; 
   isTop = true;
   } 
   //on the bottom
   if (collRect.y + collRect.height == solid.y + solid.height  ) {
   vertical = true;
   }
   if (horizontal && vertical) {
   if (collRect.width > collRect.height) {
   horizontal = false;
   } else {
   vertical = false;
   }
   }
   boolean[] result = {
   horizontal, isLeft, vertical, isTop
   }; 
   return result;
   }
   */
  private void updateHitbox() {
    this.hitbox.x = (int)this.pos.x;
    this.hitbox.y = (int)this.pos.y;
    this.pos.x = this.hitbox.x;
    this.pos.y = this.hitbox.y;
  }

  private void displayDebug() {
    fill(0);
    text("position x " + pos.x + "\n" + "position y " + pos.y, 50, 50); 
    text("velocity x " + vel.x + "\n" + "velocity y " + vel.y, 200, 50); 
    text("accel x " + accel.x + "\n" + "velocity y " + accel.y, 350, 50);
    noFill();
    stroke(255, 0, 0); 
    //ellipse(this.hitbox.x + this.hitbox.width/2 - this.vel.x, this.hitbox.y + this.hitbox.height/2 - this.vel.y, sweepDist, sweepDist);
  } 

  private void resetVars() {
    accel.x = 0;
    accel.y = 0;
    onGround = false;
    canMoveLeft = true;
    canMoveRight = true;
  }

  public void checkPickups(Pickup[] pickups) {
    for (int i = 0; i < pickups.length; i++) {
      if (!pickups[i].collected) {
        if (dist(this.hitbox.x + this.hitbox.width/2, this.hitbox.y + this.hitbox.height/2, pickups[i].pos.x, pickups[i].pos.y) < 10) {
          pickups[i].collected = true;
        }
      }
    }
  } 


  //NOT SURE HOW TO DO THIS.....
  //  private boolean withinSweep(Solid solid) {
  //    if (dist(p1.hitbox.x + p1.hitbox.width/2, p1.hitbox.y + p1.hitbox.height/2, solid.x, solid.y) < sweepDist ||
  //    dist(p1.hitbox.x + p1.hitbox.width/2, p1.hitbox.y + p1.hitbox.height/2, solid.x + solid.width, solid.y) < sweepDist ||
  //    dist(p1.hitbox.x + p1.hitbox.width/2, p1.hitbox.y + p1.hitbox.height/2, solid.x, solid.y + solid.height) < sweepDist ||
  //        dist(p1.hitbox.x + p1.hitbox.width/2, p1.hitbox.y + p1.hitbox.height/2, solid.x + solid.width, solid.y + solid.height) < sweepDist 
  //    
  //    
  //    ) { 
  //  }
}
