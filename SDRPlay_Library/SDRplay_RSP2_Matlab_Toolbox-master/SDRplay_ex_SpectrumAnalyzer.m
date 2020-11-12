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
%% Default values, example.
MySDRplay.GainReduction = 50;   % Set SDRplay gain reduction, based on specification table.
MySDRplay.SampleRateMHz = 4;    % Set SDRplay sample rate, 2 - 10 MHz.
MySDRplay.FrequencyMHz = 98;   % Set SDRplay tuner frequency, see specification for details.
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
evaluationTime = 5;     % Time the signal lasts (s)
nSamples = 1e6;         % Number of samples taken: this does not change
numEvaluations = ceil(MySDRplay.SampleRateMHz*1e6/nSamples*evaluationTime); % Number of times the data must be captured
% allData = zeros(1, MySDRplay.SampleRateMHz*1e6/nSamples*evaluationTime*nSamples);
allData = zeros(1, numEvaluations);
evaluationInterval = nSamples/(MySDRplay.SampleRateMHz*1e6);  % Time the sdr is capturing until it flls the buffer

if MySDRplay.StreamInit
    for ii = 1:numEvaluations % In all the evaluations it is loaded all the data captured. TODO: addapt for the last evaluation
        tic;
        fprintf('Start capturing %i\n', ii);
        while toc<evaluationInterval
        end
        allData((ii-1)*nSamples+1:ii*nSamples) = MySDRplay.PacketData;
        
    end
else
    warning(message('SDR:sysobjdemos:MainLoop'))
    end
figure;
plot(real(allData));

%% Stop stream, and exit the device
MySDRplay.StopStream;
MySDRplay.Close;
delete(MySDRplay);


%% Open Spectrum Analyzer and show data
% if MySDRplay.StreamInit
%     for count = 1 : 250
%         data = MySDRplay.PacketData;
%         step(hSpectrum, data);
%     end
% else
%     warning(message('SDR:sysobjdemos:MainLoop'))
% end
% %% Stop stream, and exit the device
% MySDRplay.StopStream;
% MySDRplay.Close;
% delete(MySDRplay);