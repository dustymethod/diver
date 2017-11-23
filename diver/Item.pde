
class Item {
 PVector position;
 PVector velocity, acceleration;
 float r; //radius/size
 int type;
   //0 = none
   //1 = grass
   //2 = fish
 float age;
 boolean isDead;
 //float tick, duration; //used for pulsing animation //#disabled
 PVector gravity= new PVector(0, 0.08); //grav acceleration;
 boolean isMoving;
 float energy; //amount of energy to add to player when picked up
  
 Item(PVector p, int t, float a) {
   age = 0;
   r = map(a, 0, 720, 5, 8); //map item size to grass age
   position = p;
   velocity = new PVector(random(-1, 1), random(-1,-.5)); //initial velocity when dropped
   type = t;
   isMoving = true;
   if (type == 1)
   energy = 8;
   if (type == 2)
   energy = 30;
   //duration = 100;
   //tick = frameCount + duration;
   
 }
  
 void updateItem() {
   //if (player.forward) {
   //  position.x -= player.velocity.x; //account for player movement. must be before topPoint is defined
   //}
   if (isMoving) {
     moveItem();
   }
   //remove items that haven't been picked up after 2000 frames
   age++;
   if (age > 2000) {
     isDead = true;
   }
 }
 
 void moveItem() {
   acceleration = gravity;
   if (position.y > terrain.getGroundHeight(position)) { //landing
      velocity.x *= .5; //friction
      velocity.y *= -0.5; //bounce factor
      position.y = terrain.getGroundHeight(position);
    }
    velocity.add(acceleration);
    position.add(velocity);
    
    //bounce off window border
    if (position.x < 0) {
      velocity.x *= -1;
    }
    if (position.x > width) {
      velocity.x *= -1;
    }
    
    //eliminate unecessary decimal places if at nominal velocity
    if (abs(velocity.x) < 0) {
      isMoving = false; //disable movement after landing on ground
    }
 }
 
 //Remove if item collides with player
 boolean isColliding() { //isColliding with player
   float dist = dist(position.x, position.y, player.position.x, player.position.y);
   if (dist < 5) {
     return true;
   }
   else {
     return false;
   }
 }
  
 void displayItem() {
   //if (frameCount > tick) {//#disabled
   //   tick = frameCount + duration; //reset tick
   // }
   switch (type)  {
     case 1:
       //display grass item
       displayGrassItem();
       break;
     case 2:
       //display fish item
       displayFishItem();
       break;
     default:
       break;
    }
  }
  
  void displayGrassItem() {
    //if (frameCount > tick) { //for pulsing color
    //  tick = frameCount + duration; //reset tick
    //}
    //stroke(255, 200);
    color cGrassItem = color(255,0,0);
    cGrassItem = color(magenta1);
    stroke(cGrassItem,0,0,100);
    fill(cGrassItem, 100);
    //rect(position.x, position.y-3, 5,5);
    rect(position.x, position.y-3, r,r);
  }
  
  void displayFishItem() {
    color fishClr = color(255,0,0); //meat color
    fishClr = color(magenta1); //meat color
    stroke(fishClr);
    fill(fishClr, 100);
    triangle(position.x, position.y-9,
             position.x -6, position.y-1,
             position.x+6, position.y-1);
  }
}