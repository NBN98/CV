I1 = imread('left.jpg');  %left picture from camera
I2 = imread('right.jpg');  %right picture from camera 

A = stereoAnaglyph(I1,I2);
figure
imshow(A)
title('Red-Cyan composite view of the rectified stereo pair image')

J1 = rgb2gray(I1);
J2 = rgb2gray(I2);

disparityRange = [0 48];

disparityMap = disparityBM(J1,J2,'DisparityRange',disparityRange,'UniquenessThreshold',20); %using block matching
%disparityMap = disparitySGM(J1,J2,'DisparityRange',disparityRange,'UniquenessThreshold',20);

figure
imshow(disparityMap,disparityRange)
title('Disparity Map')
colormap jet
colorbar