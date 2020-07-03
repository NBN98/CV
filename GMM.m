videoSource = VideoReader('TestVideo.avi');


%detector = vision.ForegroundDetector;

detector = vision.ForegroundDetector(...
       'NumTrainingFrames', 50, ...
       'InitialVariance', 15*15);
blob = vision.BlobAnalysis(...
       'CentroidOutputPort', false, 'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 250);
   
   shapeInserter = vision.ShapeInserter('BorderColor','White');
   
   videoPlayer = vision.VideoPlayer();
while hasFrame(videoSource)
     frame  = readFrame(videoSource);
     
     frame_hsv = rgb2hsv(frame)*1.5;%increase saturation
     
     
     
     
     fgMask = detector(frame);
     bbox   = blob(fgMask);
     out    = shapeInserter(frame,bbox);
     videoPlayer(out);
     pause(0.1);
end