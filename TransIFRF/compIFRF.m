% It is creted a structure signal with channel, bw, sr and data
clear;
path = 'SDR_Medidas/IFModulation/';
%% Step 1. It is loaded all the data taken intro a structure
fi = [1 5 20];
ch = [1 2];
bw = [10 20 60];
fs = 8e9;

dataStruc = [];
for ii = 1:length(ch)
    for jj = 1:length(fi)
        filename = ['ch' num2str(ch(ii)) 'fi' num2str(fi(jj)) '.txt'];
        allSig = dir([path, filename]);
        dataStruc = structureSignalsIFRF(ch(ii), fi(jj), path, allSig, fs, dataStruc);
        fprintf('Loaded ch %i, bw %i\n', ch(ii), fi(jj));
    end
end

%% It is plotted all the data toghether in frequency domain

figure('Color',[1 1 1]);

x0=100;
y0=0;
width=1200;
height=1200;
set(gcf,'position',[x0,y0,width,height])

% Makes  a subplot for every channel if and every channel
for ii = 1:length(ch)   %for every channel
    for jj = 1:length(fi)   % for every fi
        pos = (jj-1)*length(ch) + ii;
        subplot(length(fi), length(ch), pos);
        xlabel('Frequency (MHz)');
        ylabel(['X_' num2str(ch(ii)-1) '(f)']);
        xlim([70 130]);
%         Legend(ii, jj).leg = cell(length(dataStruc)/length(ch), 1);
        hold on;
    end
end

for ii = 1:length(dataStruc)
    ch_now = dataStruc(ii).ch;
    fi_now = dataStruc(ii).fi;
    ch_now_index = find(ch == ch_now);
    fi_now_index = find(fi == fi_now);
    
    subplot(length(fi), length(ch), (fi_now_index - 1)*length(ch) + ch_now_index);
    
    plot(dataStruc(ii).fAxis/1e6, dataStruc(ii).dataFreq);
    
    title(['Ch = ' num2str(ch_now) '; IF = ' num2str(fi_now) 'MHz']);
end


savePath = '../Informes/Informe1/Images/';
saveas(gca, [savePath, 'compifrf'],'epsc');


