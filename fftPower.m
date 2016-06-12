function [ x ] = fftPower( samples, transformSize )
% takes fast Fourier transform of each frames
%   samples : Each frame
%   transformSize : FFT transform size
[rows, ~] = size(samples);
x = zeros(rows, transformSize);
for a = 1:rows
    x(a, :) = abs(fft(samples(a,:),transformSize)).^2;
end
x = x/transformSize;
end