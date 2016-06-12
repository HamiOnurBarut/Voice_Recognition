
clc;clear all; close all; delete(instrfind);
%% SERIAL PORT COMMUNICATION (RS-232 Interface)

%% MODIFY BELOW PARAMETERS-------------------------------------------------------
s = serial('COM7'); % Modify COM6 according to your COM port
nofElem=4096; %Number of receive samples (MODIFY here FOR number of samples you have)
decdata=zeros(1,nofElem); % integer data
signedData=1; % Received data signed (1) or unsigned (0)

%% FIXED PARAMETERS (DO NOT MODIFY)
set(s,'BaudRate',115200); %DO NOT MODIFY (FIXED BAUDRATE)
set(s,'InputBufferSize',2^16);  % 2^16 byte (you don't have to modify)
set(s,'OutputBufferSize',2^16); % 2^16 byte (you don't have to modify)
get(s) % Properties of your serial port
k=1;
%% READ FROM SERIAL PORT
fopen(s);
if signedData  % Signed DATA
   while (1) 
        decdata(k) = twos2dec(dec2bin(fread(s,1),8));
        if k==nofElem 
            break;
        end
   k=k+1;
   end
else
   while (1) % Unsigned data
        decdata(k) = fread(s,1);
        if k==nofElem 
            break;
        end
   k=k+1;
   end
end
fclose(s);
plot(decdata)
