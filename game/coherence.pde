
float[] analyzeStream(AudioRecordingStream stream) {
  int fftSize = 1024;
 
  recorder = null;
  
  // tell it to "play" so we can read from it.
  stream.play();
  
  // create the fft we'll use for analysis
  FFT fft = new FFT( fftSize, stream.getFormat().getSampleRate() );
  
  // create the buffer we use for reading from the stream
  MultiChannelBuffer buffer = new MultiChannelBuffer(fftSize, stream.getFormat().getChannels());
  
  // figure out how many samples are in the stream so we can allocate the correct number of spectra
  int totalSamples = int( (stream.getMillisecondLength() / 1000.0) * stream.getFormat().getSampleRate() );
  
  // now we'll analyze the samples in chunks
  int totalChunks = (totalSamples / fftSize) + 1;
  
  int maxSum = 0;
  float[] maxSpectra = null;
  
  for (int chunkIdx = 0; chunkIdx < totalChunks; ++chunkIdx) {
    stream.read( buffer );
    fft.forward( buffer.getChannel(0) );
    
    int sum = 0;
    float[] spectrum = new float[fftSize/2];
    
    for (int i = 0; i < fftSize/2; ++i) {
      sum += fft.getBand(i);
      spectrum[i] = fft.getBand(i);
    }
    
    if (sum > maxSum) {
      maxSum = sum;
      maxSpectra = spectrum;
    }
  }
  return maxSpectra;
}

float compareChunks(float[] a, float[] b) {
  
  // todo
  return 0;
}