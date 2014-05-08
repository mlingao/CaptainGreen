class Player{
  PVector position, velocity; 
  
  Boolean isOnGround; 
  Boolean facingRight; 
  Boolean isHurt;
  int animDelay;
  int animFrame; 
  int energyCollected; 
  
  static final float JUMP_POWER = 9.5; //How high a player jumps
  static final float RUN_SPEED = 5;     //Speed of Running
  static final float AIR_RUN_SPEED = 1.5; // Running speed while in air. 
  static final float SLOWDOWN_PERC = 0.6; //Friction from ground; 
  static final float AIR_SLOWDOWN_PERC = 0.85; // resistance in air 0.85
  static final int RUN_ANIMATION_DELAY = 3; //Cycles pass during animation update
  static final float TRIVIAL_SPEED = 1; //If speed is under this than player is still. 
 
  Player(){
    isOnGround = false;
    facingRight = true; 
    isHurt = false;
    position = new PVector();
    velocity = new PVector (); 
    reset(); 
  }
  
  void reset(){
    isHurt = false;
    energyCollected = 0; 
    animDelay = 0;
    animFrame = 0;
    velocity.x = 0;
    velocity.y = 0; 
  }
  
  void inputCheck(){
    float speedHere = (isOnGround ? RUN_SPEED : AIR_RUN_SPEED);
    float frictionHere = (isOnGround ? SLOWDOWN_PERC : AIR_SLOWDOWN_PERC);
    
    if(theKeyboard.holdingLeft){
       velocity. x -= speedHere;  
    }else if(theKeyboard. holdingRight){
       velocity.x += speedHere;  
    }
    velocity.x *= frictionHere; 
    
    if(isOnGround){
     if(theKeyboard.holdingSpace || theKeyboard.holdingUp){
       //INPUT MUSIC for JUMPING
        velocity.y = -JUMP_POWER;
        isOnGround = false; 
     } 
    }
    
  }
  
  void checkForEnergy(){
   PVector centerOfPlayer;
  
   centerOfPlayer = new PVector (position.x, position.y - CaptainGreen_stand.height / 2);
  
   if(world1.worldSquareAt(centerOfPlayer) == World.TILE_ENERGY){
     world1.setSquareTo(centerOfPlayer, World.TILE_EMPTY);
     //music
     energyCollected++; 
   } 
    
  }
  
  void checkForFalling(){
     if( world1.worldSquareAt(position) == World.TILE_EMPTY){
       isOnGround = false; 
     }
     
     if (isOnGround == false){
       if(world1.worldSquareAt(position) == World.TILE_SOLID ||
          world1.worldSquareAt(position) == World.TILE_PLATFORM
         ){
         isOnGround = true;
         position.y = world1.topOfSquare(position);
         velocity.y = 0;
       }else{
         velocity.y += GRAVITY_POWER;
       }
     }
  }
  
  
  void checkForWallBumping(){
     int capGreenWidth = CaptainGreen_stand.width;
     int capGreenHeight = CaptainGreen_stand.height; 
     int wallProbeDistance = int(capGreenWidth * 0.3);
     int ceilingProbeDistance = int (capGreenHeight * 0.95); 
    
     PVector leftSideHigh, rightSideHigh, leftSideLow, rightSideLow, topSide;
     leftSideHigh = new PVector(); 
     rightSideHigh = new PVector(); 
     leftSideLow = new PVector(); 
     rightSideLow = new PVector();
     topSide = new PVector(); 
    
     leftSideHigh.x = leftSideLow.x = position.x - wallProbeDistance;
     rightSideHigh.x = rightSideLow.x = position.x + wallProbeDistance;
     leftSideLow.y = rightSideLow.y = position.y - 0.2 * capGreenHeight; 
     leftSideHigh.y = rightSideHigh.y = position.y - 0.8 * capGreenHeight; 
     
     topSide.x = position.x; 
     topSide.y = position.y - ceilingProbeDistance;
     
    if( world1.worldSquareAt(topSide) == World.TILE_SOLID
        //world1.worldSquareAt(topSide) == World.TILE_PLATFORM
       ){
          
      if(world1.worldSquareAt(position)==World.TILE_SOLID 
        // world1.worldSquareAt(position) == World.TILE_PLATFORM
         ) {
         
        position.sub(velocity);
        velocity.x=0.0;
        velocity.y=0.0;
      } else 
        {
          position.y = world1.bottomOfSquare(topSide)+ceilingProbeDistance;
          println(world1.bottomOfSquare(topSide)+ceilingProbeDistance);
          if(velocity.y < 0) 
            velocity.y = 0.0;
          
        }
    
    
    if( world1.worldSquareAt(leftSideLow)==World.TILE_SOLID || 
        world1.worldSquareAt(leftSideLow) == World.TILE_ROCK ) {
     
      position.x = world1.rightOfSquare(leftSideLow)+wallProbeDistance;
      if(velocity.x < 0) 
        velocity.x = 0.0;
         
    }
 
    }
   
    if( world1.worldSquareAt(leftSideHigh)==World.TILE_SOLID || 
        world1.worldSquareAt(leftSideHigh) == World.TILE_ROCK ) {
     
       position.x = world1.rightOfSquare(leftSideHigh)+wallProbeDistance;
      
      if(velocity.x < 0) 
        velocity.x = 0.0;
    }
  
    
   
    
   
    if( world1.worldSquareAt(rightSideLow)==World.TILE_SOLID || 
        world1.worldSquareAt(rightSideLow) == World.TILE_ROCK ) {
      position.x = world1.leftOfSquare(rightSideLow)-wallProbeDistance;
      if(velocity.x > 0) {
        velocity.x = 0.0;
      }
    }
    
 
    
   
    
    
   
    if( world1.worldSquareAt(rightSideHigh)==World.TILE_SOLID || 
        world1.worldSquareAt(rightSideHigh) == World.TILE_ROCK ) {
      position.x = world1.leftOfSquare(rightSideHigh)-wallProbeDistance;
      if(velocity.x > 0) {
        velocity.x = 0.0;
      }
    }
    
   
    
   
    
  }
  //set the status of the player to hurt
  void hurt(){
    isHurt = true;
  }
  
  void move(){
    position.add(velocity);
    checkForWallBumping();  
    checkForEnergy();
    checkForFalling(); 
  }
  
  void draw(){
    int capGreenWidth = CaptainGreen_stand.width;
    int capGreenHeight = CaptainGreen_stand.height;
    
   
    if(velocity.x <- TRIVIAL_SPEED){
      facingRight = false;
    }else if(velocity.x > TRIVIAL_SPEED){
      facingRight = true;  
    }
    
    pushMatrix();
    translate(position.x,position.y);
    if(facingRight == false){
      scale(-1,1);
    }
    translate(-capGreenWidth/2,-capGreenHeight);
    
    
    if(isHurt == true){
      image(CaptainGreen_hurt,0,0); 
    }
    else if(isOnGround == false){
       image(CaptainGreen_jump,0,0); 
    }
    else if(abs(velocity.x)<TRIVIAL_SPEED){
       image(CaptainGreen_stand,0,0); 
    }
    else{
      if(animDelay --<0){
        animDelay = RUN_ANIMATION_DELAY;
        if(animFrame == 0){
          animFrame = 1;
        }else {
          animFrame = 0;
        }
      }
      
      if(animFrame == 0){
        image(CaptainGreen_walk1, 0,0);
      } else {
        image(CaptainGreen_walk2, 0,0);
      }
    }
    

    
    popMatrix();
  }
}
