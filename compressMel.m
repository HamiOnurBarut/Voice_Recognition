function [ melCoeff ] = compressMel( x )
%   Detailed explanation goes here
[r c] = size(x);
melCoeff = zeros(r, c);
for a=1:r
    for b = 1:c
        if(x(a, b) ~= 0)
            melCoeff(a, b) = log10(x(a,b));
        else
            melCoeff(a, b) = 0;
        end
    end
end
end

