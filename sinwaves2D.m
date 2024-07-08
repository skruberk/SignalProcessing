%2d sinwaves
%%% gabor patch
width = 20;   % width of gaussian
sinphs  = pi/4; % sine phase

lims = [-91 91]; %limits for the grid
[x,y] = ndgrid(lims(1):lims(2),lims(1):lims(2)); %create two 2d grids
xp = x*cos(sinphs) + y*sin(sinphs); %rotate coords
yp = y*cos(sinphs) - x*sin(sinphs);
gaus2d = exp(-(xp.^2 + yp.^2) ./ (2*width^2));
sine2d = sin( 2*pi*.02*xp );
img = sine2d .* gaus2d;


%%% white noise
img = randn(size(img));
% 
% 
% %%% portrait
% lenna = imread('Lenna.png');
% img   = double(mean(lenna,3));
% imgL  = img;
% 
% 
% %%% low-pass filtered Lenna
% width = .1;   % width of gaussian (normalized Z units)
% [x,y] = ndgrid(zscore(1:size(imgL,1)),zscore(1:size(imgL,2)));
% gaus2d= exp(-(x.^2 + y.^2) ./ (2*width^2)); % add 1- at beginning to invert filter
% imgX  = fftshift(fft2(imgL));
% img   = real(ifft2(fftshift(imgX.*gaus2d)));
% 
% 
% %%% high-pass filtered Lenna
% width = .3;   % width of gaussian (normalized Z units)
% [x,y] = ndgrid(zscore(1:size(imgL,1)),zscore(1:size(imgL,2)));
% gaus2d= 1-(exp(-(x.^2 + y.^2) ./ (2*width^2))); % add 1- at beginning to invert filter
% imgX  = fftshift(fft2(imgL));
% img   = real(ifft2(fftshift(imgX.*gaus2d)));
% 
% 
% 
% %%% phase-scrambled Lenna
% imgX  = fftshift(fft2(imgL));
% powr2 = abs(imgX);
% phas2 = angle(imgX);
% img   = real(ifft2(fftshift( powr2.*exp(1i*reshape(phas2(randperm(numel(phas2))),size(phas2))) )));





% power and phase spectra
imgX  = fftshift(fft2(img));
powr2 = log(abs(imgX));
phas2 = angle(imgX);

figure(2), clf
subplot(121)
imagesc(img), axis square
title('Space domain')

subplot(222)
imagesc(powr2), axis square
title('Amplitude spectrum')

subplot(224)
imagesc(phas2), axis square
title('Phase spectrum')