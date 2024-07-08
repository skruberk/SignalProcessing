%median filter 
srate = 1000;       % sampling rate in Hz
duration= 5;       % duration of the signal in seconds
time = 0:1/srate:duration-1/srate; % time vector
t=length(time); %num points in signal
%sine wave
signal = cumsum(randn(t,1));
proportion = 0.05;   % 20% of the points will be replaced with noise

%signal to denoise
noise_level = 2;    % Noise level (standard deviation)
numPoints = round(proportion * length(time));
noisy_values = noise_level * randn(1, numPoints);
replace_indices = randperm(length(time), numPoints);
dsignal = signal;
dsignal(replace_indices) = noisy_values;


% visual-picked threshold
threshold = 50;

% find data values above the threshold
suprathresh = find(dsignal>threshold );

% initialize filtered signal
filtsig = dsignal;

% loop through suprathreshold points and set to median of k
k = 50; % actual window is k*2+1
for ti=1:length(dsignal)
    
    % find lower and upper bounds
    lowbnd = max(1, ti - k);
    uppbnd = min(length(dsignal), ti + k);
    
    % compute median of surrounding points
    filtsig(ti) = median(dsignal(lowbnd:uppbnd));
end

% plot
figure(1), clf
plot(time, signal, 'b', 'LineWidth', 1) % Original signal in blue
hold on
plot(time, dsignal, 'r', 'LineWidth', 1) % Noisy signal in red
plot(time, filtsig, 'g', 'LineWidth', 2) % Filtered signal in green
zoom on
xlabel('Time (seconds)')
ylabel('Amplitude')
legend({'Org Signal', 'Noisy Signal','Filtered Signal'})
title('Median Filtering of Noisy Signal')

