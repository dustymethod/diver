
class Grass {
  PVector position, topPoint;
  float h, maxHeight;
  float growRate = random(0.05, 0.1); //varying rate of grown
  float age, lifespan; //age of grass, and max age
  boolean canDropItem;
  int tick =0; //timer, for updating every nth frame.
  float s; //noise seed
  
  Grass(PVector p) {
    resetGrass(p);
  }
  void resetGrass(PVector pos_) {
    position = new PVector(pos_.x, pos_.y); //set x position
    position.y = terrain.getGroundHeight(position); //set y position to ground height
    maxHeight = random(5, 35); //varying max height grass can grow to
    h = random(maxHeight); //starting grass height
    lifespan = 700 + random(20); //varying lifespan
    age = random(lifespan); //starting age
    
    if ((int)random(4) == 0) { //chance grass starts as alternate color
      PVector p = new PVector(position.x + random(-20, 20), position.y-10);
      canDropItem = true;
    } else {
      canDropItem = false;
    }
    s = random(.5); //wind noise seed
    tick = 0;
  }
  
  void updateGrass() {
    moveGrass();
    growGrass();
  }
  
  void moveGrass() {
    float n = noise(s); //get noise
    float range = map(h, 0, maxHeight, 6, 60); //set range of horiz movement/sway
    float sway = map(n, 0, 1, -range, range); //get sway amount
    sway *=.1; //smooth sway
    
    //offset screen movement //disabled
    //if (player.forward) { 
    //  position.x -= player.velocity.x; //account for player movement. must be before topPoint is defined
    //}
    topPoint = new PVector(position.x + sway, position.y -h); //set point to position, plus height, plus wind offset; //#call after
    s+=0.008; //incrememnt noise seed
  }
  
  //shorten grass height if colliding with player's harpoon
  void cut() {
    if (h > maxHeight/3) {
      h *= .3;
      age += (lifespan-age)*.8;
    }
    if (canDropItem)
    dropItem();
  }
  
  //Chance drop fruit when grass is grown to max height
  void dropItem() {
    PVector p = new PVector(position.x + random(-20, 20), position.y-10);
    items.add(new Item(p, 1, age));
    canDropItem = false; //can only drop fruit once
  }
  
  boolean harpoonCollision() {
    float dist = dist(position.x, position.y-10, player.harpoon.position.x, player.harpoon.position.y);
    if (player.harpoon.isThrown && dist < 30) {
      return true;
    }
    else {
      return false;
    }
  }
  
  boolean isAlive() {
    if (age >= lifespan) {
      return false;
    }
    else
    return true;
  }
  
  boolean isOffscreen() {
    if (position.x < 0)
    return true;
    else 
    return false;
  }
  
  void growGrass() {
    //increment every other frame
    if (tick == 2) { //if tick == frame rate
      if (h < maxHeight) {
        if (showDebug)
        h++; //debug speed
        else
        h += growRate;
      }
      if (age < lifespan) {
        if (showDebug)
        age +=5; //debug speed
        else
        age += 0.5;
      }
      tick = 0;
    }
    tick++;
  }
  
  void displayGrass() {
    //display grass
    noFill();
    if (canDropItem) {
      grassColor = color(magenta1);
      stroke(grassColor, map(age, lifespan/2, lifespan*.9, 255,0));
    }
    else {
      grassColor = color(mainColor);
      if (age < lifespan*.75) {
      stroke(grassColor, map(age, 0, lifespan*.75, 200,0));
      }
      else {
        stroke(grassColor, map(age, 0, lifespan, 100, 0));
      }
    }
    //else if being lit
    strokeWeight(constrain(map(h, 5, maxHeight, 1, 2.5), 0, 2.5));
    line(position.x, position.y, topPoint.x, topPoint.y);
    strokeWeight(1);
  }
}