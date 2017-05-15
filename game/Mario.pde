class Mario{
  float w,h,x,y,vx,vy,
  accelerationX,accelerationY,
  speedLimit,friction,bounce,gravity;
  boolean isOnGround;
  float jumpForce;
  float halfWidth,halfHeight;
  int currentFrame;
  String collisionSide;
  boolean facingRight;
  int frameSequence;
  boolean doubleJump;
  int bounderay;
  PVector pos;
  float r = 55;
  
  Mario(){
    w = 75;
    h = 90;
    x = 20;
    y = 0;
    vx = 0;
    vy = 0;
    accelerationX = 0;
    accelerationY = 0;
    speedLimit = 5;
    friction = 0.96;
    bounce = -0.1;
    gravity = 1;
    isOnGround = false;
    jumpForce = -30;
    doubleJump = false;
    bounderay = 40;
    marioc = loadImage("marioc.png");
    marioj = loadImage("marioj.png");
    marioc.resize((int)w+10,50);
    marioj.resize((int)w,(int)h);   
    pos = new PVector(x,y);
  }
  
  
  void update(){
    if (up && isOnGround){
      vy += jumpForce;
      isOnGround = false;
      friction = 1;
    }
    
    vy += accelerationY;

    ////apply the forces of the universe
    vy += gravity;

    ////correct for maximum speeds
    if (vy > speedLimit * 2){
      vy = speedLimit * 2;
    }

    ////move the player
    y+=vy;
    println(y);
  
    if(down){
      h = 45;
      bounderay = 49;
    }
    else{
      h = 90;
      bounderay = 44;
    }
    
  }
  
  void checkBoundaries(){
    if (y + h > height - bounderay){
      y = height - bounderay - h;
      isOnGround = true;
    }    
  }
  
  void display(){
   if(down){
     image(marioc, x, y);
   }
   else{
     image(marioj, x, y);
   }
  }
}