public class Player {
  PVector pos; 
  PVector vel; 
  PVector accel; 
  float w; 
  float h; 
  float x; 
  java.awt.Rectangle hitbox; 
  boolean movingLeft; 
  boolean movingRight;
  boolean jumping;
  boolean onGround; 
  boolean idle; 
  boolean canJump; 

  float topSpeed = 3;
  float accelRate = 2;
  float decayRate = 0.5;
  float jumpVel = -10; 

  Player(int x, int y, int w, int h) {
    this.pos = new PVector(x, y); 
    this.vel = new PVector(0, 0); 
    this.accel = new PVector(0, 0); 
    this.w = w;
    this.h = h;
    this.hitbox = new java.awt.Rectangle(x, y, w, h);
  }

  private void stateUpdate() {
    if (leftPressed && !rightPressed) {
      movingLeft = true; 
      movingRight = false;
      idle = false;
    } 
    if (rightPressed && !leftPressed) {
      movingRight = true;
      movingLeft = false;
      idle = false;
    }
    if (!leftPressed && !rightPressed) {
      idle = true; 
      movingLeft = false;
      movingRight = false;
    }
    if (spacePressed && onGround && canJump) {
      jumping = true; 
      onGround = false; 
      canJump = false;
    } 

    if (!spacePressed) {
      jumping = false; 
      canJump = true;
    }

    boolean[] adjacency = checkAdjacentTo(solids); 
    if (adjacency[0]) {
      onGround = true; 
      //jumping = false;
    } else {
      onGround = false;
    }
  }

  private void motionUpdate() {
    if (idle) {
      accel.x = 0;
      if (abs(vel.x) > 0.1) {
        vel.x -= vel.x * decayRate;
      } else {
        vel.x = 0;
      }
    } 

    if (movingLeft) {
      if (vel.x > -topSpeed) {       
        accel.x = -accelRate;
      }
    } 

    if (movingRight) {
      if (vel.x < topSpeed) {
        accel.x = accelRate;
      }
    } 


    if (jumping) {
      onGround = false; 
      vel.y = jumpVel; 
      jumping = false;
    }

    if (onGround) {
      vel.y = 0;
    } else {
      if (vel.y < -jumpVel) {
        accel.y = gravity;
      }
    }

    vel.add(accel); 
    pos.add(vel);

    checkPickups(pickups); 
    checkEnemies(enemies); 
    for (int i = 0; i < solids.length; i++) {
      if (this.hitbox.intersects(solids[i])) {
        moveToContactWith(solids[i]);
      }
    }
  }  

  public void update() {
    stateUpdate(); 
    motionUpdate(); 


    updateHitbox();
    resetVars();
    //println("can jump " + canJump);
  } 

  private void resetVars() {
    accel.x = 0; 
    accel.y = 0;
  } 

  public void display() {
    stroke(0); 
    fill(230); 
    rectMode(CORNER); 
    rect(hitbox.x, hitbox.y, hitbox.width, hitbox.height);
  } 

  private void updateHitbox() {
    this.hitbox.x = (int)this.pos.x;
    this.hitbox.y = (int)this.pos.y; 
    this.pos.x = this.hitbox.x;
    this.pos.y = this.hitbox.y;
  }

  private int getCollisionDirection(java.awt.Rectangle solid) {
    Rectangle collRect = new Rectangle(this.hitbox.intersection(solid));
    //left 
    if (collRect.x == solid.x) {
      return 1;
    } 
    //right
    else if (collRect.x + collRect.width == solid.x + solid.width) {
      return 2;
    } 
    //bottom
    else if (collRect.y == solid.y) {
      return 3;
    } 
    //top
    else if (collRect.y + collRect.height == solid.y + solid.height) {
      return 4;
    } 
    return 0;
  } 

  private void moveToContactWith(java.awt.Rectangle solid) {
    if (this.hitbox.intersects(solid)) {
      switch (getCollisionDirection(solid)) {
      case 0: 
        break; 
      case 1:  //solid to right
        vel.x = 0; 
        accel.x = 0; 
        this.pos.x = solid.x - this.hitbox.width;
        break;
      case 2:  //solid to left
        vel.x = 0; 
        accel.x = 0;
        this.pos.x = solid.x + solid.width;
        break; 
      case 3:  //solid underneath 
        onGround = true; 
        vel.y = 0; 
        accel.y = 0; 
        this.pos.y = solid.y - this.hitbox.height;
        break;
      case 4: //solid on top 
        vel.y = 0; 
        accel.y = 0; 
        this.pos.y = solid.y + solid.height; 
        break;
      }
    }
  } 

  private boolean[] checkAdjacentTo(java.awt.Rectangle[] solids) {
    //bottom top right left
    boolean[] adjacency = {
      false, false, false, false
    }; 
    for (int i = 0; i < solids.length; i++) {
      Rectangle offsetRect = new Rectangle(solids[i].x, solids[i].y-1, solids[i].width, solids[i].height);
      stroke(255, 0, 0, 100); 
      rect(offsetRect.x, offsetRect.y, offsetRect.width, offsetRect.height);
      if (this.hitbox.intersects(offsetRect) && !this.hitbox.intersects(solids[i])) {
        adjacency[0] = true;  //solid underneath
      } 
      offsetRect.y = solids[i].y+1;
      stroke(0, 255, 0, 100); 
      rect(offsetRect.x, offsetRect.y, offsetRect.width, offsetRect.height);
      if (this.hitbox.intersects(offsetRect) && !this.hitbox.intersects(solids[i])) {
        adjacency[1] = true;  //solid above
      }
      offsetRect.y = solids[i].y;
      offsetRect.x = solids[i].x - 1;
      stroke(0, 0, 255, 100); 
      rect(offsetRect.x, offsetRect.y, offsetRect.width, offsetRect.height);
      if (this.hitbox.intersects(offsetRect) && !this.hitbox.intersects(solids[i])) {
        adjacency[1] = true;  //solid to right
      }
      offsetRect.x = solids[i].x + 1;
      stroke(255, 0, 255, 100); 
      rect(offsetRect.x, offsetRect.y, offsetRect.width, offsetRect.height);
      if (this.hitbox.intersects(offsetRect) && !this.hitbox.intersects(solids[i])) {
        adjacency[1] = true;  //solid to left
      }
    }
    return adjacency;
  }

  public void checkPickups(Pickup[] pickups) {
    for (int i = 0; i < pickups.length; i++) {
      if (!pickups[i].collected) {
        if (dist(this.hitbox.x + this.hitbox.width/2, 
        this.hitbox.y + this.hitbox.height/2, 
        pickups[i].pos.x, pickups[i].pos.y) < 10) {
          pickups[i].collected = true;
        }
      }
    }
  } 

  public void checkEnemies(Enemy[] enemies) {
    for (int i = 0; i < enemies.length; i++) {
      if (enemies[i].alive) {
        if (this.hitbox.intersects(enemies[i].hitbox)) {
          switch (getCollisionDirection(enemies[i].hitbox)) {
            case 0: break;
            case 1: pos.x = width/2; pos.y = height/2; break;//player takes damage
            case 2: pos.x = width/2; pos.y = height/2; break;
            case 3: enemies[i].alive = false; break;
            case 4: pos.x = width/2; pos.y = height/2; break;
          }
        }
      }
    }
  }
}
