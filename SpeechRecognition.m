%% load feature vectors
load features
%% record and sample the speech with 8KHz and 1 second
fs = 8000; % in Hertz
x = recordVoice(fs, 1);
%% detect start and end points of the speech samples
x = x(findStartIndex(x):end);
sound(x);
x = x';
%% divide speech samples into frames
frameSize = 256;
frameStep = 200;
x = divFrames(x, frameSize, frameStep);
%% Window each frame
x = hammingWindow(x);
%% take Fourier transform and compute power spectral (square of absolute of FFT)
[r, ~] = size(x);
fx = fftPower(x, 256);
fftx = fx(:,1:129); 
%% Mel-scaled filter coefficients
Hmk = melFilterCoeff(256);
%% Passing through Mel-scaled filter bank
melCoeff = findMelCoeffs(Hmk, fftx);
%% Compress mel coefficients
melCoeff = compressMel(melCoeff);
%% DCT of log filter bank energies
fv = takeDCT(melCoeff, 12);
result = decide(fv);
fprintf(' It seems that you spelled the digit %d.\n\n', result);