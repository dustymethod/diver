

class Fish {
 PVector position, velocity, acceleration; //position, velocity, acceleration
 PVector direction;
 float w, h;
 float mass = 1;
 int dir; //direction fish is facing (-1 or 1)
 float topspeed = 3;
 boolean isAlive;
 boolean isNearPlayer;
 boolean canDrop; //if fish can drop an item or not. also determines color.
 float hspd; //used to reset velocity

 Fish() {
   isAlive = true;
   dir = (int)random(2)*2-1; //get random direction, -1 or 1
   //position = new PVector(width/2 - (width/2*dir), random(height/3*2)); //y pos within top two thirds of scren
   position = new PVector(width/2 - (width/2*dir), random(0, height-100));
   velocity = new PVector(random(.5,2)*dir, 0); //random starting velocity
   hspd = velocity.x;
   //velocity.x += player.level*dir*.2; //increase velocity if player levels up
   acceleration = new PVector(0,0);
    
   //if (topspeed <5) { //used for a speed increase
     //topspeed ++;
   //}
   //if ((int)random(6) == 0) { //chacne fish can drop an item
   if ((int)random(4) == 0) { //chacne fish can drop an item
     PVector p = new PVector(position.x + random(-20, 20), position.y-10);
     velocity.mult(1.5);
     canDrop = true;
   }
   else {
     canDrop = false;
   }
 }

 void updateFish() {
   moveFish();
   checkCollisions();
   harpoonCollision();
 }
  
 //apply force, making fish seem like it avoids harpoon
 //void applyForce(PVector f) {
 //  //if near harpoon, 
 //  f.div(mass);
 //  acceleration.add(force);
 //}
  
 void moveFish() {
   //used for behaviour where fish avoids player. not very smooth
   
   //boolean isNearHarpoon;
   ////float d = PVector.dist(position, player.harpoon.position);
   //float d = PVector.dist(position, player.position);
   ////if (d < 90 && player.harpoon.isThrown) {
   //if (d < 150) {
   // //isNearHarpoon = true;
   // isNearPlayer = true;
   // //applyForce();
   //}
   //else {
   // //isNearHarpoon = false;
   // isNearPlayer = false;
   //}
   //if (isNearPlayer) {
   // direction = PVector.sub(player.position, position);
   //}
   //else {
   // direction= new PVector(hspd,0);
   //}
   //direction.x *=1.2;
   //float dist = PVector.dist(player.position, position);
   //acceleration = direction;
   //if (isNearPlayer) {
   // //acceleration.mult(map(dist,1,50,-1,-.05));
   // acceleration.mult(map(dist, 10, 150, -3, -1)); ////avoids player
   //}
   //else {
   // acceleration.mult(1);
   //}
   
   
   //acceleration.mult(.5);
   //velocity.add(acceleration);
   velocity.limit(topspeed);
   velocity.mult(.5); //smoothing
   position.add(velocity);
   velocity = new PVector(hspd, 0);
   //checkCollisions();
   
 }
  
 //drop item
 void harpoonCollision() {
   float dist = dist(position.x, position.y, player.harpoon.position.x, player.harpoon.position.y);
   if (dist < player.harpoon.hitBox && isAlive) {
     isAlive = false;
     if (canDrop) {
       PVector p = new PVector(position.x + random(-20, 20), position.y-10);
       items.add(new Item(p, 2, 1)); //should be handled elsewhere?#
     }
   }
 }
  
 //check if offscreen, and reset
 void checkCollisions() {
   //collisions with player
   //float distToPlayer = dist(player.position.x, player.position.y, position.x, position.y);
   //collisions with window border
   if (position.x > width+50 || position.x < 0-50) {
     //isAlive = false;
   }
 }

 void displayFish() {
   if (isAlive) {
     if (canDrop) {
       fill(magenta1, 18);
       stroke(magenta1);
     }
     else {
       fill(mainColor, 18);
       stroke(mainColor);
     }
     float fd = 7 * dir;
     triangle(position.x + fd, position.y, 
              position.x - fd, position.y - 8, 
              position.x - fd, position.y + 8);
   }
 }
}