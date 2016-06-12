function [ x ] = hammingWindow( samples )
% passes input samples through Hamming window
%   samples : input samples to be windowed
filt = hamming(256, 'periodic');
filt = filt';
[r ~] = size(samples);
x = zeros(r, 256);
for a = 1:r
    x(a,:) = filt.*samples(a,:);
end
end

