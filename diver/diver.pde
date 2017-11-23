//Apr 11 2016
//Amanda Chan | ISMA 


import java.util.Iterator;
//controls & booleans
boolean showDebug; //show things for debugging
boolean akey, dkey; //horizontal movement
boolean spacekey; //jump key
boolean qkey; //interact/use/shop
boolean LMB; //charging harpoon throw
boolean spacebar;
boolean displayInstr; //tab

//Images
PImage pblur, psunlight, psunray, psunlight2; //light rays
//PImage spr_pwalk, spr_prun;
float imageAlpha; //background image opacity
float alphaSeed; //seed for backgound alpha noise

//colors
color mainColor = color(0, 186, 131); //main default color (changes)
color magenta1 = color(255, 5, 80); //alternate color (changes)
color terrainFill = color(9,26,21);
color seaweedColor = color(46,90,61); //d
color grassColor = mainColor;

//Classes & arraylists
Terrain terrain;
Player player;
//fish variables
  int startNumFish; //starting number of fish
  int numActiveFish; //number of active fish;
  ArrayList <Fish> fishes;
  int startMax;
  int maxNumFish;
  int fishChance;
GrassSystem grassSystem;
SeaweedSystem seaweedSys;
ArrayList <Item> items;
ParticleSystem[] particles;

void setup() {
  size(720, 480);
  //size(1360,760); //use for large screens / presenting
  //frameRate(60);
  background(10);
  rectMode(CENTER);
  imageMode(CENTER);
  displayInstr = false;
  pblur = loadImage("player_blur3.png");
  psunlight = loadImage("sunlight_01.png");
  psunlight2 = loadImage("sunlight_resize.png");
  psunray = loadImage("sunray_01.png");
  imageAlpha = 0;
  
  if (width <= 720)
  startMax = 5;
  else
  startMax = 25;
  maxNumFish = startMax;
  fishes = new ArrayList<Fish>();
  startNumFish = 0;
  fishChance = 5;
  for (int i=0; i<startNumFish; i++) {
    fishes.add(new Fish());
  }
  player = new Player();
  terrain = new Terrain(0);
  grassSystem = new GrassSystem();
  seaweedSys = new SeaweedSystem();
  items = new ArrayList<Item>();
  particles = new ParticleSystem[18];
  for (int i=0; i<particles.length; i++) {
    particles[i] = new ParticleSystem();
  }
}

void draw() {
  //background(10);
  background(#041315); //background color
  //background(#020C0D);
  updateElements();
  displayElements();
  //update data
}

//update elements
void updateElements() {
  //terrain.updateTerrain();
  player.updatePlayer();
  grassSystem.step();
  
  for (Item i : items) {
    i.updateItem();
    i.displayItem();
  }
  //separate remove function.
  for (Item i : items) {
    //if (isOffscreenCheck(i.position) || i.isColliding()) { //remove if offscreen or is colliding
    //add energy to player
    if (i.isColliding()) {
      if (i.type == 1){  //if item dropped by grass, map energy to grass's height
        i.energy = map(i.r, 5,8,1,5); //item gives more energy if grass is taller
        //energy is mapped to item's size, which is mapped to grass's age when cut
      }
      player.pickupItem(i.energy);
      items.remove(i);
      break;
    }
    if (i.isDead || isOffscreenCheck(i.position)) { //remove if offscreen or is colliding
      items.remove(i);
      break;
    }
  }
  
  //fish
  for (Fish f : fishes) {
    f.updateFish();
    f.displayFish();
  }
  //separate remove function.
  for (Fish f : fishes) {
    //remove if offscreen or is colliding
    if (!f.isAlive || isOffscreenCheck(f.position)) { //should offscreen check be a global function, or a function of the fish class?
      fishes.remove(f);
      break;
    }
  }
  numActiveFish = fishes.size();
  if (numActiveFish < maxNumFish) {
    fishChance = 50; //chance fish will respawn #largescreen
    if ((int)random(fishChance)==0) {
      fishes.add(new Fish());
      numActiveFish = fishes.size();
    }
  }
}

//check if position p is outside of window bounds
boolean isOffscreenCheck(PVector p) {
  if (p.y > height || p.y < 0 || p.x < 0 || p.x > width) {
    return true;
  }
  else return false;
}



//display elements
void displayElements() {
  //Display Game Elements//
  displayBG(); //display background png
  player.harpoon.displayHarpoon();
  terrain.displayTerrain();
  player.displayPlayer();
  seaweedSys.step(); //update and display seaweed
  for (int p=0; p<particles.length; p++) {
    particles[p].updateParticle();
    particles[p].displayParticle();
  }
  if (displayInstr) { //display instructions when tab is pressed
    displayInstr();
  }
  else {
    fill(magenta1,200);
    //text("[press TAB]", width-35, 15);
    //text("[press TAB]", width-35, height-7);
    text("[press TAB to show instructions]", width-100, height-7);
  }
}

//display instruction text
void displayInstr() {
  textAlign(CENTER);
  fill(0,70);
  rect(width/2, height/2, width, height);
  if (width <= 720) {
    textSize(12);
    int p = 15; //line spacing
      fill(magenta1,180);
      text("(TAB to show/hide)", width/2, 150-p);
      fill(255);
      text("A+D to move", width/2, 150+p);
      text("hold LMB to charge", width/2, 150+p*2);
      text("relsease to throw", width/2, 150+p*3);
  }
  else {
    textSize(16);
    int p = 20; //line spacing
      fill(magenta1,180);
      text("instructions:", width/2, 200-p*2);
      text("(TAB to show/hide)", width/2, 200-p);
      fill(255);
      text("A+D to move", width/2, 200+p);
      text("hold LMB to charge", width/2, 200+p*2);
      text("relsease to throw", width/2, 200+p*3);
      textSize(12);
  }
}

//randomize colors each time player levels up
void mixColors() {
  //light and dark themes. night and day cycle?
  //if ((int)random(2) ==0) {
    
  //}
  //else {
    colorMode(HSB);
    float hue = random(255);
    float hue2 = random(255);
    while (abs(hue-hue2) < 52) { //prevent hue an hue from matching
      hue2 = random(255);
    }
    mainColor = color(hue, 180, random(170,210));
    terrainFill = color(hue, 65, 25);
    hue = random(255);
    magenta1 = color(hue2, 255, 255);
    seaweedColor = color(random(255), 60, 87);
    colorMode(RGB,255,255,255); //reset color mode
  //}
}

//background "sunlight" png's
void displayBG() {
  float n = noise(alphaSeed);
  float alpha = map(n, 0, 1, 35, 60);
  int chance = (int)random(10); //Slower animation; don't move every frame.
  if (chance == 0) {
    alphaSeed += 0.01;
  }
  
  imageMode(CORNERS);
  if (width <= 720) {
    tint(mainColor, 210);
    image(psunlight, 0, 0);
    tint(mainColor, alpha);
    image(psunray, 0, 0);
  }
  else { // #largescreen
    tint(mainColor, alpha);
    image(psunlight2, 0, 0);
  }
  noTint();
  imageMode(CENTER);
}