clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;
faceDetector = vision.CascadeObjectDetector();

% Read a video frame and run the face detector.
%videoReader = VideoReader('tilted_face.avi');


%===============================================================================
% Read in a gray scale demo image.
%path2=C:\Users\noahb\Desktop\Elektrotechnik\Master\1. Semester SS20\Computer Vision\Challenge\ChokePoint\P1E_S1\P1E_S1_C2
%path='C:\Users\noahb\Desktop\Elektrotechnik\Master\1. Semester SS20\Computer Vision\Challenge\ChokePoint\P2L_S3\P2L_S3_C1.2\';
path='C:\Users\noahb\Documents\object_tracking\img\';
path_joint = dir(strcat(path, '*.jpg'));

for counter=1:length(path_joint)
     caption = sprintf(' %d / %d', counter, length(path_joint));
    
    %Loads all the images in the folder
    originalImage = imread(strcat(path, path_joint(counter).name));
    drawnow;
    
    %if counter ==1
        % background Image is always the first image (image without any person)
        backgroundImage = imread(strcat(path, path_joint(1).name));
    %else
        %backgroundImage = imread(strcat(path, path_joint(counter-1).name));
        %backgroundImage = imread(strcat(path, path_joint(counter-1).name));
    %end
    % Display the image.
    subplot(3, 3, 1);
    imshow(backgroundImage, []);
    axis on;
    title('Background Image', 'FontSize', fontSize, 'Interpreter', 'None');
    % Get the dimensions of the image.
    % numberOfColorBands should be = 1.
    [rows, columns, numberOfColorChannels] = size(backgroundImage);
    if numberOfColorChannels > 1
        % It's not really gray scale like we expected - it's color.
        % Convert it to gray scale.
        backgroundImage = rgb2gray(backgroundImage);
    end
    
    
% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Get rid of tool bar and pulldown menus that are along top of figure.
set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'G21 Computer Vision Challenge', 'NumberTitle', 'Off') 


subplot(3, 3, 2);
imshow(originalImage, []);
axis on;
title(strcat('Original Image', caption), 'FontSize', fontSize, 'Interpreter', 'None');

% Get the dimensions of the image.  
% numberOfColorBands should be = 1.
[rows, columns, numberOfColorChannels] = size(originalImage);
if numberOfColorChannels > 1
	% It's not really gray scale like we expected - it's color.
	% Convert it to gray scale.
	grayImage = rgb2gray(originalImage); 
else
	grayImage = originalImage;
end

% Subtract the images
diffImage = abs(double(grayImage) - double(backgroundImage));
% diffImage = ~diffImage;

% Display the image.
subplot(3, 3, 3);
imshow(diffImage, []);
axis on;
title('Difference Image', 'FontSize', fontSize, 'Interpreter', 'None');


% Threshold the image.
% try here different values
binaryImage = diffImage >=10;

% Display the image.
subplot(3, 3, 4);
imshow(binaryImage, []);
title('Binary Image', 'FontSize', fontSize, 'Interpreter', 'None');

% Take largest blob
binaryImage = bwareafilt(binaryImage, 1);

% Fill holes. %45
se = strel('disk', 45, 0);

mask = imfill(binaryImage, 'holes');
mask = imclose(mask, se);
% % Get convex hull
% binaryImage = bwconvhull(binaryImage);
% Display the image.
subplot(3, 3, 5);
imshow(mask, []);
title('Largest blob', 'FontSize', fontSize, 'Interpreter', 'None');

% Mask the image
% Mask the image using bsxfun() function ( if foreground black and
% background normal, then ~mask instead of mask)
maskedRgbImage = bsxfun(@times, originalImage, cast(mask, 'like', originalImage));

% Display the image.
subplot(3, 3, 6);
imshow(maskedRgbImage, []);
title('Masked Image', 'FontSize', fontSize, 'Interpreter', 'None');

 %face detection
 bbox = step(faceDetector, originalImage);
 n= size (bbox,1);  %bbox is the bounding box & 1 represents the no. of rows in bounding box
 str_n= num2str(n);
 str= sprintf('number of faces: %d', n);
% 
 %Draw the returned bounding box around the detected face.
 faceImage = insertShape(originalImage, 'Rectangle', bbox);
 subplot(3, 3, 7); 
 imshow(originalImage); 
 title(str, 'FontSize', fontSize, 'Interpreter', 'None');

end
 
 %saves the masked image into the same dir
 baseFileName = 'masked.png'; 
 fullFileName = fullfile(path, baseFileName);
 imwrite(maskedRgbImage, fullFileName);
 
 %% Substitution
 rgbImage=originalImage; %imread('C:\Users\noahb\Documents\object_tracking\img\00004384.jpg');
 maskedImage=imread(strcat(path,baseFileName));
 maskImage = logical(maskedImage(:, :, 1));
 subplot(3, 3, 7);
 %imshow(~maskImage);
 %rgbImage=imread('r
 %maskedRgbImage = bsxfun(@times, rgbImage, cast(~maskedImage, 'like', rgbImage));
 maskedRgbImage = bsxfun(@times, rgbImage, cast(maskImage, 'like', rgbImage));
 backgroundImage=imread('bg.jpg');
 maskedBackground=bsxfun(@times, backgroundImage, cast(~maskImage, 'like', backgroundImage));
 rgbImage = maskedRgbImage + maskedBackground;
 imshow(rgbImage);
