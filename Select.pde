class Select {
  
  int selectX, selectY;

  int tileNumber = 0;
  int limit = 0;

  // Function to move the selector over the tiles. 
  void select(int tileDistanceX, int tileX, int tileDistanceY, int tileY, int tileXStart, int tileRow, int tileCount) {
    if (keysPressed[RIGHT] && selectX != (tileDistanceX * (tileRow - 1) + tileXStart) && limit == 0) {
      limit = 1;
      selectX = selectX + tileDistanceX;
      tileNumber = tileNumber + 1;
    }
    if (keysPressed[LEFT] && selectX != tileX && limit == 0) {
      limit = 1;
      selectX = selectX - tileDistanceX;
      tileNumber = tileNumber - 1;
    }
    if (keysPressed[DOWN] && selectY != (tileCount / tileRow -1)  * tileDistanceY + tileY && limit == 0) {
      limit = 1;
      selectY = selectY + tileDistanceY;
      tileNumber = tileNumber + tileRow;
    }
    if (keysPressed[UP] && selectY != tileY && limit == 0) {
      limit = 1;
      selectY = selectY - tileDistanceY;
      tileNumber = tileNumber - tileRow;
    }

    // prevent the selector from going super saiyan
    if (keysPressed[UP] == false && keysPressed[DOWN] == false && keysPressed[LEFT] == false && keysPressed[RIGHT] == false && keysPressed[ENTER] == false) {
      limit = 0;
    }
  }

  void drawSelect() {
    image(loadImage("images/selection.png"), selectX, selectY);
  }
}