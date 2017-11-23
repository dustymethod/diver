//contains: 
//Seaweed Class
//SeaweedSystem Class


/*
Using a for loop, two points are added per loop (the number of loops being the seaweed’s height).
Each couple of points are higher than the last. The second point is horizontally offset from the first.
Adding these points into an arraylist, when used together with the beginShape(TRIANGLE_STRIP) function.
*/

//Seaweed System//
//iterates through each seaweed plant
class SeaweedSystem {
  color c;
  ArrayList<Seaweed> seaweeds;
  int startAmount = 15;
  
  SeaweedSystem() {
    seaweeds = new ArrayList<Seaweed>();
    for (int i=0; i<startAmount; i++) {
      seaweeds.add(new Seaweed(new PVector(random(width), 0)));
    }
  }
  
  void step() {
    Iterator<Seaweed> it = seaweeds.iterator();
    while(it.hasNext()) {
      Seaweed s = it.next();
      //#offscreen functionality disabled, screen no longer moves.
      //if (!s.isOffscreen()) { //update if onscreen
        s.updateSeaweed();
      //}
      //else reset if offscreen
      //else {
      //  if ((int)random(10)== 0) {
      //    s.reset(new PVector(width - random(10),0));
      //  }
      //}
    }
  }
}



//Seaweed//
//moves & updates each Swpoint in ArrayList Points
class Seaweed {
  PVector pos;
  float w; //width
  int numPoints;
  int type;
  ArrayList <Swpoint> points;
  
  Seaweed(PVector pos_) {
    reset(new PVector(pos_.x, pos_.y));
  }
  
  void reset(PVector p_) {
    pos = new PVector(p_.x, p_.y);
    pos.y = terrain.getGroundHeight(pos);
    w = (int)random(5,15);
    
    //set up seaweed shape, using points
    points = new ArrayList<Swpoint>();
    numPoints = (int)random(1,7); //random number of segments
    for (int i=0; i<numPoints; i++) {
      PVector p = new PVector(pos.x, pos.y - 30*i);
      points.add(new Swpoint(p));
      points.add(new Swpoint(new PVector(p.x + w, p.y)));
    }
  }
  
  //disabled
  //boolean isOffscreen() { 
  //  if (pos.x < 0) {
  //    return true;
  //  }
  //  else {
  //    return false;
  //  }
  //}
  
  void updateSeaweed() {
    if (player.forward) {
      pos.x -= player.velocity.x; //account for player movement. must be before topPoint is defined
    }
    animateSeaweed();
    displaySeaweed();
  }
  
  void animateSeaweed() {
    int h = 0;
    for (Swpoint pt : points) {
      pt.step(h);
      h++;
    }
  }
  
  void displaySeaweed() {
    //noStroke(); //alternate look w/o stroke
    //fill(grassColor, 40);
    fill(seaweedColor, 40);
    stroke(seaweedColor, 45);
    beginShape(TRIANGLE_STRIP);
    for (Swpoint l1 : points) {
      vertex(l1.pos.x, l1.pos.y);
    }
    endShape();
  }
}


//Individual point, used in Seaweed class, to make up the seaweed
class Swpoint {
  PVector startpos;
  PVector pos;
  //PVector v, a; //add player nudge
  float seed;
  Swpoint(PVector pos_) {
    startpos = pos_;
    pos = startpos.get();
    seed = random(1)*random(1.3);
  }
  
  void step(float h) {
    // h for height of seaweed/number of segments. used for greater sway range, the higher the point is
    float n = noise(seed);
    float range = 30 * h;
    float incr = map (n, 0, 1 , -range, range);
    incr *=0.1; //smooth
    seed += 0.008;
    pos = new PVector(startpos.x + incr, startpos.y);
//    if (player.forward) { //disabled
//      startpos.x -= player.velocity.x; //account for player movement. must be before topPoint is defined
//    }
  }
}