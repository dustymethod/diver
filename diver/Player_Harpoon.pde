//moves from player's position (origin) to mouse (target)
class Harpoon {
  PVector position, velocity, acceleration;
  PVector direction, target;
  float hlength;
  float maxThrowForce = 60;
  float minThrowForce = 10;
  float throwForce = minThrowForce; //power of throw
  float mass = 1;
  boolean isThrown;
  boolean isAiming;
  PVector gravity = new PVector(0, 1);
  float angle; //throwing angle
  //float accuracy;
  float hitBox = 20;
  
  Harpoon() {
    if (width > 720) { //#largescreen
      maxThrowForce = 100;
    }
    velocity = new PVector(0,0);
  }
  
  //charge throw force when aiming
  void aimHarpoon() {
    if (throwForce < maxThrowForce) {
      throwForce ++;
    }
  }
  
  void throwHarpoon(PVector t) { //t target
    target = t;
    target.mult(random(1, 1.1)); //inaccuracy factor
    isThrown = true;
    direction = PVector.sub(target, position);
    direction.normalize();
    direction.mult(throwForce);
    acceleration = direction;
    throwForce = minThrowForce; //reset
  }
  
  void updateHarpoon() {
    //Harpoon being aimed
    if (LMB && !isThrown) {
      isAiming = true;
      angle = atan2(mouseY-player.position.y+30, mouseX - player.position.x); //aim at player
    }
    else {
      isAiming = false;
    }
    //Harpoon thrown
    if (isThrown) {
      acceleration.add(gravity);
      velocity.add(acceleration);
      velocity.mult(.2);
      position.add(velocity);
      //if (player.forward) { //disabled
      //  position.x -= player.velocity.x;
      //}
      
      //collision check with window bounds. reset if harpoon goes off screen
      if (position.y > height ||  position.x < 0 || position.x > width) {
        isThrown = false;
      }
    }
    else { //when not being aimed or thrown, set position to player's position.
      position = new PVector(player.position.x, player.position.y -30);
    }
  }
  
  //display harpoon depending on it's state (isThrown, isAiming or holstered)
  void displayHarpoon() {
    float l = 22;
    strokeWeight(2);
    noFill();
    stroke(255); //harpoon color
     //display thrown harpoon
    if (isThrown) {
      pushMatrix();
      translate(position.x, position.y);
      rotate(angle);
      line(-l, 0, l, 0);
      popMatrix();
    }
    else {
      //display harpoon in player's hand (aiming)
      if (isAiming) {
        pushMatrix();
        translate(player.position.x, player.position.y-30);
        rotate(angle);
        line(-l, 0, l, 0);
        popMatrix();
      }
      else { //not being aimed
        //display "holstered" harpoon, depending on which direction player is facing
        if (player.isFacingLeft) {
          line(player.position.x+14, player.position.y -40, player.position.x+14, player.position.y-10);
        }
        else{
          line(player.position.x-14, player.position.y -40, player.position.x-14, player.position.y-10);
        }
      }
    }
    strokeWeight(1); //reset
    if (showDebug)
    rect(position.x, position.y, hitBox, hitBox); //harpoon hitbox
  }
}