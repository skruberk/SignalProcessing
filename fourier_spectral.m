%fourier for spectral analysis

% simulation parameters
srate = 1234; % in Hz
npnts = srate*2; % 2 seconds
time  = (0:npnts-1)/srate;

% frequencies to include
freq  = [ 2 18 48 ];

signal = zeros(size(time));
% loop over frequencies to create signal
for fi=1:length(freq)
    signal = signal + fi*sin(2*pi*freq(fi)*time);
end

% add some noise
signal = signal + randn(size(signal));

% amplitude spectrum via Fourier transform
signalF = fft(signal);
signalAmp = 2*abs(signalF)/npnts;

% vector of frequencies in Hz
hz = linspace(0,srate/2,floor(npnts/2)+1);


figure(1), clf
subplot(211)

plot(time,signal)
xlabel('Time (s)'), ylabel('Amplitude')
title('Time domain')


subplot(212)
stem(hz,signalAmp(1:length(hz)),'ks','linew',2,'markersize',10)
set(gca,'xlim',[0 max(freq)*3])
xlabel('Frequency (Hz)'), ylabel('Amplitude')
title('Frequency domain')


subplot(211), hold on
plot(time,ifft(signalF),'ro')
legend({'Original';'IFFT reconstructed'})