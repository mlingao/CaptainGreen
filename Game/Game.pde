import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim; 

AudioPlayer music; 
AudioSample soundJump, soundDeath, soundEnergy; 

int gameStartTime, gameCurrentTime; 

PImage startScreen, controls1, controls2; 
PFont title;
int stage; 

PImage energy1, energy2; 
PImage bg, moon, grass, rock, spaceship, lava, plat;
PImage CaptainGreen_jump, CaptainGreen_stand,CaptainGreen_walk1, CaptainGreen_walk2, CaptainGreen_hurt; 
PImage CaptainBlue_walk1, CaptainBlue_walk2, 
       CaptainBrown_walk1, CaptainBrown_walk2, 
       CaptainPink_walk1, CaptainPink_walk2;

int height = 500;
int width = 750; 

float cameraOffsetX, cameraOffsetY;


  int minutes; 
   int seconds;


int animDelay;
int animFrame; 
final float GRAVITY_POWER = 0.5;

World world1 = new World(); 
World world2;
Player player = new Player();
Opponent opponent = new Opponent();
Keyboard theKeyboard = new Keyboard(); 

void setup(){ 
   size(width, height );
   stage = 1;
   startScreen = loadImage("bg.jpg");
   image(startScreen,0,0,width,height);
   title = loadFont("ArialMT-48.vlw");
   controls1 = loadImage("controls1.png");
   controls2 = loadImage("controls2.png");
  
  /*
   minim = new Minim(this);
   music = minim.loadFile(" ",1024);
   music.loop();
   int buffersize = 256;
   
   soundJump = minim.loadSample(" ",buffersize); 
   soundEnergy = minim.loadSample(" ", buffersize);
   soundDeath = minim.loadSample(" ",buffersize); 
  */
   //*********************
   //ELEMENTS OF THE WORLD
   //*********************
   bg = loadImage("bg.jpg");
   moon = loadImage("moon.png");
   grass = loadImage("grass.png");
   rock = loadImage("rock.png");
   lava = loadImage("lava.png");
   plat = loadImage("plat.png");
   spaceship = loadImage("SpaceShip.png");
   energy1 = loadImage("energyball1.png");
   energy2 = loadImage("energyball2.png");
   
   cameraOffsetX = 0.0;  
   cameraOffsetY = 0.0; 
   
   //**********************
   //ELEMENTS OF THE AGENTS
   //**********************
   CaptainGreen_jump = loadImage("jump.png");
   CaptainGreen_stand = loadImage("stand.png");
   CaptainGreen_walk1 = loadImage("walk_1.png");
   CaptainGreen_walk2 = loadImage("walk_2.png");
   CaptainGreen_hurt = loadImage("hurt.png");  
   
   CaptainBlue_walk1 = loadImage("CapBlue_walk1.png");
   CaptainBlue_walk2 = loadImage("CapBlue_walk2.png");
   
   CaptainBrown_walk1 = loadImage("CapBrown_walk1.png");
   CaptainBrown_walk2 = loadImage("CapBrown_walk2.png");
   
   CaptainPink_walk1 = loadImage("CapPink_walk1.png");
   CaptainPink_walk2 = loadImage("CapPink_walk2.png");
  
   
   noStroke();
   noSmooth();
   frameRate(30);
   resetGame();
}

void resetGame(){
   player.reset();
   opponent.reset();
   world1.reload();
   gameCurrentTime = gameStartTime = millis()/1000; 
}

void outlinedText(String sayThis, float atX, float atY) {
  textFont(title); // use the font we loaded
  textSize(30); 
  fill(0); // white for the upcoming text, drawn in each direction to make outline
  text(sayThis, atX-1,atY);
  text(sayThis, atX+1,atY);
  text(sayThis, atX,atY-1);
  text(sayThis, atX,atY+1);
  fill(255); // white for this next text, in the middle
  text(sayThis, atX,atY);
}

void updateCameraPosition(){
   int rightEdge = World.GRID_UNITS_WIDE * World.GRID_UNIT_SIZE - width;
   int topEdge = World.GRID_UNITS_TALL * World.GRID_UNIT_SIZE - height; 
   
   cameraOffsetX = player.position.x - width / 2; 
   if (cameraOffsetX < 0){
     cameraOffsetX = 0;
   } 
   
   if (cameraOffsetX > rightEdge){
     cameraOffsetX = rightEdge;  
   }
   
   cameraOffsetY = player.position.y - height/2;
   if(cameraOffsetY < 0){
      cameraOffsetY = 0; 
   }
   
   if (cameraOffsetY > topEdge){
      cameraOffsetY = topEdge;  
   }
}

void draw(){
 //**************************
 //stage 1 = beginning screen
 //**************************
 if(stage == 1){
  background(bg); 
  textAlign(CENTER);
  textSize(32);
  text ("TO THE SHIP!!",375,50);
  if(animDelay --<0){
      animDelay = 12;
      if(animFrame == 0){
        animFrame = 1;
      }else {
        animFrame = 0;
      }
   }

  if(animFrame == 0){
    image(controls1, 120, 150);
    text ("    ",375,450); 
  } else {
    image(controls2, 120, 150);
    text ("Press any key to start the game",375,450); 
  }
  if(keyPressed == true){
     stage = 2;
  } 
 }
 //**************************
 //stage 2 = first level
 //**************************
 else if(stage == 2){
 
   pushMatrix();
   translate(-cameraOffsetX, -cameraOffsetY);
   updateCameraPosition();
   
   
   textAlign(RIGHT);
  
   
   //WORLD
   world2 = new World(bg, moon);
   world1.render();
 
   //PLAYER 
   player.inputCheck(); 
   player.move();
   player.draw();
   

   
   //OPPONENT********************************************************
 
    
   if(world1.worldSquareAt(opponent.position) != world1.TILE_LAVA){
    
       opponent.move(player.position);
       opponent.draw();

    
   
       if(opponent.kill(player.position)){ //WIP
         player.hurt();
         stage = 3;
       }else { if(player.lavaDeath()){
                   player.hurt(); 
                   stage = 3; 
                }  
             }
     
   }
  
   //******************************************************************
   if(player.lavaDeath()){
      player.hurt();
      stage = 3;  
   }
   
   if(world1.worldSquareAt(player.position) == world1.TILE_SPACESHIP){
      stage = 4;  
      if(stage == 4){
          gameCurrentTime = millis() / 1000; 
      }
   }
   
   println("Player Position:" + player.position.x +" , " + player.position.y);
   println("Opponent Positon:"+ opponent.position.x +" , " + opponent.position.y);
   
   popMatrix();
   
 //**************************
 //ENERGY BALL DISPLAY COUNTER
 //**************************
   textAlign(TOP);
   image(energy1, 50, 433, 40 , 40 );
    
   outlinedText(" "+player.energyCollected, 85, 470);
   
   gameCurrentTime = millis()/ 1000;  
  
   minutes = (gameCurrentTime - gameStartTime) / 60;
   seconds = (gameCurrentTime - gameStartTime) % 60;
   

   if (seconds < 10) {
      outlinedText(minutes + ":0" + seconds, 650, 480); 
   } else {
       
      outlinedText(minutes + ":"  + seconds, 650, 480); 
   }
     
   
   
 }//end of stage 2
 
 //**************************
 // stage 3 = dead screen
 //**************************
  else if(stage == 3){
  //int animDelay;
  //int animFrame; 
  background(#030000);
  textAlign(CENTER);
  textSize(32);
  text ("TO THE SHIP!!",375,50);
  if(animDelay-- < 0){
    animDelay = 20;
    if(animFrame == 0){
      animFrame = 1;
    }else {
      animFrame = 0;
    }
  }
  if(animFrame == 0){
    textSize(28);
    text ("Press ENTER to restart the game",375,450); 
    textSize(90);
    text("GAME OVER!",375, 250);
  } else {
    text (" ",375,450); 
    text(" ",375, 250);
  }
  if(keyCode == ENTER){
    resetGame();
    tint(255);
    stage = 2;
  } 
 }//end of stage 3
  
  else if(stage == 4){
    background(#030000);
    textAlign(CENTER);
    textSize(32);
    text("TO THE SHIP!!", 375, 50);
    text("YOU WIN!!" , 375, 150); 
   
    outlinedText(" "+player.energyCollected, 180, 260);

    if(animDelay-- < 0){
      animDelay = 12;
    if(animFrame == 0){
      animFrame = 1;
    }else {
      animFrame = 0;
      }
    }
    if(animFrame == 0){
      image(energy1, 75, 200, 80, 80);
      textSize(32);
      text ("Press ENTER to play the game again",375,450); 
    } else {
      image(energy2, 75, 200, 80, 80);
      text (" ",375,450); 
    }
    
    if(keyCode == ENTER){
      resetGame();
      tint(255);
      stage = 2;
    } 
    
    
    
    
  }
}

void deadScreen(){
  loadPixels();
  tint(100);
  updatePixels();
}

void keyPressed(){
 theKeyboard.pressKey(key,keyCode); 
}

void keyReleased(){
 theKeyboard.releaseKey(key,keyCode); 
}

void stop(){
 music.close();
 soundJump.close();
 soundEnergy.close();
 soundDeath.close();  
 
 super.stop();  
  
}
