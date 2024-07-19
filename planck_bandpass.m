%planck bandpass filter

% simulation parameters
srate = 1234; % in Hz
time  = 0:1/srate:5;
n = length(time)
interp= 10
amp=5  %std dev of noise
ampl   = interp1(rand(interp,1)*30,linspace(1,interp,n));
noise  = amp * randn(size(time));
signal = ampl + noise;

%mean center the signal
signal= signal - mean(signal)

lowcut = 1;   % Low cutoff frequency in Hz
highcut = 10; % High cutoff frequency in Hz

%bandpass filter 
bpFilt = designfilt('bandpassiir', 'FilterOrder', 8, ...
             'HalfPowerFrequency1', lowcut, 'HalfPowerFrequency2', highcut, ...
    'SampleRate', srate);
%iir vs fir infinite vs finite impulse response 
%apply the bandpass filter
filtered_signal = filter(bpFilt, signal);
%fft for original signal 
fft_org=fft(signal);
fft_freqs= (0: n-1)*(srate/n);
fft_org_mag=abs(fft_org)/n; 
%fft filter
fft_filt=fft(filtered_signal);
fft_filtmag=abs(fft_filt)/n;

% Plot original and filtered signals for comparison
figure;
subplot(2,2,1);
plot(time, signal);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,2,2);
plot(time, filtered_signal);
title('Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% FFT of original signal
subplot(2,2,3);
plot(fft_freqs(1:floor(n/2)), fft_org_mag(1:floor(n/2)));
title('FFT of Original Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% FFT of filtered signal
subplot(2,2,4);
plot(fft_freqs(1:floor(n/2)), fft_filtmag(1:floor(n/2)));
title('FFT of Filtered Signal');
xlim([lowcut highcut]);
xlabel('Frequency (Hz)');
ylabel('Magnitude');

