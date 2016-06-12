function [ melCoeff ] = takeDCT( x, DCTsize )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
[r, c] = size(x);
melCoeff = zeros(r, c);
for a = 1:r
    melCoeff(a, :) = dct(x(a,:), DCTsize);
end
end

