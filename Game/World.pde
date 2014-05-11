class World{
 
 int totalEnergy; 
 
 int worldHeight = 500;
 int worldWidth = 750;
 
 int animDelay = 0;
 int animFrame = 0;
 
 static final int animation_Delay = 3 ; 
 
 static final int TILE_EMPTY         = 0;
 static final int TILE_SOLID         = 1;
 static final int TILE_ENERGY        = 2; 
 static final int TILE_START         = 3; 
 static final int TILE_SPACESHIP     = 4;
 static final int TILE_OPPONENTSTART = 5;
 static final int TILE_ROCK          = 6; 
 static final int TILE_PLATFORM      = 7; 
 static final int TILE_LAVA          = 8; 

 static final int GRID_UNIT_SIZE = 100;//126
 
 static final int GRID_UNITS_WIDE = 40;
 static final int GRID_UNITS_TALL = 8; //4
 
 int [][] worldGrid = new int[GRID_UNITS_TALL][GRID_UNITS_WIDE];
 
 int [][] start_Grid = { {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 0, 0, 0, 7, 0, 0, 0, 7, 7, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 5, 0, 3, 2, 7, 7, 7, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0},
                         {1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 8, 8, 8, 8, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1} };
   
 PVector platform = new PVector(); 
 ArrayList<PVector> platformArray = new ArrayList(); 
 
 World(){}
 public World(PImage bg, PImage moon){
  background(bg);
  image(moon,-150, 100);
  
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
 
 float topSquare(PVector thisPosition) {
    int thisY = int(thisPosition.y);
    
    
    thisY /= GRID_UNIT_SIZE;
    return float(thisY * GRID_UNIT_SIZE);
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
  
 
 void loadPlatform(){
    for(int i = 0; i < GRID_UNITS_WIDE; i++){
     for(int ii = 0; ii < GRID_UNITS_TALL; ii++){
       platform.x = i* GRID_UNIT_SIZE + (GRID_UNIT_SIZE / 2); 
       platform.y = ii * GRID_UNIT_SIZE + (GRID_UNIT_SIZE / 2); 
      
       platformArray.add(platform); 
     } 
    }
  
  
 } 
  
  
 void reload(){
    totalEnergy = 0; 
     
    for(int i=0;i<GRID_UNITS_WIDE;i++) {
      for(int ii=0;ii<GRID_UNITS_TALL;ii++) {
        if(start_Grid[ii][i] == TILE_OPPONENTSTART){
          worldGrid[ii][i] = TILE_EMPTY;
         
          opponent.position.x = i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
          opponent.position.y = ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2); 
          
        }
        
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
         image(grass, i*GRID_UNIT_SIZE, j*GRID_UNIT_SIZE, 100,100);
         break;
      case TILE_SPACESHIP:
        image(spaceship,i * GRID_UNIT_SIZE, j * GRID_UNIT_SIZE - 125, 150 ,150);
        break;   
      case TILE_ENERGY:
          if(animDelay--<0){
            animDelay = 100; 
            //animDelay = animation_Delay;
            if(animFrame == 0){
              animFrame = 1; 
            } else {
              animFrame = 0;
            }
          }
          
          if(animFrame == 0){
            image(energy1, i * GRID_UNIT_SIZE ,(j * GRID_UNIT_SIZE) + 30, 50, 50);
          } else{
            //image(energy1, i * GRID_UNIT_SIZE ,(j * GRID_UNIT_SIZE) + 45, 50, 50);
            image(energy1, i * GRID_UNIT_SIZE ,(j * GRID_UNIT_SIZE) + 50, 50, 50);
              }
          
          break; 
       case TILE_ROCK:
         image(rock, i * GRID_UNIT_SIZE, j * GRID_UNIT_SIZE + 25);
         break; 
         
       case TILE_PLATFORM:
         image(plat, i * GRID_UNIT_SIZE, j * GRID_UNIT_SIZE, 100, 100);
         break; 
       case TILE_LAVA:
         image(lava, i * GRID_UNIT_SIZE, j * GRID_UNIT_SIZE, 100, 100);
         break;
     } 
    }
   }
}
 
}
  
  

