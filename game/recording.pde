import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.spi.*; // for AudioStream

Minim minim;
AudioInput in;
AudioRecorder recorder;

float[][] jump;
float[][] crouch;

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
  float[][] analysis = analyzeStream(recorder.save());
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
  float[] prevPrevSpectrum;
  float[] prevSpectrum;
  FFT fft;
  
  public RecordingListener(float sampleRate) {
    fft = new FFT(FFT_SIZE, sampleRate);
  }
  
  public synchronized void samples(float[] samp) {
  }
  
  public synchronized void samples(float[] samp, float[] sampR) {
    fft.forward(samp);
    float[] spectrum = new float[FFT_SIZE/2];
    for (int i = 0; i < FFT_SIZE/2; ++i) {
      spectrum[i] = fft.getBand(i);
    }    
    if (prevPrevSpectrum != null) {
      float[][] stream = new float[][]{prevPrevSpectrum, prevSpectrum, spectrum};
      
      float coherenceJump = compareChunks(jump, stream);
      float coherenceCrouch = compareChunks(crouch, stream);
      
      if (coherenceJump > 0.5 && coherenceJump > coherenceCrouch)   m.jump();
      if (coherenceCrouch > 0.5 && coherenceCrouch > coherenceJump) m.crouch();
    
    }
    
    prevPrevSpectrum = prevSpectrum;
    prevSpectrum = spectrum;
  }
}