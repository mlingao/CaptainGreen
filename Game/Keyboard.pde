class Keyboard{
   Boolean holdingUp, holdingRight, holdingLeft, holdingSpace, pressUP;
  
   Keyboard(){
     holdingUp = holdingRight = holdingLeft = holdingSpace = false; 
     pressUP = false; 
   } 
   
   void pressKey(int key, int keyCode){
     if (key == 'r')
        resetGame(); 
      
 
   
   if(keyCode == UP){
     holdingUp = true; 
     pressUP = true; 
   }
   
   if(keyCode == LEFT){
      holdingLeft = true;  
   }
   
   if(keyCode == RIGHT){
      holdingRight = true;  
   }
   if (key == ' '){
     holdingSpace = true; 
   } 
  }
  
  void releaseKey(int key, int keyCode){
   if(keyCode == UP){
      holdingUp = false;
      pressUP = true; 
   } 
    
   if(keyCode == LEFT){
      holdingLeft = false;  
   }
   
   if(keyCode == RIGHT){
      holdingRight = false;  
   }
   if (key == ' '){
     holdingSpace = false; 
   } 
  }
}
