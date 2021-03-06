static int FFT_SIZE = 1024;


float[][] analyzeStream(AudioRecordingStream stream) {
  
  // tell it to "play" so we can read from it.
  stream.play();
  
  // create the fft we'll use for analysis
  FFT fft = new FFT( FFT_SIZE, stream.getFormat().getSampleRate() );
  
  // create the buffer we use for reading from the stream
  MultiChannelBuffer buffer = new MultiChannelBuffer(FFT_SIZE, stream.getFormat().getChannels());
  
  // figure out how many samples are in the stream so we can allocate the correct number of spectra
  int totalSamples = int( (stream.getMillisecondLength() / 1000.0) * stream.getFormat().getSampleRate() );
  
  // now we'll analyze the samples in chunks
  int totalChunks = (totalSamples / FFT_SIZE) + 1;
  
  float[][] spectra = new float[totalChunks][FFT_SIZE/2];
  int maxSpectrumIx = -1;
  int maxSum = 0;
  
  for (int chunkIdx = 0; chunkIdx < totalChunks; ++chunkIdx) {
    stream.read( buffer );
    fft.forward( buffer.getChannel(0) );
    int sum = 0;
    
    for (int i = 0; i < FFT_SIZE/2; ++i) {
      sum += fft.getBand(i);
      spectra[chunkIdx][i] = fft.getBand(i);
    }
    if (sum > maxSum) {
      maxSum = sum;
      maxSpectrumIx = chunkIdx;
    }
  }
  if( maxSpectrumIx == 0) maxSpectrumIx = 1;
  if( maxSpectrumIx == totalChunks-1) maxSpectrumIx = totalChunks-2;
  
  return new float[][]{spectra[maxSpectrumIx-1], spectra[maxSpectrumIx], spectra[maxSpectrumIx + 1]};
}

float compareChunks(float[] a, float[] b) {
  float equality = 0;
  
  
  for (int i = 0; i < a.length; i++) {
    equality += a[i] < b[i] ? (a[i] / b[i]) : (b[i]/a[i]);
  }
  return equality / a.length;
}

float compareChunks(float[][] a, float[][] b) {
  float equality = 0;
  for (int i = 0; i < 3; i++) {
    equality += compareChunks(a[i], b[i]);
  }
  return equality / 3;
}