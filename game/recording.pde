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
  in = minim.getLineIn(Minim.STEREO, FFT_SIZE);
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
  recorder = null;
  
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
}
void handleRecordingCrouch() {
  currentRecording = currentRecording == 2 ? stopRecording(2) : startRecording(2);
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

void startStreamAnalysis() {
  in.addListener(new RecordingListener(in.getFormat().getSampleRate()));
}

int xyz = 0;
class RecordingListener implements AudioListener {
  FFT fft;
  
  public RecordingListener(float sampleRate) {
    fft = new FFT(FFT_SIZE, sampleRate);
  }
  
  public synchronized void samples(float[] samp) {
  }
  
  public synchronized void samples(float[] sampL, float[] sampR) {
    fft.forward(sampL);
    float[] spectrum = new float[FFT_SIZE/2];
    for (int i = 0; i < FFT_SIZE/2; ++i) {
      spectrum[i] = fft.getBand(i);
    }
    float coherenceJump = compareChunks(jump, spectrum);
    float coherenceCrouch = compareChunks(crouch, spectrum);
    if (coherenceJump > 0.5) println("JUMP       (" + coherenceJump + ")");
    if (coherenceCrouch > 0.5) println("CROUCH     (" + coherenceCrouch + ")");
  }
}