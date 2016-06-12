function [ outputDigit ] = decide( featureVector )
load features 
distance0 = 0;distance1 = 0;distance2 = 0;distance3 = 0;distance4 = 0;distance5 = 0;distance6 = 0;distance7 = 0;distance8 = 0;distance9 = 0;
for a=1:50
    for b=3:12
         distance0 = distance0 + (featureVector(a,b)-feature0(a,b))^2;
         distance1 = distance1 + (featureVector(a,b)-feature1(a,b))^2;
         distance2 = distance2 + (featureVector(a,b)-feature2(a,b))^2;
         distance3 = distance3 + (featureVector(a,b)-feature3(a,b))^2;
         distance4 = distance4 + (featureVector(a,b)-feature4(a,b))^2;
         distance5 = distance5 + (featureVector(a,b)-feature5(a,b))^2;
         distance6 = distance6 + (featureVector(a,b)-feature6(a,b))^2;
         distance7 = distance7 + (featureVector(a,b)-feature7(a,b))^2;
         distance8 = distance8 + (featureVector(a,b)-feature8(a,b))^2;
         distance9 = distance9 + (featureVector(a,b)-feature9(a,b))^2;
    end
   distance0 = distance0 + sqrt(distance0);
   distance1 = distance1 + sqrt(distance1);
   distance2 = distance2 + sqrt(distance2);
   distance3 = distance3 + sqrt(distance3);
   distance4 = distance4 + sqrt(distance4);
   distance5 = distance5 + sqrt(distance5);
   distance6 = distance6 + sqrt(distance6);
   distance7 = distance7 + sqrt(distance7);
   distance8 = distance8 + sqrt(distance8);
   distance9 = distance9 + sqrt(distance9);
end
dist = [distance0 distance1 distance2 distance3 distance4 distance5 distance6 distance7 distance8 distance9];
outputDigit = find(dist == min(dist)) - 1;
end