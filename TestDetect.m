%put in the video created with Make_Video.m
%video in workspace needed to run this function
videoSource = VideoReader('TestVideo.avi');

detector = vision.ForegroundDetector(...
       'NumTrainingFrames', 500, ...
       'InitialVariance', 50*50, 'MinimumBackgroundRatio', 0.7);

   
peopleDetector = vision.PeopleDetector;
   
   
%to try later

area = vision.BlobAnalysis(...
   'CentroidOutputPort', false, 'AreaOutputPort', true, ...
   'BoundingBoxOutputPort', false, ...
   'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 250);



videoPlayer = vision.VideoPlayer();
while hasFrame(videoSource)
     frame  = readFrame(videoSource);
     %to try later, not used here
     %fgMask = detector(frame);
     %area = blob(fgMask);
     frame_people = frame;
     %people detector
     [bboxes,scores] = peopleDetector(frame);
     if ~isempty(bboxes)
        frame_people = insertObjectAnnotation(frame_people,'rectangle',bboxes,scores);
     end
        %figure, imshow(frame_people);
        imshow(frame_people);
        title('Detected people and detection scores');
     %Preprocessing before 
     frame_hsv = rgb2hsv(frame);
    % "30% more" saturation:

    frame_hsv(:, :, 2) = frame_hsv(:, :, 2) * 1.3;

    frame_hsv(frame_hsv > 1) = 1;  % Limit values

    frame_saturated = hsv2rgb(frame_hsv);
     
     
    
    
    %actual detector
     foreground = step(detector, frame);
     
     
     
     %to postprocess
     FilteredImg = medfilt2(foreground, [5 5]);
    [L num] = bwlabel(FilteredImg);
    %get the regions properties this can be used to get rid of the door
    %frame section on the right
    STATS = regionprops(L, "all");
    cc = [];
    removed = 0;
    for i=1:num
       dd= STATS(i).Area;
       if (dd < 1000)
           L(L==i)=0;
           removed=removed+1;
           num=num-1;
           
       end
    end
    [L2 num2] = bwlabel(L);
     foreground_postprocess = L2;
     
     frame_overlap(:,:,1) = uint8(foreground_postprocess) .* frame(:,:,1);
     frame_overlap(:,:,2) = uint8(foreground_postprocess) .* frame(:,:,2);
     frame_overlap(:,:,3) = uint8(foreground_postprocess) .* frame(:,:,3);
     
     videoPlayer(frame_overlap);
     %videoPlayer(foreground_postprocess);
     pause(0.01);
end
release(videoPlayer);