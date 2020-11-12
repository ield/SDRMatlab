% Download drivers and api https://www.sdrplay.com/windl4.php

%   SDRPLAY spectrum analyzer example.
%
%   This is a quick demonstration on how to use SDRplay in Matlab .m editor
%   using the class sdrplay. It creates a new SDRplay object under the name
%   MySDRplay, sets GainReduction, SampleRate, Frequency, Bandwidth, IF
%   type, LNA state, and receiving Port. It the initializes the stream, and
%   then creates the Spectrum Analyzer object using Matlab DSP toobox. MySDRplay 
%   object dumps data in to the buildin function PacketData, every .25 s which 
%   The spectral analyzer uses for FFT and the Waterfall. Finally it stops
%   the stream and close the device safely.
%
%   For any questions or assistance you can find me at, 
%   vasathanasios@gmail.com.
%
%   Vasileiadis Athanasios, 08 06 2018
%
clear all; close all; clc;
%% Load SDRplay Default
MySDRplay = sdrplay;
sr = 2.4;
f0 = 78;
%% Default values, example.
MySDRplay.GainReduction = 50;   % Set SDRplay gain reduction, based on specification table.
MySDRplay.SampleRateMHz = sr;    % Set SDRplay sample rate, 2 - 10 MHz.
MySDRplay.FrequencyMHz = f0;   % Set SDRplay tuner frequency, see specification for details.
MySDRplay.BandwidthMHz = 600;   % Set SDRplay BandwidthMHz, see table for details.
MySDRplay.IFtype = 0;           % Set SDRplay IF to be used, see specification for details.
MySDRplay.LNAstate = 0;         % Set SDRplay LNA state based on Grmode, see specification for details.
MySDRplay.Port = 'A';           % SDRplay port selection, A (default) or B.
%% Initiallize Stream
MySDRplay.Stream;
tic;
%% DSP Spectrum Analyzer
hSpectrum = dsp.SpectrumAnalyzer(...
    'Name',             'Passband Spectrum',...
    'Title',            'Passband Spectrum', ...
    'Method',           'Welch', ...
    'ViewType',         'Spectrum and spectrogram',...
    'FrequencySpan',    'Full', ...
    'SpectrumUnits',    'dBm', ...
    'SampleRate',       MySDRplay.SampleRateMHz*1e6, ...
    'FrequencyOffset',  MySDRplay.FrequencyMHz*1e6, ...
    'YLabel',           'Magnitude, dBFS');
%% Test to set the observation time
evaluationTime = 30.1;     % Time the signal lasts (s)
nSamples = 1e6;         % Number of samples taken: this does not change
numEvaluations = ceil(MySDRplay.SampleRateMHz*1e6/nSamples*evaluationTime); % Number of times the data must be captured
allData = zeros(1, MySDRplay.SampleRateMHz*1e6/nSamples*evaluationTime*nSamples);   % All data captured is stored in here. The length is set by the number of evaluations but the last one might be shorter
% allData = zeros(1, numEvaluations);
evaluationInterval = nSamples/(MySDRplay.SampleRateMHz*1e6);  % Time the sdr is capturing until it flls the buffer
lengthLastEvaluation = mod(length(allData), nSamples); % The final interval has a smaller length, which does not fit in a normal interval
lastEvaluationInterval = lengthLastEvaluation/(MySDRplay.SampleRateMHz*1e6);    

if MySDRplay.StreamInit
    for ii = 1:numEvaluations-1 % In all the evaluations it is loaded all the data captured. The last evaluation might be shorter so the data is trated separatedly
        tic;
        fprintf('Start capturing %i\n', ii);
        while toc<evaluationInterval
        end
        allData((ii-1)*nSamples+1:ii*nSamples) = MySDRplay.PacketData;
        
    end
    % Last evaluation
    tic;
    while toc<lastEvaluationInterval
    end
    allData((numEvaluations-1)*nSamples+1:end) = MySDRplay.PacketData(end-(lengthLastEvaluation-1):end);
else
    warning(message('SDR:sysobjdemos:MainLoop'))
end

%% Stop stream, and exit the device
MySDRplay.StopStream;
MySDRplay.Close;
delete(MySDRplay);

%% Plot the samples
L = length(allData);
f = (-L/2:(L-1)/2)*(sr*1e6/L)+f0*1e6;

spectrum = convertToF(allData);
figure;

plot(f, spectrum);
xlim([f(1), f(end)]);
