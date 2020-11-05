%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Engineer: ield
% Company: ALTER-UPM
% First script done to connect and easily interact with Lime SDR. It
% computes the received signal's fft in real time

clear;
tic;
dev = limeSDR();                % Generates connection with LimeSDR

% Initialize some parameters
f0 = 78.0e6;
dev.rx0.frequency  = f0;
fs = 5e6;
dev.rx0.samplerate = fs;
dev.rx0.bandwidth = 2e6;
dev.rx0.antenna = 1;

recTime = 5;    % Receiving time (s)

% Enable stream parameters
dev.rx0.enable;

% Start the module
dev.start();

 
% Receive 10000 samples
fprintf('Time for loading: %g\n', toc); loadtime = toc;

samples = dev.receive(recTime*fs,0);

trec = toc - loadtime;
fprintf('Time receiving %g\n', trec);
% Obtain frequency axis (seen in Mathworks)
% https://es.mathworks.com/help/matlab/math/basic-spectral-analysis.html)

L = length(samples);
f = (-L/2:(L-1)/2)*(fs/L)+f0;

spectrum = 10*log10(abs(fft(samples)));
plot(f, spectrum);
xlim([f(1), f(end)]);
%% Try to receive continuously
figure;
axis([f(1) f(end) 0 30])
hold on;

for i = 1:10000
    
    samples = dev.receive(10000,0);

    spectrum = abs(fft(samples));
    
    h = plot(f, spectrum, 'k'); drawnow;
    delete(h);
    
    
end

%% Try to send bpsk signal
% clear;
% Configure constelation
% dev.stop();

bit1 = 1+i;
bit0 = -1-i;

const = 4e-4*[bit0 bit1];

% Configure message
seqLength = 10000;
txSeq = zeros(1, seqLength);

for(ii = 1:seqLength)
    index = ceil(rand()+0.5); % Selects randomly a bpsk sequence
    txSeq(ii) = const(index);    
end

% Configure tx radio parameters and transmit sequence
f0 = 917.45e6;
fs = 5e6;

dev.tx0.frequency  = f0;
dev.tx0.samplerate = fs;
dev.tx0.bandwidth = 3e6;
dev.tx0.antenna = 1;

dev.tx0.enable;
dev.start();

dev.transmit(txSeq, 0, 1000);
% Plot transmitted sequence
% L = length(txSeq);
% f = (-L/2:(L-1)/2)*(fs/L)+f0;
% 
% spectrum = abs(fft(txSeq));
% plot(f, spectrum);
% xlim([f(1), f(end)]);

%% Try to send and receive 

dev.transmit(txSeq, 0, 0);
% dev.rx0.enable;
samples = dev.receive(100000,0);
plot(samples, 'or');

