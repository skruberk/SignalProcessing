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

% normalized time vector in ms
k = 10;
gtime = 1000*(-k:k)/srate;

% Define Full Width at Half Maximum for tuning the amount of smoothing
fwhm = 10; 
% Calculate standard deviation/sigma of the Gaussian kernel
sigma = fwhm / (2 * sqrt(2 * log(2)));
% create Gaussian window
gauswin = exp( -(4*log(2)*gtime.^2) / fwhm^2 );

% compute empirical FWHM
pstPeakHalf = k+dsearchn(gauswin(k+1:end)',.5);
prePeakHalf = dsearchn(gauswin(1:k)',.5);
empFWHM = gtime(pstPeakHalf) - gtime(prePeakHalf);



% show the Gaussian
figure(1), clf, hold on
plot(gtime,gauswin,'ko-','markerfacecolor','w','linew',2)
plot(gtime([prePeakHalf pstPeakHalf]),gauswin([prePeakHalf pstPeakHalf]),'m','linew',3)

% then normalize Gaussian to unit energy
gauswin = gauswin / sum(gauswin);
title([ 'Gaussian kernel with requeted FWHM ' num2str(fwhm) ' ms (' num2str(empFWHM) ' ms achieved)' ])
xlabel('Time (ms)'), ylabel('Gain')

%% implement the filter

% initialize filtered signal vector
filtsigG = signal;

% implement the running mean filter
for i=k+1:n-k-1
    % each point is the weighted average of k surrounding points
    filtsigG(i) = sum( signal(i-k:i+k).*gauswin );
end

% plot
figure(2), clf, hold on
plot(time,signal,'r')
plot(time,filtsigG,'k','linew',3)

xlabel('Time (s)'), ylabel('amp. (a.u.)')
legend({'Original signal';'Gaussian-filtered'})
title('Gaussian smoothing filter')

zoom on


