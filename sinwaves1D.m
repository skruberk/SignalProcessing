%sin waves
srate = 1000;
time  = 0:1/srate:2-1/srate;
n     = length(time);
hz    = linspace(0,srate,n);

%%% pure sine wave
%signal = sin(2*pi*5*time);

 %%% multispectral wave
% signal = 2*sin(2*pi*5*time) + 3*sin(2*pi*7*time) + 6*sin(2*pi*14*time);
% 
% %%% white noise
% signal = randn(size(time));
% 
% %%% Brownian noise (aka random walk)
% signal = cumsum(randn(size(time)));
% 
% %%% 1/f noise
 %ps   = exp(1i*2*pi*rand(1,n/2)) .* .1+exp(-(1:n/2)/50);
 %ps   = [ps ps(:,end:-1:1)]; %make symmetric by concatenating w flipped version for iFT
 %signal = real(ifft(ps)) * n; %time domain signal obtained by taking inverse FFT of ps
% 
% %%% square wave
%signal = zeros(size(time));
%signal(sin(2*pi*3*time)>.9) = 1; %finds intervals where sin wave is near pos peak and assigns 1 at those indices
% 
% %%% AM (amplitude modulation)
 %signal = 10*interp1(rand(1,10),linspace(1,10,n),'spline') .* sin(2*pi*40*time);
% freq of 40Hz oscillating btw -1,1 over the time vector, interpl->spline
% interpolates 10 rand vals to the n points to create a smooth continuous
% function

% %%% FM (frequency modulation)
freqmod = 20*interp1(rand(1,10),linspace(1,10,n));
signal  = sin( 2*pi * ((10*time + cumsum(freqmod))/srate) );
% 
% %%% filtered noise
% signal = randn(size(time));
% s  = 5*(2*pi-1)/(4*pi);       % normalized width
% fx = exp(-.5*((hz-10)/s).^2); % gaussian
% fx = fx./max(fx);             % gain-normalize
% signal = 20*real( ifft( fft(signal).*fx) );


% compute amplitude spectrum
ampl = 2*abs(fft(signal)/n);

% plot in time domain
figure(1), clf
subplot(211) % 2x1 grid, first subplot active
plot(time,signal,'k','linew',2)
xlabel('Time (sec.)'), ylabel('Amplitude')
title('Time domain')
set(gca,'xlim',[time(1)+.05 time(end)-.05],'ylim',[min(signal)*1.1 max(signal)*1.1])

% plot in frequency domain
subplot(212) %subplot in 2x1 grid, 2nd subplot active
stem(hz,ampl,'k-s','linew',2,'markerfacecolor','k')
xlabel('Frequency (Hz)'), ylabel('Amplitude')
title('Frequency domain')
set(gca,'xlim',[0 100])
