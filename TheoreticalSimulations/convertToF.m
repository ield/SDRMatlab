function [SIGNAL] = convertToF(signal)
signal_f = 10*log10(abs(fft(signal)));
signal_f1 = signal_f(1:round(length(signal_f)/2));
signal_f2 = signal_f(round(length(signal_f)/2)+1:end);
SIGNAL = [signal_f2 signal_f1];

end

