function [ y ] = divFrames( samples, fSize, fStep )
% divides samples into frames
%   samples : samples to be divided
numFrames = ceil((6500 - 2*fStep)/fSize)*2 + 2;
x = [samples zeros(1, (numFrames*fSize - length(samples)))];
y = zeros(numFrames, fSize);
for a = 1:numFrames
    for b = 1:fSize
        y(a,b) = x((a-1)*fStep + b);
    end 
end
end

