% This can be done as a optimization problem as well.

R = 50;     % Load resistance of oscilloscope and placed in parallel
N = 1:4;    % Number of load resistances placed in paralel
Rpar = ones(1, length(N));  % Result resistance seen (zin)
Rpar = (Rpar/R.*N).^-1;

%% Load measurements and calculate
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

%% Plot and save the result
savePath = '../Informes/Informe1/Images/';
figure('Color',[1 1 1]);

x0=500;
y0=500;
width=300;
height=150;
set(gcf,'position',[x0,y0,width,height])
plot(rout, 'k');
xlabel('Measurements');
ylabel('Z_{out} (\Omega)');
saveas(gca, [savePath, 'rmatch'],'epsc');

mean(rout)
