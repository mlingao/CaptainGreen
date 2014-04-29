class World{
 
 int totalEnergy; 
 
 int worldHeight = 500;
 int worldWidth = 750;
 
 int animDelay = 0;
 int animFrame = 0;
 
 static final int animation_Delay = 5 ; 
 
 static final int TILE_EMPTY     = 0;
 static final int TILE_SOLID     = 1;
 static final int TILE_ENERGY    = 2; 
 static final int TILE_START     = 3; 
 static final int TILE_SPACESHIP = 4;

 static final int GRID_UNIT_SIZE = 126;
 
 static final int GRID_UNITS_WIDE = 40;
 static final int GRID_UNITS_TALL = 4; 
 
 int [][] worldGrid = new int[GRID_UNITS_TALL][GRID_UNITS_WIDE];
 
 int [][] start_Grid = { {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0},
                         {0, 3, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1} };
   
 World(){}
 public World(PImage bg, PImage moon){
  background(bg);
  image(moon,-150,-100);
  
 } 
 
 void setSquareTo(PVector thisPosition, int newTile){
  int gridSpotX = int (thisPosition.x/ GRID_UNIT_SIZE);
  int gridSpotY = int (thisPosition.y/ GRID_UNIT_SIZE);
 
  if(gridSpotX < 0 || gridSpotX >= GRID_UNITS_WIDE ||
     gridSpotY < 0 || gridSpotY >= GRID_UNITS_TALL){
   return;
     } 
   
   worldGrid[gridSpotY][gridSpotX] = newTile;
   
 }
 
 int worldSquareAt(PVector thisPosition){
    float gridSpotX = thisPosition.x/GRID_UNIT_SIZE;
    float gridSpotY = thisPosition.y/GRID_UNIT_SIZE; 
    
    println("thisPosition.x  = " + thisPosition.x);
    println("thisPosition.y  = " + thisPosition.y);
    println(gridSpotX, gridSpotY);
    if (gridSpotX < 0){
       return TILE_SOLID; 
    }
    
    if (gridSpotX >= GRID_UNITS_WIDE){
       return TILE_SOLID; 
    }
    
    if (gridSpotY < 0) {
      return TILE_SOLID;
    }
    
    if (gridSpotY >= GRID_UNITS_TALL){
      return TILE_SOLID;
    }
    
    return worldGrid[int(gridSpotY)][int(gridSpotX)];
 }
 
  float topOfSquare(PVector thisPosition) {
    int thisY = int(thisPosition.y);
    thisY /= GRID_UNIT_SIZE;
    return float(thisY*GRID_UNIT_SIZE);
  }
  float bottomOfSquare(PVector thisPosition) {
    if(thisPosition.y<0) {
      return 0;
    }
    return topOfSquare(thisPosition)+GRID_UNIT_SIZE;
  }
  float leftOfSquare(PVector thisPosition) {
    int thisX = int(thisPosition.x);
    thisX /= GRID_UNIT_SIZE;
    return float(thisX*GRID_UNIT_SIZE);
  }
  float rightOfSquare(PVector thisPosition) {
    if(thisPosition.x<0) {
      return 0;
    }
    return leftOfSquare(thisPosition)+GRID_UNIT_SIZE;
  }
  
 void reload(){
    totalEnergy = 0; 
     
    for(int i=0;i<GRID_UNITS_WIDE;i++) {
      for(int ii=0;ii<GRID_UNITS_TALL;ii++) {
        if(start_Grid[ii][i] == TILE_START) { // player start position
          worldGrid[ii][i] = TILE_EMPTY; // put an empty tile in that spot
  
          // then update the player spot to the center of that tile
          player.position.x = i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
          player.position.y = ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
        } else {
          if(start_Grid[ii][i]==TILE_ENERGY) {
            totalEnergy++;
          }
          worldGrid[ii][i] = start_Grid[ii][i];
        }
      }
    }
   
 }
 
 
 
 void render() {
   

 // final int RUN_ANIMATION_DELAY = 3; //Cycles pass during animation update
     
   for(int i = 0; i < GRID_UNITS_WIDE; i++){
    for(int j = 0; j < GRID_UNITS_TALL; j++){
     switch(worldGrid[j][i]){
      case TILE_SOLID:
         image(grass, i*GRID_UNIT_SIZE, j*GRID_UNIT_SIZE);
         break;
      case TILE_SPACESHIP:
        image(spaceship,i * grass.width, 30 , 300,300);
        break;   
      case TILE_ENERGY:
          if(animDelay--<0){
            animDelay = animation_Delay;
            if(animFrame == 0){
              animFrame = 1; 
            } else {
              animFrame = 0;
            }
          }
          
          if(animFrame == 0){
            image(energy1, i * GRID_UNIT_SIZE ,(j * GRID_UNIT_SIZE) + 55, 50, 50);
          } else {   
            image(energy2, i * GRID_UNIT_SIZE ,(j * GRID_UNIT_SIZE) + 55, 50, 50);
          }
          break; 
     } 
    }
   }
}
 
}
  
  
