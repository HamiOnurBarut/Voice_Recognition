function [ melCoeff ] = findMelCoeffs( Hmk, fftx )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
[r, ~] = size(fftx);
[numOfMelFilters, ~] = size(Hmk);
melCoeff = zeros(r, numOfMelFilters);
for a = 1:r
    for b = 1:numOfMelFilters
        melCoeff(a, b) = sum((fftx(a,:).*Hmk(b,:)));
    end
end
end

