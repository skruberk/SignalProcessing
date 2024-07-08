%removes an artifact via least squares template matching 
close all 
clear variables;
clc;

art=5;
t = 0:0.01:10;
signal = sin(2*pi*0.1*t) + 0.5*t; % signal with linear trend
artifact = exp(-((t-art)/0.05).^2); % gaussian artifact
asignal = signal + artifact;
% initialize residual data
resdat = zeros(size(asignal));
npnts=length(t);
    
% Initialize residual data
cleaned_signal = asignal;
% Detect peaks in the signal
[peak, locs] = findpeaks(asignal, 'MinPeakHeight', 0.5);

% Loop over detected peaks
for i = 1:length(peak)
    % Define the artifact template based on detected peak location
    art_loc = locs(i);
    template = exp(-((t-t(art_loc))/0.05).^2); % Adjust width as needed
    
    % Least squares fit
    A = [template(:), ones(length(t), 1)];
    coeff = A \ cleaned_signal(:);
    fitted_art = coeff(1) * template + coeff(2);
    
    % Remove the fitted artifact from the signal
    cleaned_signal = cleaned_signal - fitted_art;
end

% Plot the original signal, the artifact, and the cleaned signal
figure;
subplot(3, 1, 1);
plot(t, asignal);
title('Signal with Artifact');
subplot(3, 1, 2);
plot(t, fitted_art);
title('Cleaned Signal (Artifact Removed)');
subplot(3, 1, 3);
plot(t, cleaned_signal);
title('Cleaned Signal');