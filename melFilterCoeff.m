function [ Hmk ] = melFilterCoeff( fftSize )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
fre = [0, 6, 10, 15, 21, 27, 34, 41, 50, 61, 73, 87, 103, 128];
Hmk = zeros(12, fftSize/2);
for f=1:12
    for k = 1:129
        if ( k <= fre(f))
            Hmk(f,k) = 0;
        elseif (fre(f) < k && fre(f+1)>=k)
            Hmk(f,k) = (k-fre(f))/(fre(f+1)-fre(f));
        elseif (fre(f+2)>k && fre(f+1)<k)
            Hmk(f,k) = (fre(f+2)-k)/(fre(f+2)-fre(f+1));
        else
            Hmk(f, k) = 0;
        end
    end
end
end

