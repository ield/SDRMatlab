R = 50;     % Load resistance of oscilloscope and placed in parallel
N = 1:4;    % Number of load resistances placed in paralel
Rpar = ones(1, length(N));  % Result resistance seen (zin)
Rpar = (Rpar/R.*N).^-1;

% Load measurements
filepath = 'SDR_Medidas/CalculateZout/';
signalFile = dir([filepath, '50ohm_*'])';   % All the signals with different Rin
vRms = ones(1, 4);
for ii = 1:length(N)
    file = [filepath, signalFile(ii).name];
    signal = textToSignal(file); % It is checked that the signal is saved correctly
    vRms(ii) = sqrt(sum(signal.^2)/length(signal));    
end
  
rout = [];
for ii = 1:length(N)
    for jj = ii+1:length(N)
        rNew = Rpar(ii)/vRms(ii)*(Rpar(ii)-Rpar(jj))/(Rpar(ii)/vRms(ii)-Rpar(jj)/vRms(jj))-Rpar(ii);
        rout = [rout rNew];
    end
end

% plot(rout);
mean(rout)
