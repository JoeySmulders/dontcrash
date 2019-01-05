class Menu {
  void drawMenu() {
    textSize(12);
    textAlign(LEFT);
    text("Press the arrow keys to move between menu options and tiles", 50, 600);
    text("Press SPACE to select menu options and tiles", 50, 625);
    text("Press ENTER to start the car ingame", 50, 650);
    text("Press R to return to the main menu", 50, 675);
  }

  void drawMainMenu() {
    background(101, 232, 255);
    textAlign(CENTER);
    textSize(100);
    text("DON'T CRASH", width/2, height/4); 
    fill(0, 102, 153);
    textSize(30);
    text("LEVEL SELECT", width/2, 3*(height/5));
    text("OPTIONS", width/2, 4*(height/5));
  }

  void drawLevelSelect() {
    background(101, 232, 255);
    textAlign(CENTER);
    textSize(100);
    text("LEVEL SELECT", width/2, height/4);
    textSize(24);

    //draws leveltexts
    for (int i = 0; i < levelAmount; i++) {
      text("Level "+(i+1), levelsList.get(i).xPos, levelsList.get(i).yPos);
    }


    //draws selector and makes variable to load in selected level
    if (levelSelector < 30) {
      if (keysPressed[RIGHT]) {

        levelSelector++;
        keysPressed[RIGHT] = false;
      }
    }
    
    if (levelSelector < 20) {
      if (keysPressed[DOWN]) {

        levelSelector += 10;
        keysPressed[DOWN] = false;
      }
    }

    if (levelSelector > 10) {
      if (keysPressed[UP]) {

        levelSelector -= 10;
        keysPressed[UP] = false;
      }
    }

    if (levelSelector > 0) {
      if (keysPressed[LEFT]) {

        levelSelector--;
        keysPressed[LEFT] = false;
      }
    }

    image(loadImage("images/selectionFalse.png"), (levelsList.get(levelSelector).xPos - 50), (levelsList.get(levelSelector).yPos - 50));
  }

  void drawOptions() {

    background(101, 232, 255);
    fill(0, 102, 153);
    textSize(30);
    text("QUIT GAME", width/2, 4*(height/5));

    // Sound
    if (options == 0) {
      fill(255, 255, 255);

      // Switches text based on if the music is turned on or off
      if (music == true) {
        text("SOUND OFF", width/2, 3*(height/5));
      } else if (music == false) {
        text("SOUND ON", width/2, 3*(height/5));
      }
      fill(0, 102, 153);
    }

    // Quit
    else if (options == 1) {
      fill(0, 102, 153);
      text("SOUND ON/OFF", width/2, 3*(height/5));
      fill(255, 255, 255);
      text("QUIT GAME", width/2, 4*(height/5));
      fill(0, 102, 153);
    }

    // Press DOWN when 'Sound' is selected to move down
    if (keysPressed[DOWN] || (options == 2 && keysPressed[DOWN])) {
      options = 1;
    }

    // Press UP when 'quit' is selected to move up
    if ((options == 1) && (keysPressed[UP])) {
      options = 0;
    }

    // Press RIGHT to turn the music off
    if (options == 0 && keysPressed[RIGHT] && music == true) {
      file.stop();
      music = false;
    }

    // Press LEFT to turn the music on
    if (options == 0 && keysPressed[LEFT] && music == false) {
      file.loop();
      music = true;
    }

    // Press this option to exit the game
    if ((options == 1) && (keysPressed[' '])) {
      exit();
    }
  }
}
