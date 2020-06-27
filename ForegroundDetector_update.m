
tic; %timer

%directory to specific folders from which the frames will be extracted
workingDir = fullfile('CV','Challenge','Chokepoint','P1E_S1','P1E_S1_C1'); 

%Creating video out of the video frames because ForegroundDetector works
%with videos
outputVideo = VideoWriter(fullfile(workingDir,'shuttle_out.avi')); 
outputVideo.FrameRate = 30; 
open(outputVideo);
 
%Getting list of picture names
S = dir(fullfile(workingDir,'*.jpg')); % specify the file extension to exclude directories
S_cell=struct2cell(S);
n_frames=300; %specify how many images will be taken for the video
imageNames=S_cell(1,1:n_frames); %list of image filenames that will be taken to create the video 

for ii = 1:length(imageNames)    
    img = imread(fullfile(workingDir,imageNames{ii}));    
    writeVideo(outputVideo,img) 
end
close(outputVideo); %video is ready

% %Visualize video (commented out cause not needed)
% shuttleAvi = VideoReader(fullfile(workingDir,'shuttle_out.avi'));
% ii = 1; 
% 
% while hasFrame(shuttleAvi)    
%     mov(ii) = im2frame(readFrame(shuttleAvi));   
%     ii = ii+1; 
% end
% 
% figure  
% imshow(mov(1).cdata, 'Border', 'tight')
% movie(mov,1,30)


%Foreground detector
n_train=108; %first images that will be used to train the background model
foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, 'NumTrainingFrames', n_train,'MinimumBackgroundRatio',0.3);
videoReader = VideoReader(fullfile(workingDir,'shuttle_out.avi'));
% for i = 1:380
%     frame = readFrame(videoReader); % read the next video frame
%     foreground = step(foregroundDetector, frame);
%       
% end
% 
% figure; 
% imshow(frame); 
% title('Video Frame');

% figure; 
% imshow(foreground); 
% title('Foreground');

% se = strel('square', 3);
% filteredForeground = imopen(foreground, se);
% figure; 
% imshow(filteredForeground); 
% title('Clean Foreground');

% figure
% masked_Image = bsxfun(@times, frame, cast(foreground, 'like', frame));
% imshow(masked_Image)
% title('masked_Image');
% 
% figure
% masked_filtered_Image = bsxfun(@times, frame, cast(filteredForeground, 'like', frame));
% imshow(masked_filtered_Image)
% title('masked_filtered_Image');


%Creating all masked frames and saving them
for i=1:(n_frames-1)
    frame = readFrame(videoReader); % read the next video frame
    foreground = step(foregroundDetector, frame); %foreground mask
    masked_Image = bsxfun(@times, frame, cast(foreground, 'like', frame)); %masking current frame
    baseFileName = sprintf('Image%d.jpg', i); %masked frame
    path='C:\Users\Usuario\Desktop\CV\Challenge'; %where to save all masked images
    fullFileName = fullfile(path,'Masked_images', baseFileName);
    imwrite(masked_Image, fullFileName);  
end

%Creating video out of the masked frames for visualization
workingDir1 = fullfile('CV','Challenge','Masked_images');
maskedVideo = VideoWriter(fullfile(workingDir1,'masked_out.avi')); 
maskedVideo.FrameRate = 30; 
open(maskedVideo);
 
D1 = 'C:\Users\Usuario\Desktop\CV\Challenge\Masked_images';
S1 = dir(fullfile(D1,'*.jpg')); % specify the file extension to exclude directories
S1_cell=struct2cell(S1);
imageNames1=S1_cell(1,:); %list of masked image filenames

for ii = 1:length(imageNames1)    
    img = imread(fullfile(workingDir1,imageNames1{ii}));    
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

% videoPlayer = vision.VideoPlayer('shuttle_out.avi', 'Detected Cars');
% videoPlayer.Position(3:4) = [650,400];  % window size: [width, height]
% se = strel('square', 3); % morphological filter for noise removal
% 
% while hasFrame(videoReader)
% 
%     frame = readFrame(videoReader); % read the next video frame
% 
%     % Detect the foreground in the current video frame
%     foreground = step(foregroundDetector, frame);
%     
% %     masked_Image = bsxfun(@times, frame, cast(foreground, 'like', frame));
% %     imshow(masked_Image)
% 
%     % Use morphological opening to remove noise in the foreground
%     filteredForeground = imopen(foreground, se);
% 
% %     % Detect the connected components with the specified minimum area, and
% %     % compute their bounding boxes
% %     bbox = step(blobAnalysis, filteredForeground);
% % 
% %     % Draw bounding boxes around the detected cars
% %     result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');
% % 
% %     % Display the number of cars found in the video frame
% %     numCars = size(bbox, 1);
% %     result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
% %         'FontSize', 14);
% 
%     step(videoPlayer, result);  % display the results
% end

elapsed_time=toc; 