function [mask] = segmentation(left,right)
% Add function description here
% 1. Takes in both tensors
% 2. Calculates the mean of the images except from the last one
% 3. Mean of images is the new background
% 4. Image-Background and applying a specific threshold gives us the binary
% image
% 5. bwareafilt and imfill takes the largest blops and fills out the holes
% 6. The result is the mask
%Global variables to use adaptive background
% global seg_times;
% global GBackground;

%% Calculates Background with MEAN approach
%right here get the mean of the last N images to estimate the background
backgroundImage(:,:,1)=uint8(sum(left(:,:,1:3:end-4),3)/(size(left(:,:,1:3:end-4),3)));
backgroundImage(:,:,2)=uint8(sum(left(:,:,2:3:end-3),3)/(size(left(:,:,1:3:end-4),3)));
backgroundImage(:,:,3)=uint8(sum(left(:,:,3:3:end-2),3)/(size(left(:,:,1:3:end-4),3)));
backgroundImage=cat(3,backgroundImage(:,:,1),backgroundImage(:,:,2),backgroundImage(:,:,3));

%Uncomment this to use adaptive background, only change a little frame by
%frame.
% alpha = 0.85;
% if seg_times == 0
%     %the first time take the mean of N frames
%     backgroundImage(:,:,1)=uint8(sum(left(:,:,1:3:end-4),3)/(size(left(:,:,1:3:end-4),3)));
%     backgroundImage(:,:,2)=uint8(sum(left(:,:,2:3:end-3),3)/(size(left(:,:,1:3:end-4),3)));
%     backgroundImage(:,:,3)=uint8(sum(left(:,:,3:3:end-2),3)/(size(left(:,:,1:3:end-4),3)));
%     backgroundImage=cat(3,backgroundImage(:,:,1),backgroundImage(:,:,2),backgroundImage(:,:,3));
%     GBackground = backgroundImage; 
%     seg_times = 1;
% else
%     %from there only change the background slightly depending on the past 
%     %image and the current Background
%     lastFrame(:,:,1) = uint8(left(:,:,end-5));
%     lastFrame(:,:,2) = uint8(left(:,:,end-4));
%     lastFrame(:,:,3) = uint8(left(:,:,end-3));
%     %apply Background(t) = (1-alpha)*I(t-1)+alpha(Background(t-1)
%     GBackground = (1-alpha) * lastFrame + alpha * GBackground;
%     subplot(3,3,6); imshow(GBackground , []);
%     backgroundImage = GBackground;
% end
%end of the adaptive background section

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

% Subtract the images and the the absolute difference
diffImage = abs(double(grayImage) - double(backgroundImage));

% Threshold the image.
% try here different values
%10
binaryImage = diffImage >=15; %15


% Take largest blob
binaryImage = bwareafilt(binaryImage, 20);

% Fill holes.
se = strel('disk', 45, 0);

%fill holes of the binary result
mask = imfill(binaryImage, 'holes');
%perform a morphological close to the image to get a better shape of the
%foreground and reutrn it
mask = imclose(mask, se);




end
