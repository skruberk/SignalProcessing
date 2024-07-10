%signal filtering with FIR, FIRLS
clc
close all

srate   = 1048; % hz
t = 0:1/srate:1-1/srate;   
nyquist = srate/2;
frange  = [20 40];
shape   = [ 0 0 1 1 0 0 ];

%FIR filter
order   = round( 5*srate/frange(1) );          % Filter order
transw  = .35;    % transition width
freq    = [ 0 frange(1)-frange(1)*transw frange frange(2)+frange(2)*transw nyquist ] / nyquist;
filtkern = firls(order,freq,shape); % filter kernel

% apply FIR to signal
signal= sin(2*pi*10*t) + 0.5*randn(size(t));

filtered_signal = filter(filtkern, 1, signal);

%power spectrum of the filter kernel
filtpow = abs(fft(filtkern)).^2;
wid=linspace(0,srate/2,floor(length(filtkern)/2)+1);
filtpow = filtpow(1:length(wid));

% Plot the filter kernel and its power spectrum
figure;
subplot(2, 1, 1);
plot(filtkern);
title('Filter Kernel');

subplot(2, 1, 2);
plot(linspace(0, nyquist, length(filtpow)), filtpow);
title('Power Spectrum of the Filter Kernel');
xlabel('Frequency (Hz)');
ylabel('Power');

% Plot the original and filtered signals
figure;
subplot(2, 1, 1);
plot(t, signal);
title('Original Noisy Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t, filtered_signal);
title('Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');
