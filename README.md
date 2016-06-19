## Speech Recognition Project

The basic purpose of the system is to recognize a spoken digit. 
For this implementation, there are mainly 3 different implementation levels. 
First one is the microphone amplifier to obtain and sample speech signal. 
The latter one is the FPGA side of the system and the last one concerns Matlab implementation. 
In the FPGA side, sampling, windowing, transforming and filtering of the speech signal are performed. 
Remaining parts of the system is implemented in Matlab side. 
Log compression, discrete cosine transform and the decision rule is implemented in the Matlab side.
