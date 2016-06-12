function [ x ] = recordVoice( fs, duration )
%recordVoice : returns samples of speech
%   fs : sampling frequency
%   duration : duration of record
recObject = audiorecorder(fs,8,1);
disp('GET READY');
disp('start speaking');
recordblocking(recObject, duration);
disp('end of recording');
play(recObject);
x = getaudiodata(recObject);
end

