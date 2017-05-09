import ddf.minim.Minim;


Mario m;
PImage img;
PImage obstacle;
PImage marioc;
PImage marioj;
boolean up, down;
int bgx = 0;
float ground = 360;
int frames;
int highscore;
int score;
boolean crouchSound = false;
boolean jumpSound = false;
boolean recording;
int screen = 0;

ArrayList<Obstacle> obstacles  = new ArrayList<Obstacle>();

void setup(){
  size(800,600);
  img = loadImage("background.png");
  img.resize(800,600);
  
  m = new Mario();
  
  up = false;
  down = false;
  
  score = 0;
  highscore = 0;

  
  
}


void draw()
{
  if(screen == 0){
    startScreen();
  }
  else{  
   m.update();
   background(0);
   bgx--;
   if (bgx < -img.width) {
    bgx=0;  
   }
   image(img, bgx, 0);
   image(img, bgx+img.width, 0);

    stroke(0,0,0);
    
    m.display();
    m.checkBoundaries();
     
    if (frameCount % 90 == 0) {
      obstacles.add(new Obstacle());
    }
    boolean save = true;
    for (int i = obstacles.size() - 1; i >= 0; i--) {
      Obstacle p = obstacles.get(i);
      p.update();
      if (p.x < -p.w) {
        obstacles.remove(i);
      }
      if (p.hits(m)) {
        save = false;
       }
     }

     if(save){
       score++;
     }
     else{
       if(score > highscore){highscore = score;}
       score = 0;
     }
    
    
    fill(100,255, 50);
    textSize(64);
    text(score, 0, 120);
    score = constrain(score, 0, score);
    
    fill(255,0, 0);
    textSize(64);
    text("Highscore: " + highscore, 0, 50);
    highscore = constrain(highscore, 0,highscore);
  }
}


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
    if (y + h > height-bounderay){
      y = height-bounderay - h;
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
  

void keyPressed(){
  switch (keyCode){
   case 38://up
     println("up");
     up = true;
     break;
   case 40://down
     down = true;
     break;
   case 74:
     recording = true;
     break;
   case 67:
     recording = true;
     break;
   }
}
void keyReleased(){
  switch (keyCode){
   case 38://up
     up = false;
     break;
   case 40://down
     down = false;
     break;
   case 74:
     jumpSound = true;
     recording = false;
     break;
   case 67:
     crouchSound = true;
     recording = false;
     break;
  }
}



void startScreen(){
  
  background(0);

  if(jumpSound == false) {
    text("Press J to record Jump sound", height/2, width/2);
  }
  else if(crouchSound == false) {
    text("Press C to record Crouch sound", height/2, width/2);
  }
  else {
    screen = 1;
  }
  
  if (recording) {
    text("Recording", height/2+20, width/2+20);
 }
}