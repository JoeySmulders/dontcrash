// Create a soundfile for the music  
import processing.sound.*;
SoundFile file;

// Arrays of booleans for Keyboard handling. One boolean for each keyCode
final int KEY_LIMIT = 1024;

// Keyboard handling...
void keyPressed() {  
  if (keyCode >= KEY_LIMIT) return; //safety: if keycode exceeds limit, exit methhod ('return').
  keysPressed[keyCode] = true; // set its boolean to true
}

//..and with each key Released vice versa
void keyReleased() {
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = false; // set its boolean to false
}


boolean[] keysPressed = new boolean[KEY_LIMIT];
boolean[] keysReleased = new boolean[KEY_LIMIT];

boolean Select = true;
boolean startCheck = false;
boolean destroyed = false;

int[] richting = new int[7];
Tile[] tiles;
Tile[] tilesLeft;
Tile[] tilesRight;
Car car;
SelectLeft selectLeft;
SelectRight selectRight;

final int tileXStartLeft = 50;
final int tileYStartLeft = 10;
final int tileXStartRight = 500;
final int tileYStartRight = 50;

int tileXLeft = tileXStartLeft;
int tileYLeft = tileYStartLeft;
int tileXRight = tileXStartRight;
int tileYRight = tileYStartRight;


//Grid
int tileCountLeft = 8;
int tileRowLeft = 2;
int tileDistanceXLeft = 200;
int tileDistanceYLeft = 200;

int tileCountRight = 16;
int tileRowRight = 4;
int tileDistanceXRight = 200;
int tileDistanceYRight = 180;

final int lineX = 400;


// Different screens
int gameState = 0;
final int mainMenu = 0;
final int levelSelect = 1;
final int optionsScreen = 2;
final int inGame = 3;


// constants for the car movement directions
final int up = 0;
final int right = 1;
final int down = 2;
final int left = 3;
int previousDirection = up;
int frame = 0;


int limit = 0;
boolean limit2;

int collisionTimer = 0;
int collisionAdjustment = 75;

boolean win = false;


void setup() {
  size(1280, 720);

  // Load a soundfile from the /data folder of the sketch and play it back
  file = new SoundFile(this, "/music/funky_menu.wav");
  file.loop();

  // Initialize the left side of the grid
  tilesLeft = initTiles(tileCountLeft);
  tilesRight = initTiles(tileCountRight);

  //Create the car
  car = new Car();

  car.setImage(loadImage("images/carUp.png"));
  car.x = tileXStartRight + 25;
  car.y = height - 20;
  car.velocity = 1.2;

  //Create the selector and give it the variables
  selectLeft = new SelectLeft();
  selectRight = new SelectRight();

  selectLeft.selectX = tileXLeft;
  selectLeft.selectY = tileYLeft;

  selectRight.selectX = tileXRight;
  selectRight.selectY = tileYRight;
  startCheck = false;
  win = false;
}

// calls the right select function
void Select() {
  if (Select) {
    if (keysPressed[ENTER] == true && limit == 0) {
      Select = false;
      limit = 1;
    } else {
      selectLeft.selectLeft();
    }
  } else {
    if (keysPressed[ENTER] == true && limit == 0) {
      Select = true;
      limit = 1;
      Tile memory = tilesRight[selectRight.tileNumber];
      tilesRight[selectRight.tileNumber] = tilesLeft[selectLeft.tileNumber];
      tilesLeft[selectLeft.tileNumber] = memory;
    } else {
      selectRight.selectRight();
    }
  }

  if (keysPressed[ENTER] == false) {
    limit = 0;
  }
}

// Initialize a set amount of tiles and return an array of random tiles
Tile[] initTiles(int tileCountLeft) {
  tiles = new Tile[tileCountLeft];
  
  // Give an image and to every tile
  for (int i = 0; i < tileCountLeft; i++) {
    float random = random(1, 9); // Get a random tile 
    tiles[i] = new Tile();
    tiles[i].setImage(loadImage("images/tiles/tile" + (int) random + ".png"));  //assign the image of the chosen tile to the tile
    tiles[i].setCollision((int) random); //set the collision of the chosen tile to the tile (todo)
  } 
  return tiles;
}

// Draw the tiles to be shown
void drawTilesLeft() {
  
  // Create tiles up to the tileCountLeft
  for (int i = 0; i < tileCountLeft; i++) {
    image(tilesLeft[i].getImage(), tileXLeft, tileYLeft);
    tileXLeft += tileDistanceXLeft;
    
    // set the tiles another row down after every 2 tiles
    if ((i + 1) % tileRowLeft == 0) {
      tileXLeft = tileXStartLeft;
      tileYLeft += tileDistanceYLeft;
    }
  } 
  tileXLeft = tileXStartLeft;
  tileYLeft = tileYStartLeft;
}

// Draw the tiles to be shown
void drawTilesRight() {
  
  // Create tiles up to the tileCountRight
  for (int i = 0; i < tileCountRight; i++) {
    image(tilesRight[i].getImage(), tileXRight, tileYRight);
    tilesRight[i].x = tileXRight;
    tilesRight[i].y = tileYRight;
    tileXRight += tileDistanceXRight;
    
    // set the tiles another row down after every 4 tiles
    if ((i + 1) % tileRowRight == 0) {
      tileXRight = tileXStartRight;
      tileYRight += tileDistanceYRight;
    }
  } 
  tileXRight = tileXStartRight;
  tileYRight = tileYStartRight;
}





// Function to let the game go back to the menu when you win
void win() {
  win = true;
  if (keysPressed[ENTER] == true) {
    file.stop();
    gameState = mainMenu;
    limit2 = true;
    setup();
  } 
}


// All the code that alters the Game World goes here
void updateGame() {
  // Win condition
  if (car.y <= -20) {
    win();
  }
  
  if (collisionTimer <= 100) {
    collisionTimer++;
  }
  if (startCheck == true) {
    if (destroyed) { 
      car.velocity = 0;
    } else {
      car.velocity = 1.2;
      car.rotate90();
    }
    car.CarCollision();
    car.move(previousDirection);
  }
  if (keysPressed[BACKSPACE] == true) {
    startCheck = true;
  } else if (keysPressed[SHIFT] == true) {
    car.y = height - 20;
    car.x = tileXStartRight + 25;
    previousDirection = 0;
    startCheck = false;
    destroyed = false;
    car.setImage(loadImage("images/carUp.png"));
    car.frame = 0;
  }
  Select();
  
}

// All the code that draws the Game World goes here

void drawMainMenu() {

  background(101,232,255);
  textAlign(CENTER);
  textSize(100);
  text("DON'T CRASH", width/2, height/4); 
  fill(0, 102, 153);
  textSize(30);
  text("LEVEL SELECT", width/2, 3*(height/5));
  text("OPTIONS", width/2, 4*(height/5));
}

void drawLevelSelect() {

  background(101,232,255);
  textSize(100);
  text("LEVEL SELECT", width/2, height/4);
}


void drawOptions() {

  background(101,232,255);
  textSize(30);
  text("MUTE SOUND", width/2, 3*(height/5));
  text("QUIT GAME", width/2, 4*(height/5));
}

void drawGame() {
  background(14, 209, 69); // make the background green

  // Draw the tiles and selector

  drawTilesLeft();
  drawTilesRight();
  if (startCheck == false) {
    if (Select) {
      selectLeft.drawSelectLeft();
    } else {
      selectRight.drawSelectRight();
    }
  }


  // Play the car explosion animation
  if (destroyed) {
    car.destroy();
  }

  // Draw the finish line
  image(loadImage("images/finishline.png"), lineX, 0);

  // Draw the line seperating the line select and the play field
  line(lineX, 0, lineX, height);

  // Draw the car
  image(car.getImage(), car.x, car.y);

  // Draw some placeholder text for the start and reset buttons
  fill(255, 0, 0);
  textSize(11);
  text("Press Enter to select and place tiles. Press backspace to start and press shift to reset", 1050, 719);
  
  if (win) {
    textSize(100);
    fill(255,0,0);
    text("YOU WIN!", width/2, height/2); 
  }
} 

void draw() {
  
   // causes the screens to advance on buttonpresses

  if (!keysPressed[ENTER]) {
    limit2 = false;
  }

  if (keysPressed[ENTER] && gameState == mainMenu) {
    gameState = levelSelect;
    limit2 = true;
  }

  if (keysPressed[ENTER] && gameState == levelSelect && limit2 == false) {
    file.stop();
      // Load a soundfile from the /data folder of the sketch and play it back
    file = new SoundFile(this, "/music/funky_theme.wav");
    file.loop();
    
    gameState = inGame;    
  } 


  if (keysPressed['O'] && gameState == mainMenu) {
    gameState = optionsScreen;
  }  


  if (keysPressed[BACKSPACE] && gameState == optionsScreen) {
    gameState = mainMenu;
  } 

  if (keysPressed[BACKSPACE] && gameState == levelSelect) {
    gameState = mainMenu;
  }
  
  // handles drawing of different screens
  updateGame();
   switch(gameState) {

  case mainMenu:
    drawMainMenu();
    break;

  case levelSelect:
    drawLevelSelect();
    break;

  case optionsScreen:
    drawOptions();
    break;

  case inGame:   
    drawGame();
    break;
  }  
}
