% It is creted a structure signal with channel, bw, sr and data
clear;
path = 'SDR_Medidas/BW&SR/';

%% Step 1. It is loaded all the data taken intro a structure
bw = [5 10 20];
ch = [1 2];
fs = 8e9;

dataStruc = [];
for ii = 1:length(ch)
    for jj = 1:length(bw)
        filename = ['ch' num2str(ch(ii)) 'bw' num2str(bw(jj)) '*'];
        allSig = dir([path, filename]);
        dataStruc = structureSignals(ch(ii), bw(jj), path, allSig, fs, dataStruc);
        fprintf('Loaded ch %i, bw %i\n', ch(ii), bw(jj));
    end
end

%% It is plotted all the data toghether in frequency domain

figure('Color',[1 1 1]);

x0=500;
y0=500;
width=1200;
height=300;
set(gcf,'position',[x0,y0,width,height])

% Makes  asubplot for every channel (2)
Legend = [];
for ii = 1:length(ch)
    subplot(1, length(ch), ii)
    xlabel('Frequency (GHz)');
    ylabel('X_1(f)');
    xlim([99 101]);
    Legend(ii).leg = cell(length(dataStruc)/length(ch), 1);
    hold on;
end

legendPos = ones(1, length(ch));  % Positio of legends
for ii = 1:length(dataStruc)
    for jj = 1:length(ch)
        if(dataStruc(ii).ch == ch(jj))
            subplot(1, length(ch), jj);
            plot(dataStruc(ii).fAxis/1e6, dataStruc(ii).dataFreq);
            leg = Legend(jj).leg;
            leg{legendPos(jj)}=strcat('BW = ', num2str(dataStruc(ii).bw), 'MHz, SR = ', num2str(dataStruc(ii).sr), 'Msps.');
            Legend(jj).leg = leg;
            legendPos(jj) = legendPos(jj) + 1;
        end
    end
end

% Place legend
for ii = 1:length(ch)
    subplot(1, length(ch), ii);
    legend(Legend(ii).leg, 'location', 'northeast');
end



