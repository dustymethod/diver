//

//color cPEmissiveColor; //player's flashlight color
class Player {
  float size = 35; //diameter of head
  float w = 5; float h = 60; //approximate w and height of player
  float mass = 1;
  PVector position, velocity, acceleration;
  boolean forward, isFacingLeft; //if player is at center of screen, and velocity positive
  boolean isEmitting; //true if player is emmitting light (fkey)
  float topspeed;
  float moveForce = 0.1;
  PVector jumpForce = new PVector(0, -5);
  PVector gravity = new PVector(0, 0.1);
  
  int level;
  float energy;
  //float brightness = 50; //default brightness
  int energyTimer = 0;
  
  Harpoon harpoon;
  boolean isAiming;
  Eye eye;
  
  //move to displayBG?
  float lborderAlpha, rborderAlpha;// alpha for indicators showing border
  //float uiAlpha; //alpha for indicator, when player can't throw harpoon //#disabled
  float lvlupAlpha; //alpha for screen flash when player levels up
  
  Player() {
    position = new PVector(width/2, height-75);
    velocity = new PVector(0,0);
    acceleration = new PVector(0, 0);
    harpoon = new Harpoon();
    energy = 0; //starting energy
    topspeed = 2;
    eye = new Eye(size);
  }
  
  void updatePlayer() {
    inputListener();
    movePlayer();
    checkEdges();
    harpoon.updateHarpoon();
  }
  
  //manage player input
  void inputListener() {
    if (dkey) { //moveRight
      applyForce(new PVector(moveForce, 0));
    }
    if (akey) { //move left
      applyForce(new PVector(-moveForce, 0));
    }
    if (spacebar) { //jump
      jump();
    }
    //#check use of LMB
    if (LMB && harpoon.isThrown == false) {
      harpoon.aimHarpoon(); //charge harpoon throw force
    }
    if (isAiming && !LMB) { //throwHarpoon at mouse
      throwHarpoon(new PVector(mouseX, mouseY));
      LMB = false;
    }
  }
  
  void throwHarpoon(PVector target) {
    if (!harpoon.isThrown) {
      harpoon.throwHarpoon(target);  
      isAiming = false;
    }
  }

  //apply movement force if akey or dkey pressed
  void applyForce(PVector force) {
    PVector f = force;
    acceleration.add(f);
  }
  
  
  //player moves while in left half of screen, 
  //screen moves if player in center of screen and moving right
  void movePlayer() {
    float c = .05;
    PVector friction = velocity.get();
    friction.normalize();
    friction.mult(-c);
    applyForce(gravity);
    applyForce(friction);
    
    //Add Velocity
    velocity.add(acceleration);
    velocity.limit(topspeed);
    position.x += velocity.x;
    position.y += velocity.y;
    
    //determine facing direction, 
    if (velocity.x > 0) {
     isFacingLeft = false;
    }
    else if (velocity.x < 0){
     isFacingLeft = true;
    }
    else {
    }
  }
  
  //check edges and limit values
  void checkEdges() {
    //when landing, reverse velocity to "bounce"
    if (position.y > terrain.getGroundHeight(position)) {
      velocity.y *= -0.4; //bounce factor
      position.y = terrain.getGroundHeight(position);
    }
    //left boundary
    if (position.x < 22) {
      position.x = 22;
      lborderAlpha = 80;
    }
    //right boundary
    if (position.x > width- 22) {
      position.x = width- 22;
      rborderAlpha = 80;
    }
    //eliminate unecessary decimal places if at nominal velocity
    if (velocity.mag() < 0.05) {
      velocity.mult(0);
    }
    acceleration.mult(0); //clear acceleration
    
    //cap energy
    if (energy > 255) {
      energy = 255;
    }
  }
  
  void jump() {
    //min height player can jump at. (prevent double jump)
    if (position.y >= terrain.getGroundHeight(position) -1) {
      jumpForce.x = player.velocity.x*2;
      applyForce(jumpForce);
    }
  }
  
  void displayPlayer() {
    fill(0, 150);
    stroke(mainColor, 150);
    strokeWeight(1);
    //draw head
    ellipse(position.x, position.y-h, size, size); //head
    
    //draw body
    triangle(position.x,   position.y -35,
             position.x-w, position.y,
             position.x+w, position.y);
    
    //draw slight lens flare effect
    float r = map(energy, 50, 255, 70, 80);
    noFill();
    stroke(0,255,116, map(energy, 0, 255, 0, 8)); //greenish
    ellipse(position.x, position.y-h, r, r); //"lens flare"
    
    //draw head
    fill(0, 150);
    stroke(mainColor, 150);
    ellipse(position.x, position.y-h, size, size); //head
    
    eye.run(position.get()); //update, and set pos to player's pos
    
    if (width <= 720) {//for regular small screen
      //Energy Bar//    
      //Energy bar fill
      noStroke();
      fill(magenta1, 140);
      rectMode(CORNER);
      float bheight = map(energy, 0, 255, 0, 100);
      rect(15, 120, 10, -bheight);
      
      //Energy bar outline
      noFill();
      stroke(magenta1, 150);
      rect(15, 120, 10, -100);
      rectMode(CENTER); //reset
      strokeWeight(1);
    }
    else { //for largscreen
      //Energy Bar//    
      //Energy bar fill
      noStroke();
      fill(magenta1, 140);
      rectMode(CORNER);
      //float bheight = map(energy, 0, 255, 0, 100);
      float bheight = map(energy, 0, 255, 0, 200);
      //rect(15, 120, 10, -bheight);
      rect(15, 215, 10, -bheight);
      
      //Energy bar outline
      noFill();
      stroke(magenta1, 150);
      //rect(15, 120, 10, -100);
      rect(15, 215, 10, -200);
      rectMode(CENTER); //reset
      strokeWeight(1);
    }
    
    //color cPImgTint = color(55, 170, 158); //player image tint 
    //"emissive" glow around player (normal)
    tint(255, 100 -energy);
    image(pblur, position.x, position.y-h);
    
    //"emissive" glow around player (colored)
    tint(magenta1, energy-80);
    image(pblur, position.x, position.y-h);
    noTint();
    
    //Border
    strokeWeight(8);
    if (rborderAlpha > 0) {
      noFill();
      stroke(255, rborderAlpha);
      line(width, 0, width, height);
      rborderAlpha--;
    }
    if (lborderAlpha > 0) {
      noFill();
      stroke(255, lborderAlpha);
      line(0, 0,0, height);
      lborderAlpha-=4;
    }
    
    ////indicator to show player can't throw yet (harpoon not yet reset)
    //if (LMB & harpoon.isThrown) {
    //  uiAlpha = 90;
    //}
    //if (uiAlpha > 0) {
    //  strokeWeight(1);
    //  stroke(255,0,60,uiAlpha);
    //  rect(position.x, position.y-100, 20,20);
    //  line(position.x-10, position.y-100+10, position.x+10, position.y-100-10);
    //  line(position.x-10, position.y-100-10, position.x+10, position.y-100+10);
    //  uiAlpha -=8;
    //}
    
    //screen overlay color, mapped to energy level. brighter with more energy.
    strokeWeight(1); //reset
    //fill(magenta1, constrain(energy/15, 0, 100));
    fill(magenta1, map(energy,0,255,0,20));
    noStroke();
    rect(width/2, height/2, width, height);
    
    //flash screen when level up
    if (lvlupAlpha > 0) {
      fill(magenta1, lvlupAlpha);
      rect(width/2, height/2, width, height);
      lvlupAlpha--;
    }
  }
  
  //display pickuyp animation effect
  void pickupItem(float e) {
    e *= constrain(map(energy,0,255,1,.01), 1,0.01); //pick up less enery when bar is fuller
    energy += e;
    //energy += 25; //debug
    if (energy > 255) { //cap energy
      energy = 255;
      levelUp();
      if (showDebug) {
        energy = 250;
      }
    }
    eye.alpha = 180;
  }
  
  void levelUp() {
    energy = 0;
    maxNumFish += (int)random(-1,3);
    level++;
    lvlupAlpha = 25;
    mixColors();
  }
}


//https://processing.org/examples/arctangent.html
//Eye that looks at a target, and is drawn at player's position
class Eye {
  PVector p = new PVector(0,0);
  float size;
  float x, d; //ellipse x pos, diameter
  float alpha; //eyering alpha color overlay for picking up items
  Eye(float s) {
    size = s*2; //size = player.size *2
    x = size/8; d = size/3;
  }
  void run(PVector lookTarget) { //look target = target object to look at (mouse)
    //get angle based on mouse pos minus player pos
    //fill(24,118,89, player.brightness-80);
    
    lookTarget.y -= player.h;
    float angle = atan2(mouseY-lookTarget.y, mouseX-lookTarget.x);     
    pushMatrix();
    translate(lookTarget.x, lookTarget.y); //set position to player's position
    rotate(angle);
    //reflect
    noFill();
    stroke(255, 20); 
    strokeWeight(3);
    ellipse(x-5, 0, d, d);
    
    //chrom abber
    strokeWeight(2);
    noFill();
    stroke(255, 0, 0, 60); //chrom red
    ellipse(x+1, 0, d, d);
    stroke(0, 255, 255, 150); //chrom cyan
    ellipse(x-1, 0, d, d);

    //EYE
    fill(magenta1, map(player.energy,0,255,0,70)); //
    stroke(255);
    strokeWeight(1.5);
    ellipse(x, 0, d, d); //xpos because of x offset when rotating (transformation) 
    
    //red flash when picking up item
    if(alpha > 0) {
      noFill();
      stroke(magenta1, alpha);
      ellipse(x, 0, d, d); //xpos because of x offset when rotating (transformation) 
      alpha-=15;
    }
    
    //look
    //map for harpoon charge strength
    //ellipse
    strokeWeight(1);
    if (player.harpoon.isAiming) {
      float l = map(player.harpoon.throwForce, player.harpoon.minThrowForce,  player.harpoon.maxThrowForce,
      0,50);
      stroke(255,l);
      line(x+25,0,x+25 +l,0);
      point(x+25, 0); //start point
      
      stroke(l*5+60);
      strokeWeight(1.5); 
      point(x+75, 0); //max point
      
      //stroke(l*2);
      stroke(255,170);
      //side points
      point(0, x+20); 
      point(0, x-40);
    }
    
    
  strokeWeight(1); //reset
  popMatrix(); //reset
  }
}