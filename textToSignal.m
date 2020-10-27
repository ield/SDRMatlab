%Engineer: ield
%Company: ALTER-UPM

function [signal] = textToSignal(text)
%% General Information
% Converts an input text into an array.
% The texts is a signal gather with a DIGILENT Oscilloscope.
% inicio is the point in which the file reading should start: the lines
%   before should not be considered.
% pulse is the idel points each pulse has. The last pulse points are not
%   considered since M+1 cycles are taken in the oscilloscope and only M are
%   needed (ideally, exceed adjusts this value)
% exceed is the value of points that should not be considered either. It is
%   a consequence of the difference between the real frequency of the FPGA
%   and the desired one. A negative value of exceed implies that more
%   points should be taken. This is not problem since pulse points are
%   discarded

INICIO = 58;
% exceed = m*pulse-round(m*pulse*fFPGA/fReal);

f = fopen(text);
data = textscan(f,'%s');
fclose(f);
    signal = str2double(data{1}(INICIO:end));
end

