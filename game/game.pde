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
int screen = 0;

ArrayList<Obstacle> obstacles  = new ArrayList<Obstacle>();

void setup() {
  size(800,600);
  setupRecording();
  img = loadImage("background.png");
  img.resize(800,600);
  
  m = new Mario();
  
  up = false;
  down = false;
  
  score = 0;
  highscore = 0; 
}


void draw() {
  if (screen == 0) {
    startScreen();    
  }
  else {
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


void keyPressed() {
  switch (keyCode) {
   case 38://up
     up = true;
     return;
   case 40://down
     down = true;
     return;
   }
}
void keyReleased() {
  if (screen == 0 && key == 'r') {
    if (!hasJumpSound()) handleRecordingJump();
    else handleRecordingCrouch();
    
  } else if (screen == 1) {
    switch (keyCode) {
     case 38: //up
       up = false;
       break;
     case 40: //down
       down = false;
       break;
    }
  }
}


void startScreen() {
  background(0);  
  if (!hasJumpSound()) {
    text("Press r to start and stop recording the jump sound", height/2, width/2);
  } else if (!hasCrouchSound()) {
    text("Press r to start and stop recording the crouch sound", height/2, width/2);
  } else {
    screen = 1;
    startStreamAnalysis();
  }
  
  if (isRecording()) {
    text("Recording", height/2+20, width/2+20);
    
    noStroke();
    if (isRecording()) {
      fill(255, 0, 0);
    } else {
      fill(0);
    }
    ellipse(width - 50, 50, 20, 20);
 }
}