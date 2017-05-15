/*

// draw is run many times
void drawAnalysis() {
  if (jump != null) drawAnalysis(jump, 1);
  if (crouch != null) drawAnalysis(crouch, 2);
}
void drawAnalysis(float[] spectrum, int place) {
  fill(0);
  if (place == 1)  rect(0, height/2, width, height/2);
  if (place == 2)  rect(0, 0, width, height/2);
  
  stroke(255);
  for (int i = 0; i < spectrum.length; i++) {
    int x = i*2;
    int y = height / place;
    int val = (int) spectrum[i] * 5;    
    line(x, y, x, y - val);
  }
}
*/