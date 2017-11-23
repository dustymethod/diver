//particle system. generates particles that fade in and out.

class ParticleSystem {
  boolean isActive; //if particle is active and visible.
  PVector position, v; //position, acceleration, velocity
  float s; //speed
  float radius;
  float age;
  float lifespan = 500;
  ParticleSystem() {
    init();
  }
  
  void init() {
    age = random(lifespan/3*2);
    position = new PVector(random(width), random(height));
    radius = random(7);
    s = random(1);
    v = new PVector(random(-s, s), random(-s, s));
  }
  
  void updateParticle() {
    if (isActive) {
      if (player.forward) {
        position.x -= player.velocity.x;
      }
      age++;
      position.add(v);
      checkEdges();
      if (age >= lifespan) {
        isActive = false;
      }
    }
    else {
      //if inactive, re init
      float c = random(700); //chance of respawning/reactivating
      if (c <= 5) {
        isActive = true;
        init(); //reinitialize
      }
    }
  }
  
  void checkEdges() {
    if(position.x > width) {
      position.x = 0;
    }
    if(position.x < 0) {
      position.x = height;
    }
    if(position.y > height) {
      position.y = 0;
    }
    if(position.y < 0) {
      position.y = height;
    }
  }
  //#change to point?
  void displayParticle() {
    if (isActive) {
      fill(mainColor, map(age, 0, lifespan, 70, 0));
      noStroke();
      ellipse(position.x, position.y, radius, radius);
    }
  }
}