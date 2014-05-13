class Opponent {
  PVector position, velocity;
  PVector sense = new PVector();
  PVector negSense = new PVector(); 


  Boolean opponentOnGround;
  Boolean opponentFacingRight;

  int animDelay;
  int animFrame;

  static final float JUMP_POWER = 9.0; //How high a player jumps  
  static final float RUN_SPEED = 6.75;     //Speed of Running
  static final float AIR_RUN_SPEED = 3; // Running speed while in air. 
  static final float SLOWDOWN_PERC = 0.6; //Friction from ground; 
  static final float AIR_SLOWDOWN_PERC = .85; // resistance in air 0.85
  static final int RUN_ANIMATION_DELAY = 3; //Cycles pass during animation update
  static final float TRIVIAL_SPEED = 1; //If speed is under this than player is still.  


  Opponent() {
    opponentOnGround = false;
    opponentFacingRight = true; 

    position = new PVector();
    velocity = new PVector();
    reset();
  }

  void reset() {
    animDelay = 0;
    animFrame = 0;
    velocity.x = 0;
    velocity.y = 0;
  }

  void checkForFalling() {
    if ( world1.worldSquareAt(position) == World.TILE_EMPTY || world1.worldSquareAt(position) == World.TILE_LAVA) {
      opponentOnGround = false;
    
    }

    if (opponentOnGround == false) {
      if (world1.worldSquareAt(position) == World.TILE_SOLID) {
        opponentOnGround = true;
        position.y = world1.topOfSquare(position);
        velocity.y = 0;
      }
      else {
        velocity.y += GRAVITY_POWER;
      }
    }
  }

  void checkForWallBumping() {
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

    if ( world1.worldSquareAt(topSide)==World.TILE_SOLID) {
      if (world1.worldSquareAt(position)==World.TILE_SOLID) {
        position.sub(velocity);
        velocity.x=0.0;
        velocity.y=0.0;
      } 
      else {
        position.y = world1.bottomOfSquare(topSide)+ceilingProbeDistance;
        if (velocity.y < 0) {
          velocity.y = 0.0;
        }
      }
    }

    if ( world1.worldSquareAt(leftSideLow)==World.TILE_SOLID) {
      position.x = world1.rightOfSquare(leftSideLow)+wallProbeDistance;
      if (velocity.x < 0) {
        velocity.x = 0.0;
      }
    }

    if ( world1.worldSquareAt(leftSideHigh)==World.TILE_SOLID) {
      position.x = world1.rightOfSquare(leftSideHigh)+wallProbeDistance;
      if (velocity.x < 0) {
        velocity.x = 0.0;
      }
    }

    if ( world1.worldSquareAt(rightSideLow)==World.TILE_SOLID) {
      position.x = world1.leftOfSquare(rightSideLow)-wallProbeDistance;
      if (velocity.x > 0) {
        velocity.x = 0.0;
      }
    }

    if ( world1.worldSquareAt(rightSideHigh)==World.TILE_SOLID) {
      position.x = world1.leftOfSquare(rightSideHigh)-wallProbeDistance;
      if (velocity.x > 0) {
        velocity.x = 0.0;
      }
    }
  }




  void chase(PVector playerPosition){
 
    if (playerPosition.x > position.x){
       velocity.x = RUN_SPEED;
       position.x++;
        
    }
    
    //SLOWS DOWN A BIT WHEN IT GETS CLOSE TO THE PLAYER
    if (distanceBetweenX(playerPosition, position)<30 && distanceBetweenX(playerPosition, position)>-30){
        for(int i=0; i < 200; i++){
          velocity.x = 0.0;
        }
    }
    else if (playerPosition.x < position.x){
           velocity.x = -RUN_SPEED;
           position.x--; 
          }    
    
  }
  
  
 void lavaJump(){
  if(world1.worldSquareAt(sense()) == world1.TILE_PLATFORM){
      velocity.y = -JUMP_POWER;
      //  velocity.x += .4;
        opponentOnGround = false;
       // position.y = world1.topOfSquare(position);
    
  } 
   
   
  if(world1.worldSquareAt(sense()) == world1.TILE_LAVA){
        println("GAME DRAW WORKING?");
        velocity.y = -JUMP_POWER;
        velocity.x += .4;
        opponentOnGround = false;
        //position.y = world1.topOfSquare(position);
     }
     
  if(world1.worldSquareAt(negativeSense()) == world1.TILE_LAVA){
       println("GAME DRAW WORKING?");
       velocity.y = -JUMP_POWER;
       velocity.x += .4;
       opponentOnGround = false;
      // position.y = world1.topOfSquare(position);
     }
     
 
  
 } 
 
 PVector negativeSense(){
  PVector temp = position;
  
  negSense.x = temp.x - 10;
  negSense.y = temp.y -10;
  
  return negSense; 
  
 } 
 
 PVector sense(){
   PVector temp = position;
   
   sense.x = temp.x + 10;
   sense.y = temp.y + 10;
   
   return sense;
 }
  
  boolean kill(PVector v1){ //only determined by the x coordinate
    if ((distanceBetweenX(v1, position)<60 && distanceBetweenX(v1, position)>-60) && (distanceBetweenY(v1, position)<80 && distanceBetweenY(v1, position)>-80)){
      return true;
    }
    else
      return false;
  }
  float distanceBetweenX(PVector v1, PVector v2){
    return v1.x - v2.x;
  }
  float distanceBetweenY(PVector v1, PVector v2){
    return v1.y - v2.y;
  }
 


  void move(PVector playerPosition) {
    position.add(velocity);
    checkForWallBumping();  
    checkForFalling();
    lavaJump(); 
    chase(playerPosition);
    //checkForFalling();
  }

  void draw() {
    int capGreenWidth = CaptainGreen_stand.width;
    int capGreenHeight = CaptainGreen_stand.height;

    
    if(velocity.x <- TRIVIAL_SPEED){
      opponentFacingRight = false;
    }else if(velocity.x > TRIVIAL_SPEED){
      opponentFacingRight = true;  
    }
    
    
    //println(opponentOnGround);
    if (velocity.x <- TRIVIAL_SPEED) {
      opponentFacingRight = false;
    }

    pushMatrix();
    translate(position.x, position.y);
    if (opponentFacingRight == false) {
      scale(-1, 1);
    }
    translate(-capGreenWidth/2, -capGreenHeight);

    if (animDelay --<0) {
      animDelay = RUN_ANIMATION_DELAY;
      if (animFrame == 0) {
        animFrame = 1;
      }
      else {
        animFrame = 0;
      }
    }

    if (animFrame == 0) {
      image(CaptainBlue_walk1, 0, 0);
    } 
    else {
      image(CaptainBlue_walk2, 0, 0);
    }

    popMatrix();
  }
}

