clear;
path = 'SDR_Medidas/visualStudio/';
signalFile1 = dir([path, 'ch1_1.txt']);
signalFile2 = dir([path, 'ch2_1.txt']);
file1 = [path, signalFile1.name];
file2 = [path, signalFile2.name];
signal1 = textToSignal(file1);
signal2 = textToSignal(file2);

L = length(signal1);
fs = 8e9;
t = (0:L-1)/fs;
f = (-L/2:(L-1)/2)*(fs/L);

X_f1 = 10*log10(abs(fft(signal1)));
X_f1 = circshift(X_f1, L/2);
X_f2 = 10*log10(abs(fft(signal2)));
X_f2 = circshift(X_f2, L/2);

%% Plot in time domain
% savePath = '../Informes/Informe1/Images/';
figure('Color',[1 1 1]);

x0=500;
y0=500;
width=1200;
height=300;
set(gcf,'position',[x0,y0,width,height])

subplot(1, 4, 1)
plot(t*1e6, signal1, 'k');
xlabel('Time (\mus)');
ylabel('x_0(t)');
xlim([0 t(end)*1e6]);

subplot(1, 4, 2)
plot(t*1e6, signal1, 'k');
xlabel('Time (\mus)');
ylabel('x_0(t)');
xlim([2 2.1]);

subplot(1, 4, 3)
plot(t*1e6, signal2, 'k');
xlabel('Time (\mus)');
ylabel('x_1(t)');
xlim([0 t(end)*1e6]);

subplot(1, 4, 4)
plot(t*1e6, signal2, 'k');
xlabel('Time (\mus)');
ylabel('x_1(t)');
xlim([2 2.1]);

% saveas(gca, [savePath, 'cosTime'],'epsc');

%% Plot in f domain

figure('Color',[1 1 1]);

x0=500;
y0=500;
width=1200;
height=300;
set(gcf,'position',[x0,y0,width,height])

subplot(1, 4, 1)
plot(f/1e9, X_f1, 'k');
xlabel('Frequency (GHz)');
ylabel('X_0(f)');
xlim([f(1)/1e9 f(end)/1e9]);

subplot(1, 4, 2)
plot(f/1e6, X_f1, 'k');
xlabel('Frequency (MHz)');
ylabel('X_0(f)');
xlim([99 101]);

subplot(1, 4, 3)
plot(f/1e9, X_f2, 'k');
xlabel('Frequency (GHz)');
ylabel('X_1(f)');
xlim([f(1)/1e9 f(end)/1e9]);

subplot(1, 4, 4)
plot(f/1e6, X_f2, 'k');
xlabel('Frequency (MHz)');
ylabel('X_1(f)');
xlim([99 101]);

% saveas(gca, [savePath, 'cosFreq'],'epsc');
