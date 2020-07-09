function [mask, backgroundImage] = segmentation(left,right)
% Add function description here
% 1. Takes in both tensors
% 2. Calculates the mean of the images except from the last one
% 3. Mean of images is the new background
% 4. Image-Background and applying a specific threshold gives us the binary
% image
% 5. bwareafilt and imfill takes the largest blops and fills out the holes
% 6. The result is the mask


%% Calculates Background with MEAN approach
backgroundImage(:,:,1)=uint8(sum(left(:,:,1:3:end-4),3)/(size(left(:,:,1:3:end-4),3)));
backgroundImage(:,:,2)=uint8(sum(left(:,:,2:3:end-3),3)/(size(left(:,:,1:3:end-4),3)));
backgroundImage(:,:,3)=uint8(sum(left(:,:,3:3:end-2),3)/(size(left(:,:,1:3:end-4),3)));
backgroundImage=cat(3,backgroundImage(:,:,1),backgroundImage(:,:,2),backgroundImage(:,:,3));

%last image of tensor should get a mask 
originalImage=left(:, :, (end-2:end));


% Get the dimensions of the image.
% numberOfColorBands should be = 1.
[rows, columns, numberOfColorChannels] = size(backgroundImage);
if numberOfColorChannels > 1
   
    % It's not really gray scale like we expected - it's color.
    % Convert it to gray scale.
    backgroundImage = rgb2gray(backgroundImage);
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

% Subtract the images
diffImage = abs(double(grayImage) - double(backgroundImage));



% Threshold the image.
% try here different values
%10
%T=graythresh(diffImage);
%disp(T);
binaryImage = diffImage >=15; %15


% Take largest blob
binaryImage = bwareafilt(binaryImage, 20);

% Fill holes.
se = strel('disk', 45, 0);

mask = imfill(binaryImage, 'holes');
mask = imclose(mask, se);
%mask=medfilt2(mask, [5 5]);
% % Get convex hull
% binaryImage = bwconvhull(binaryImage);



end
