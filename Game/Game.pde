PImage startScreen; 
PFont title;
int screenSizeX, screenSizeY, stage; 

PImage energy1, energy2; 
PImage bg, moon, grass, rock, spaceship;
PImage CaptainGreen_jump, CaptainGreen_stand,CaptainGreen_walk1, CaptainGreen_walk2, CaptainGreen_hurt; 
PImage CaptainBlue_walk1, CaptainBlue_walk2, 
       CaptainBrown_walk1, CaptainBrown_walk2, 
       CaptainPink_walk1, CaptainPink_walk2;

int height = 500;
int width = 750; 

float cameraOffsetX; 

World world1 = new World(); 
World world2;
Player player = new Player();
Keyboard theKeyboard = new Keyboard(); 

final float GRAVITY_POWER = 0.5;

void setup(){ 
 size(width, height);
 stage = 1;
 //screenSizeX = round(screen.width * 0.90);
// screenSizeY = round(screen.height * 0.90);
// size(screenSizeX,screenSizeY);
 startScreen = loadImage("bg.jpg");
 image(startScreen,0,0,width,height);
 title = loadFont("Castellar-48.vlw");
 
 
 bg = loadImage("bg.jpg");
 moon = loadImage("moon.png");
 grass = loadImage("grass.png");
 rock = loadImage("rock.png");
 spaceship = loadImage("SpaceShip.png");
 energy1 = loadImage("energyball1.png");
 energy2 = loadImage("energyball2.png");
 
 cameraOffsetX = 0.0;  

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
   world1.reload();
}

void outlinedText(String sayThis, float atX, float atY) {
  textFont(title); // use the font we loaded
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
  
   cameraOffsetX = player.position.x - width / 2; 
   if (cameraOffsetX < 0){
     cameraOffsetX = 0;
   } 
   
   if (cameraOffsetX > rightEdge){
     cameraOffsetX = rightEdge;  
   }
}

void draw(){
 // background();
 
 if(stage == 1){
  textAlign(CENTER);
  textSize(32);
  text ("TO THE SHIP!!",375,50);
  text ("Press any key to start game",375,450); 
  if(keyPressed == true){
    stage = 2;
  } 
 }
 if(stage == 2){
   pushMatrix();
   translate(-cameraOffsetX,0.0);
   updateCameraPosition();
   world2 = new World(bg, moon);
   world1.render();
 
   player.inputCheck(); 
   player.move();
   player.draw();
   popMatrix();
   
   textAlign(TOP);
   outlinedText("Energy:" + player.energyCollected + "/" + world1.totalEnergy, 8, height - 10);
 }
  
}

void keyPressed(){
 theKeyboard.pressKey(key,keyCode); 
}

void keyReleased(){
 theKeyboard.releaseKey(key,keyCode); 
}
