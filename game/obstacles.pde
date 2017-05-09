// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/cXgA1d_E-jY

class Obstacle {
  float x;
  float speed = 10;
  float top;
  float w = 40;
  PImage obstacleimg = loadImage("brick.jpg");
  int heightobs;


  Obstacle() {
    heightobs = (int)random(60,100);
    obstacleimg.resize((int)w,heightobs);
    x = width + w;
    top = random(height-200, height-100);
    //bottom = random(100, height/2);
    image(obstacleimg,x,top);
  }

boolean hits(Mario b) {

  float dx = (b.x+b.w/2) - (x+w/2);
  float dy = (b.y+b.h/2) - (top+heightobs/2);

  float combinedHalfWidths = b.w/2 + w/2;
  float combinedHalfHeights = b.h/2 + heightobs/2;

  if (abs(dx) < combinedHalfWidths){

    if (abs(dy) < combinedHalfHeights){

      float overlapX = combinedHalfWidths - abs(dx);
      float overlapY = combinedHalfHeights - abs(dy);

      if (overlapX >= overlapY){
        if (dy > 0){
           return true;
        }else{
          return true;

        }
      }else{
        if (dx > 0){
          return true;

        }else{
          return true;

        }
      }
    } else {
     return false;
    }
  }else {
    return false;
  }

  }


  void update() {
    x -= speed;
    image(obstacleimg,x,top);
  }
}