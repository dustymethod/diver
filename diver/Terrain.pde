//a mess

class Terrain {
  ArrayList<PVector> points; //point position
  float defaultY = height-50; //default ground height
  int depth; //zdepth
  int bufferX = 50; //buffers so that points don't appear/disappear suddenly (they do so offscreen) when adding/removing
  float noiseSeed =0; //noise seed
  PVector midPoint = new PVector(0,0); //safely init
  PVector midPointB = new PVector(0,0);
  
  Terrain (int depth_) {
    depth = depth_;
    points = new ArrayList<PVector>();
    int xoff = 50;
    for (int i=0; i<(int)width/10; i++) {
      if (i*xoff < width +bufferX*3) {
        points.add(new PVector(i * xoff, defaultY + random(-10, 10)));
      }
    }
  }
  
  //used for ground collision.
  //takes an object's x position(target_), and returns a y value as the ground height at that position.
  //finds the closest point to the right of object's posititon, and another point, one position lower in the points array list.
  //a lerp function is used to get the y value of the object between these points.
  float getGroundHeight(PVector target_) {
    if (target_.x > 0 && target_.x < width) {
    //solves IndexOutOfBoundsException: Index: 17: Size:17
    //by preventing out of range x values?
      //get two points closest to the player
      PVector RPoint = new PVector(0,0); //A
      PVector LPoint = new PVector(0,0);
      PVector target = target_;
  
      for (int i=0; i< points.size()-1; i++) { // #ArrayOutOfBoundsException
        PVector p = points.get(i); //get current point in array
        float dist2 = PVector.dist(p, target); //get dist between point and target PVectors
        float dist = dist(p.x, height, target.x, height); //get dist between point and target x values
        if (dist < 50 || dist < 100) { //#Nan also
          if (p.x < target.x) { //if point is to left of target
            //if (i < points.size()) { //IndexOutOfBoundsException: Index: 17: Size:17
              //Get left and right points
              RPoint = points.get(i+1);
              LPoint = points.get(i);
            //}
          }
        }
      }
      float pDist = 0;
      if (target.x > 0) {
        pDist = map(target.x, RPoint.x, LPoint.x, 0, 1); //player distance between points
      }
      float groundY = lerp(RPoint.y, LPoint.y, pDist); //height = y value between the two points at player's position
      
      //debugging
      if (showDebug && target == player.position ) {
        noFill();
        stroke(255, 0, 0);
        ellipse(target.x, groundY, 10,10);
        ellipse(RPoint.x, RPoint.y, 10,10);
        stroke(0, 0, 255);
        ellipse(LPoint.x, LPoint.y, 10,10);
      }
      return groundY;
    }
    else
    return height/2; //default
  }
  
  //disabled, as screen movement is no longer enabled
  void updateTerrain() {
    //for(PVector p : points) {
      //if (player.forward) { //#disabled
      // p.x -= player.velocity.x;
      //}
    //}
    
    //#disabled
    //remove point if it leaves screen
    //for (int i=0; i< points.size(); i++) {
    //PVector p = points.get(i);
    //  if(p.x +bufferX< 0 - bufferX) {
    //    resetPoint(i);
    //    break;
    //  }
    //  break;
    //}
  }
 
 //removes selected point, and adds a new point at the end of "points" ArrayList.
 //height is incremented using nosie
 void resetPoint(int index_) {
   //increment y position using perlin noise
   float n = noise(noiseSeed);
   float hRange = random(20,60); //range of min/max increase in height
   float y = map(n, 0, 1, -hRange, hRange); //
   PVector getX = points.get(points.size()-1);
   
   points.add(points.size(), new PVector(getX.x +bufferX*2, defaultY + y));
   points.remove(index_);
   noiseSeed += 0.5; //rocky/smooth terrain
 }
  
 void displayTerrain() {
   fill(terrainFill);
   stroke(mainColor, 120);
   strokeWeight(1);
   beginShape();
   vertex(-1, height);
   int i=0;
   for (PVector p : points) {
     vertex(p.x, p.y);
     if (showDebug) {
       text("" + i, p.x, p.y);
       i++;
     }
   }
   vertex(width+1, height);
   endShape();
   }
}