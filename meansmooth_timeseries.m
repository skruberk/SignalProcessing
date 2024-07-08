%running mean filter to mean-smooth time series data 

srate = 1000; % Hz
time  = 0:1/srate:5;
n     = length(time);
p     = 15;
ampl   = interp1(rand(p,1)*30,linspace(1,p,n));
% noise level, measured in standard deviations
noiseamp = 5; 
noise  = noiseamp * randn(size(time));
signal = ampl + noise;


% initialize filtered signal vector
filtsig = zeros(size(signal));

winSize = 100; % Number of points for the moving average

%running mean filter
for i=winSize+1:n-winSize-1
    % each point is the average of k surrounding points
    filtsig(i) = mean(signal(i-winSize:i+winSize));
end

% compute window size in ms
actwinSize = 1000*(winSize*2+1) / srate;

% plot the noisy and filtered signals
figure(1), clf, hold on
plot(time,signal, time,filtsig, 'linew',2)

% draw a patch to indicate the window size
tidx = dsearchn(time',1); %transpose and then index
ylim = get(gca,'ylim');
patch(time([ tidx-winSize tidx-winSize tidx+winSize tidx+winSize ]),ylim([ 1 2 2 1 ]),'k','facealpha',.25,'linestyle','none')
plot(time([tidx tidx]),ylim,'k--')

xlabel('Time (sec.)'), ylabel('Amplitude')
title([ 'Running-mean filter with a k=' num2str(round(actwinSize)) '-ms filter' ])
legend({'Signal';'Filtered';'Window';'Window Center'})

zoom on
