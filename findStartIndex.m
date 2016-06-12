function [ sI ] = findStartIndex( samples )
y = 1000*samples.^2;
sI = 1;
for i = 1:100:length(samples)-100
    num = 0;
    for j=1:100
        if(y(i + j) > 2)
            num = num + 1;
        end
    end
    if(num > 20)
        sI = i + j;
        break;
    end
end
end