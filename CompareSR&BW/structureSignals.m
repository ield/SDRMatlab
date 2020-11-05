function [dataStruc] = structureSignals(ch, bw, path, signals, fs, dataStruc)
% Returns a structure array with all the signals with their bw, ch and data
L = length(dataStruc);
for ii = L+1:L+length(signals)
    dataStruc(ii).ch = ch;
    dataStruc(ii).bw = bw;
    
    % The sr is the number before the .txt
    sr = str2num(signals(ii-L).name(end-5:end-4));
    dataStruc(ii).sr = sr;
    dataStruc(ii).sr
    
    % The data is taken from the file
    file = [path, signals(ii-L).name];
    signal = textToSignal(file);
    dataStruc(ii).dataTime = signal;
    
    Lsig = length(signal);
    t = (0:Lsig-1)/fs;
    dataStruc(ii).timeAxis = t;
    
    f = (-Lsig/2:(Lsig-1)/2)*(fs/Lsig);
    dataStruc(ii).fAxis = f;
    
    X_f = 10*log10(abs(fft(signal)));
    X_f = circshift(X_f, Lsig/2);
    dataStruc(ii).dataFreq = X_f;
end
end

