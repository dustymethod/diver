//Handles all the grasses
class GrassSystem {
 ArrayList<Grass> grasses;
 int startGrassAmount = 80; // start grass amount
  
 GrassSystem() { //#add init argument?
   grasses = new ArrayList<Grass>();
   for (int i=0; i<startGrassAmount; i++) {
     grasses.add(new Grass(new PVector(random(width), 0)));
   }
 }
  
 //update and display grass, and check if dead, or hit by harpoon
 void step() {
    Iterator<Grass> it = grasses.iterator();
    while(it.hasNext()) {
      Grass g = it.next();
      g.updateGrass();
      g.displayGrass();
      //cut grass if hit by harpoon
      if (g.harpoonCollision()) {
        g.cut();
      }
      //reset grass if off screen //#disabled
      //if (g.isOffscreen()) {
      //  g.resetGrass(new PVector(width - random(10), 0)); //reset if it goes off screen
      //}
      //reset grass age, height and position if it dies
      if (!g.isAlive()) {
        g.resetGrass(new PVector(random(width),0));
        g.age = -80;
        g.h = g.maxHeight*.1; //starting grass height
      }
    }
  }
}