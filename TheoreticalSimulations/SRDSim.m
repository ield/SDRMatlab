%% Engineer: ield
% Company: ALTER-UPM

%% 1. Initialization
clear;
% SRD Parameters
transTime = 27e-12;

% Import file
path = 'SDR_Medidas/VisualStudio/';
signalFile1 = dir([path, 'ch1_100000.txt']);
file1 = [path, signalFile1.name];
signal = textToSignal(file1);

%% 2. Adapt the signal
L = length(signal1);        % Length of the signal
fs = 8e9;                   % Sampling rate of the oscilloscope. Real fs * m
t = (0:L-1)/fs;             % time axis
f = (-L/2:(L-1)/2)*(fs/L);  % frequency axis

%Creating the signal theoretically
f1 = 100e6;                 % 100 MHz
% signal1 = cos(2*pi*f1*t);

[~,locs] = findpeaks(signal1);  % The peaks are in the maximum of the srd

amp = 18;             % Amplification of the srd
outputSRD = zeros(1, L);
% Determining the duration of the peaks
timeDiff = t(2);
pulsesUp = ceil(transTime / timeDiff);        % The time the number of samples the pulse is up

for ii = 0:pulsesUp-1
    outputSRD(locs+ii) = signal1(locs)*amp;    % In the peaks, the output is high.
end

OUTPUTsrd = convertToF(outputSRD);      % Fourier transform of output
SIGNAL1 = convertToF(signal1');      % Fourier transform of input (transpose if signal from oscilloscope=

%% Plot in time domain
savePath = '../Informes/Informe1/Images/';
figure('Color',[1 1 1]);

x0=500;
y0=500;
width=500;
height=300;
set(gcf,'position',[x0,y0,width,height])

subplot(2, 1, 1)
plot(t*1e6, signal1, 'k');
xlabel('Time (\mus)');
ylabel('x_0(t)');
xlim([0 0.1]);

subplot(2, 1, 2)
plot(t*1e6, outputSRD, 'k');
xlabel('Time (\mus)');
ylabel('sdr_{out}(t)');
xlim([0 0.1]);

saveas(gca, [savePath, 'srd_t'],'svg');

%% Plot in frequency domain

savePath = '../Informes/Informe1/Images/';
figure('Color',[1 1 1]);

x0=500;
y0=500;
width=500;
height=300;
set(gcf,'position',[x0,y0,width,height])

subplot(2, 1, 1)
plot(f/1e9, SIGNAL1, 'k');
xlabel('Frequency (GHz)');
ylabel('x_0(t)');
% xlim([0 0.1]);

subplot(2, 1, 2)
plot(f/1e9, OUTPUTsrd, 'k');
xlabel('Frequency (GHz)');
ylabel('SDR_{out}(t)');
% xlim([0 0.1]);

saveas(gca, [savePath, 'srd_f'],'svg');

