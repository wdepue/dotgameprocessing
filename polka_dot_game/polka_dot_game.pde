void setup() {
  fullScreen(); //have to run these in here
  colorMode(HSB, 360); //have to run these in here
  config();
  setupVariables();
  setupEnemies();
  delay(900); //i like having this delay after you die before you restart. small jolt and everything freezes
}

void draw() { //i'm proud of how small my draw function is :)
  tickCounter += 1; //counts the ticks
  drawBackground(tripMode);
  drawEnemies();
  drawPlayer();
  drawPowerBar();
  drawCheckBar();
  drawText();
} 

void drawBackground(boolean mode) { //for tripMode where no background is rendered
  if (mode) return;
  background(204);
}

void drawPlayer() { //just draw a circle at the players mouse
  fill(0, 0, 360); //make it white
  circle(mouseX, mouseY, playerSize);
}

void setupEnemies() { //generator for all the enemies at the start :)
  for (int i = 0; i < enemyCount; i++) {
    enemies[i] = new Circle();
  }
}

void drawEnemies() {
  for (int i = 0; i < enemyCount; i++) {
    enemies[i].move(); //updates position
    enemies[i].checkDead(); //checks if the enemy is offscreen
    enemies[i].render(); //renders
    enemies[i].checkTouch(); //checks if it killed something
  }
}



float genCircleDiameter() { //generates the size of an enemy
  float result = random(10 + score, 100 + score); //based on the score the enemies grow large
  if (result >= playerSize && result - playerSize <= 5) { //i didn't like that its hard to judge whether an enemy is bigger than you or not
     result = genCircleDiameter(); //this just makes sure that there aren't any enemies which are bigger and too close to your size 
  } //its recursive btw
  return result;
}

PVector genCircleSpeed() { //all enemies actually do have the same magnitude of vectors. not sure if i should change this?
  PVector speed = PVector.random2D(); //makes a random 2d vector
  speed.setMag(enemySpeed); //sets the magnitude to enemySpeed
  return speed; //returns randomized 2d vector
}

// this is a crappy way for me to generate an position to spawn in an enemy
PVector genCircleLocation(float diameter) {
  boolean orientation = boolean(floor(random(0, 2))); //choose a random boolean
  PVector start = new PVector(random(0, width), random(0, height)); //generate a random position on the screen
  start = orientation ? new PVector(start.x, (height + 2 * diameter) * int(2 * start.y / height) - diameter) : new PVector((width + 2 * diameter) * int(2 * start.x / width) - diameter, start.y);
  return start; //based on the boolean it chooses which side, vertical or horizontal, the enemy will spawn
} //the function then just takes the random position and rounds it to decide whether its right or left, top or bottom
//this function also starts the circles in an offscreen position without killing them depending on their diameter

// called in Circle class
void enemyEaten() { //every time you score both you and the enemies around you grow larger
  playerSize += 1.75; //however, you grow larger 75% more than your enemies 
  score += 1; //this makes the game easier as you go, with the fact that as you grow bigger so does your hit box
}

void gameOver() {
  setup();
}
