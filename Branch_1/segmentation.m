function [mask, backgroundImage] = segmentation(left,right)
% Add function description here
%
%

%% Loads the bg images of the txt file
% folder = path;
% 
% if folder == 0
% 	% Clicked cancel.  Exit program.
% 	return;
% end
% 
% % Check if folder exists
% if ~isdir(folder)
% 	errorMessage = sprintf('Folder does not exist:\n%s', folder);
% 	uiwait(warndlg(errorMessage));
% 	return;	
% 	
% end
% 
% 
% imageFiles = readtable(strcat(folder, '\bg_img.txt'), 'ReadVariableNames', false);
% 
%   [m n s]=size(left);
% % %
%   Img=cell(1, s);
%   theyreColorImages = false;
%   counter=1;
%   for k = 1 : 18% s
%       disp(k)
% %  	fullFileName = fullfile(folder, imageFiles.Var1{k});
%     Img{counter} =left(:,:,(k:k+2));
%     counter = counter+1;
%     k=k+2;
%   end
%     
    
    %fullFileName = (left(:,:,(i:i+2));
%  	%fprintf('Reading %s\n', fullFileName);
%  	thisImage=imread(fullFileName);
%  	[r, c, thisNumberOfColorChannels] = size(thisImage);
% 	if k == 1
%  		% Save the first image.
%  		sumImage = double(thisImage);
%  		% Save its dimensions so we can match later images' sizes to this first one.
%  		rows1 = r;
%  		columns1 = c;
%  		numberOfColorChannels1 = thisNumberOfColorChannels;
%  		theyreColorImages = numberOfColorChannels1 >= 3;
% 
%  	else
%  		% It's the second, or later, image.
%  		if rows1 ~= r || columns1 ~= c
%  			% It's not the same size, so resize it to the size of the first image.
%  			thisImage = imresize(thisImage, [rows1, columns1]);
%  		end
%  		% Make sure the colors match - either all color or all gray scale, according to the first one.
%  		if thisNumberOfColorChannels == 3 && numberOfColorChannels1 == 1
%  			% We have color.  Need to change it to grayscale to match the first one.
% 			thisImage = rgb2gray(thisImage);
%  			theyreColorImages = false;
%  		elseif thisNumberOfColorChannels == 1 && numberOfColorChannels1 == 3
%  			% We have grayscale.  Need to change it to RGB to match the first one.
%  			thisImage = cat(3, thisImage, thisImage, thisImage);
%  			theyreColorImages = true;
%  		end
%  		% Now do the summation.
%  		sumImage = sumImage + double(thisImage); % Be sure to cast to double to prevent clipping.	[rows, columns, numberOfColorBands]=size(thisImage);
%  		
%  		% It can't display an RGB image if it's floating point and more than 255.
%  		% So divide it by the number of images to get it into the 0-255 range.
%  		if theyreColorImages
%  			displayedImage = uint8(sumImage / k);
%  		else
%  			displayedImage = sumImage;
%  		end
%  		imshow(displayedImage, []);
%  		drawnow;
%  	end
%  end
% 
% %% calculate the mean
%  sumImage = uint8(sumImage / m);
%  cla;
%  disp('Compute average done!');
%  imshow(sumImage, []);
%backgroundImage = imread(strcat(folder, '\', imageFiles.Var1{1}));

%%
%backgroundImage = imread('C:\Users\noahb\Desktop\Elektrotechnik\Master\1. Semester SS20\Computer Vision\Challenge\ChokePoint\P1E_S1\P1E_S1_C1\00000000.jpg');
%sum(left(:,:, end-2)
%backgroundImage=sum(left(:,:,end-2), 3)/size(left(:,:, end-2),3);
backgroundImage(:,:,1)=uint8(sum(left(:,:,1:3:end-4),3)/(size(left(:,:,1:3:end-4),3)));
backgroundImage(:,:,2)=uint8(sum(left(:,:,2:3:end-3),3)/(size(left(:,:,1:3:end-4),3)));
backgroundImage(:,:,3)=uint8(sum(left(:,:,3:3:end-2),3)/(size(left(:,:,1:3:end-4),3)));
backgroundImage=cat(3,backgroundImage(:,:,1),backgroundImage(:,:,2),backgroundImage(:,:,3));
 subplot(3, 3, 8);
 imshow(backgroundImage, []);
% backgroundImage=imread(strcat(path, 
originalImage=left(:, :, [end-2:end]);
%imshow(left(:,:, end-2:end));

% Get the dimensions of the image.
% numberOfColorBands should be = 1.
[rows, columns, numberOfColorChannels] = size(backgroundImage);
if numberOfColorChannels > 1
   
    % It's not really gray scale like we expected - it's color.
    % Convert it to gray scale.
    GbackgroundImage = rgb2gray(backgroundImage);
end


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

BackgroundHsv = rgb2hsv(backgroundImage);
FrameHsv = rgb2hsv(originalImage);
% 10% more saturation:
BackgroundHsv(:, :, 2) = BackgroundHsv(:, :, 2) * 1.15;
FrameHsv(:, :, 2) = FrameHsv(:, :, 2) * 1.15;
BackgroundHsv(BackgroundHsv > 1) = 1;  % Limit values
FrameHsv(FrameHsv > 1) = 1;  % Limit values
%Back to RGB
BackgroundProcessed = hsv2rgb(BackgroundHsv);
FrameProcessed = hsv2rgb(FrameHsv);

RgbDiffImage = abs(FrameProcessed - BackgroundProcessed);

GrayDiff = rgb2gray(RgbDiffImage);

% Subtract the images
diffImage = abs(double(grayImage) - double(GbackgroundImage));
% diffImage = ~diffImage;

% Display the image.
 %subplot(3, 3, 6);
 %imshow(diffImage, []);
% axis on;



% Threshold the image.
% try here different values
%10
binaryImage = diffImage >=15;
binaryImage2 = GrayDiff > 0.08;
% Display the image.
 %subplot(3, 3, 5);
 %imshow(binaryImage, []);


% Take largest blob
binaryImage = bwareafilt(binaryImage, 20);
binaryImage2 = bwareafilt(binaryImage2, 20);
subplot(3, 3, 9);
imshow(binaryImage2, []);


% Fill holes.
se = strel('disk', 50, 0);

mask = imfill(binaryImage, 'holes');
mask = imclose(mask, se);

%post process hsv method
mask2 = imfill(binaryImage, 'holes');
mask2 = imclose(mask, 10);
FilteredImg = medfilt2(mask2, [5 5]);
mask2 = bwmorph(FilteredImg, "fatten",6);
subplot(3, 3, 6);
imshow(mask2, []);
%mask = imclose(mask, 10);
% % Get convex hull
% binaryImage = bwconvhull(binaryImage);
% Display the image.
% subplot(3, 3, 5);
% imshow(mask, []);
% title('Largest blob', 'FontSize', fontSize, 'Interpreter', 'None');

% Mask the image
% Mask the image using bsxfun() function ( if foreground black and
% background normal, then ~mask instead of mask)
% maskedRgbImage = bsxfun(@times, originalImage, cast(mask, 'like', originalImage));
% 
% % Display the image.
% subplot(3, 3, 6);
% imshow(maskedRgbImage, []);
% title('Masked Image', 'FontSize', fontSize, 'Interpreter', 'None');

% face detection
% bbox = step(faceDetector, originalImage);
% n= size (bbox,1);  %bbox is the bounding box & 1 represents the no. of rows in bounding box
% str_n= num2str(n);
% str= sprintf('number of faces: %d', n);
%
% % Draw the returned bounding box around the detected face.
% faceImage = insertShape(originalImage, 'Rectangle', bbox);
% subplot(3, 3, 7);
% imshow(originalImage);
% title(str, 'FontSize', fontSize, 'Interpreter', 'None');

end
