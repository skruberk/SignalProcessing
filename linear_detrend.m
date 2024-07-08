%linear detrending
clear all
%signal
t = 0:0.01:10;
signal = sin(2*pi*t) + 0.5*t; %2*pi is the angular frequency for a period of 1 when t is in seconds
%ymin = min([min(signal), min(dsignal)]);
ymax = max(signal)+1;
ymin = min(signal)-1;

dsignal=detrend(signal);
clf
figure;
subplot(2, 1, 1);
plot(t, signal);
title('Original Signal');
ylim([ymin, ymax]);

subplot(2, 1, 2);
plot(t, dsignal);
title('Detrended Signal');
ylim([ymin ymax]);

