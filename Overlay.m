%%Change directory 



%directory to specific folders from which the frames will be extracted
workingDir = fullfile('CV','Challenge','Chokepoint','P1E_S1','P1E_S1_C1'); 

%Creating video out of the video frames because ForegroundDetector works
%with videos
outputVideo = VideoWriter(fullfile(workingDir,'shuttle_out.avi')); 
outputVideo.FrameRate = 30; 
open(outputVideo);

%Getting list of picture names
bg_file = fileread('bg_img.txt');
bg_imgs = strsplit(bg_file,'\n'); %photos used for background model
bg_imgs(:,end)=[]; %delete last empty cell
all_file = fileread('all_file.txt'); 
all_imgs = strsplit(all_file,'\n'); %all photos
all_imgs(:,end)=[]; %delete last empty cell
n_frames=300; %specify how many images will be taken for the video
imageNames1=all_imgs(:,1:n_frames);

for ii = 1:length(imageNames1) 
    img = imread(fullfile(workingDir,imageNames1{ii}));    
    writeVideo(outputVideo,img) 
end
close(outputVideo); %video is ready

%Foreground detector
n_train=length(bg_imgs); %first images that will be used to train the background model (101-1 cause last one in bg_imgs is empty)
foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, 'NumTrainingFrames',108,'MinimumBackgroundRatio',0.3);

videoReader = VideoReader(fullfile(workingDir,'shuttle_out.avi'));

for i = 1:(length(imageNames1))
    frame = readFrame(videoReader); % read the next video frame
    foreground = step(foregroundDetector, frame);
      
end


%PLOTTING THE LAST FRAME IN DIFFERENT WAYS

%%Original frame
% figure; 
% imshow(frame); 
% title('Video Frame');
% 
% % figure; 
% % imshow(foreground); 
% % title('Foreground');
% 

%%Cleaning mask
se = strel('square', 3);
filteredForeground = imopen(foreground, se);
figure; 
imshow(filteredForeground); 
title('Clean Foreground');

%&Plot normal with foreground mask
% figure
% masked_Image = bsxfun(@times, frame, cast(foreground, 'like', frame));
% imshow(masked_Image)
% title('masked_Image');
% 
%%Plot foreground mask with reduced noise
% figure
% masked_filtered_Image = bsxfun(@times, frame, cast(filteredForeground, 'like', frame));
% imshow(masked_filtered_Image);
% title('masked_filtered_Image');
 

%Overlay
figure; 
imshow(frame); %display original frame 
title('Overlay Frame');
other=~filteredForeground; %create opposite mask background
hOVM = alphamask(filteredForeground); %overlay for foreground , default blue and 50% transparency
second_hOVM=alphamask(other,[1 0 0],0.3); %overlay for background, red color and 30% transparency
DirectoryPath ='C:\Users\Usuario\Desktop\CV\Challenge';
whereToStore=fullfile(DirectoryPath,'maskedoverlay.png');




%Creating all masked frames and saving them
for i=1:(length(imageNames1)-1)
    frame = readFrame(videoReader); % read the next video frame
    foreground = step(foregroundDetector, frame); %foreground mask
    
%%Morphological opening to reduce noise (not much of a difference)
    se = strel('square', 3);
    filteredForeground = imopen(foreground, se);
    masked_filtered_Image=bsxfun(@times, frame, cast(filteredForeground, 'like', frame));
  
    
%   masked_Image = bsxfun(@times, frame, cast(foreground, 'like', frame)); %masking current frame
    baseFileName = sprintf('Image%d.jpg', i); %masked frame
    path='C:\Users\Usuario\Desktop\CV\Challenge'; %where to save all masked images
    fullFileName = fullfile(path,'Masked_images', baseFileName);
    
    imwrite(masked_filtered_Image, fullFileName); 
    
    %     imwrite(masked_Image, fullFileName);  
end

%Creating video out of the masked frames for visualization
workingDir1 = fullfile('CV','Challenge','Masked_images');
maskedVideo = VideoWriter(fullfile(workingDir1,'masked_out.avi')); 
maskedVideo.FrameRate = 30; 
open(maskedVideo);
 
D1 = 'C:\Users\Usuario\Desktop\CV\Challenge\Masked_images';
S1 = dir(fullfile(D1,'*.jpg')); % specify the file extension to exclude directories
S1_cell=struct2cell(S1);
imageNames2=S1_cell(1,:); %list of masked image filenames

for ii = 1:length(imageNames2)    
    img = imread(fullfile(workingDir1,imageNames2{ii}));    
    writeVideo(maskedVideo,img) 
end

close(maskedVideo); %video is ready

%Visualize masked video
maskedAvi = VideoReader(fullfile(workingDir1,'masked_out.avi'));
ii = 1; 

while hasFrame(maskedAvi)    
    mov(ii) = im2frame(readFrame(maskedAvi));   
    ii = ii+1; 
end

figure  
imshow(mov(1).cdata, 'Border', 'tight')
movie(mov,1,30)

videoPlayer = vision.VideoPlayer('shuttle_out.avi', 'Detected Cars');
videoPlayer.Position(3:4) = [650,400];  % window size: [width, height]
se = strel('square', 3); % morphological filter for noise removal

while hasFrame(videoReader)

    frame = readFrame(videoReader); % read the next video frame

    % Detect the foreground in the current video frame
    foreground = step(foregroundDetector, frame);
    
%     masked_Image = bsxfun(@times, frame, cast(foreground, 'like', frame));
%     imshow(masked_Image)

    % Use morphological opening to remove noise in the foreground
    filteredForeground = imopen(foreground, se);

    step(videoPlayer, result);  % display the results
end

