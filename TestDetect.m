%put in the video created with Make_Video.m
%video in workspace needed to run this function
videoSource = VideoReader('TestVideo.avi');

detector = vision.ForegroundDetector(...
       'NumTrainingFrames', 5, ...
       'InitialVariance', 30*30);

%to try later, not used here
area = vision.BlobAnalysis(...
   'CentroidOutputPort', false, 'AreaOutputPort', true, ...
   'BoundingBoxOutputPort', false, ...
   'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 250);



videoPlayer = vision.VideoPlayer();
while hasFrame(videoSource)
     frame  = readFrame(videoSource);
     %to try later, not used here
     fgMask = detector(frame);
     %area = blob(fgMask);

     
    
     foreground = step(detector, frame);
     
     videoPlayer(foreground);
     pause(0.1);
end
release(videoPlayer);