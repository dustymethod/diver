//INPUT//
void keyPressed() {
  if (key == 'a' || keyCode == LEFT) { //move left
    akey = true;
  }
  if (key == 'd' || keyCode == RIGHT) { //move right
    dkey = true;
  }
  if (key == ' ') { //jump
    spacebar = true;
  }

  if (key == 'r') { //reset
    setup();
  }
}
void keyReleased() {
  if (key == 'a' || keyCode == LEFT) { //move left
    akey = false;
  }
  if (key == 'd' || keyCode == RIGHT) { //move right
    dkey = false;
  }
  if (key == ' ') { //jump
    spacebar = false;
  }
  if (key == TAB) { //show/hide instructions
    if (displayInstr)
    displayInstr = false;
    else
    displayInstr = true;
  }
  
  //show/hide debug stuff
  if (key == 'u') {
    if (showDebug) {
      showDebug = false;
    }
    else
    showDebug = true;
    println("debug: " + showDebug);
  }
  if (key == 'i') {
    if (showDebug) {
      mixColors();
    }
  }
  if (key == 'p') { //take screenshot
    //saveFrame("line-######.jpg");
    saveFrame("line-######.tif");
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    LMB = true;
    player.isAiming = true;
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    LMB = false;
  }
}