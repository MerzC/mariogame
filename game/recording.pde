import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.spi.*; // for AudioStream

Minim minim;
AudioInput in;
AudioRecorder recorder;

float[] jump = null;
float[] crouch = null;

void setupRecording() {
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048);
}

// action 1 = crouch
// action 2 = jump
int startRecording(int action) {
  if (isRecording()) return 0;
  
  recorder = minim.createRecorder(in, "record.wav");
  recorder.beginRecord();
  
  return action;
}

int stopRecording(int action) {
  if (!isRecording()) return -1;
  // stop recorder and get audioRecordingStream
  recorder.endRecord();
  
  float[] analysis = analyzeStream(recorder.save());
  
  switch(action) {
    case 1:
      jump = analysis;
      break;
    case 2:
      crouch = analysis;
      break;
  }
  
  return 0;
}

int currentRecording = -1;
void handleRecordingJump() {
  currentRecording = currentRecording == 1 ? stopRecording(1) : startRecording(1);
  println("recording:" + currentRecording);
}
void handleRecordingCrouch() {
  currentRecording = currentRecording == 2 ? stopRecording(2) : startRecording(2);
  println("recording:" + currentRecording);
}

boolean isRecording() {
  return recorder != null && recorder.isRecording();
}
boolean hasJumpSound() {
  return jump != null;
}
boolean hasCrouchSound() {
  return crouch != null;
}