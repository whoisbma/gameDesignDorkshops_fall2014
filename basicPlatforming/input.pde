
void keyPressed() {
  if (keyCode == UP) {
    if (!upPressed) {
      upPressed = true;
    }
  }
  if (keyCode == DOWN) {
    if (!downPressed) {
      downPressed = true;
    }
  }
  if (keyCode == RIGHT) {
    if (!rightPressed) {
      rightPressed = true;
    }
  }
  if (keyCode == LEFT) {
    if (!leftPressed) {
      leftPressed = true;
    }
  }
  if (key == ' ') { 
    if (!spacePressed) {
      spacePressed = true;
    }
  }
  if (keyCode == SHIFT) {
    if (!shiftPressed) {
      shiftPressed = true;
    }
  }
} 

void keyReleased() {
  if (keyCode == UP) {
    if (upPressed) {
      upPressed = false;
    }
  }
  if (keyCode == DOWN) {
    if (downPressed) {
      downPressed = false;
    }
  }
  if (keyCode == RIGHT) {
    if (rightPressed) {
      rightPressed = false;
    }
  }
  if (keyCode == LEFT) {
    if (leftPressed) {
      leftPressed = false;
    }
  }
  if (key == ' ') { 
    if (spacePressed) {
      spacePressed = false;
    }
  }
  if (keyCode == SHIFT) {
    if (shiftPressed) {
      shiftPressed = false;
    }
  }
} 
