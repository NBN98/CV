%put in the video created with Make_Video.m
%video in workspace needed to run this function
videoSource = VideoReader('TestVideo.avi');

detector = vision.ForegroundDetector(...
       'NumTrainingFrames', 500, ...
       'InitialVariance', 30*30);

Est_background = uint8(zeros(600,800,3));
%Estimate the background for this camera
for i=1:10
   Est_background = Est_background + uint8(1/10*(readFrame(videoSource)));
   
end
%Est_background = Est_background./60
%imshow(Est_background);
background_hsv = rgb2hsv(Est_background);
% "30% more" saturation:
background_hsv(:, :, 2) = background_hsv(:, :, 2) * 1.3;
background_hsv(background_hsv > 1) = 1;  % Limit values
Background = hsv2rgb(background_hsv);
imshow(Est_background);
videoPlayer = vision.VideoPlayer();

%loading background video
videoBack=VideoReader('C:\Users\fatis\Desktop\Semester 1 Master\Computer Vision\wavesloop.mp4');
v=1;
while hasFrame(videoSource)
     frame  = readFrame(videoSource);
     
     backframe=read(videoBack,v);
     backframe=imresize(backframe,[size(frame,1) size(frame,2)]);
     v=v+1;
     if v==videoBack.NumberOfFrames+1;
         v=1;
     end
     %Here we can perform some pre-processing 
     %example color saturation or something
     frame_hsv = rgb2hsv(frame);
     % "20% more" saturation:
     frame_hsv(:, :, 2) = frame_hsv(:, :, 2) * 1.3;
     frame_hsv(frame_hsv > 1) = 1;  % Limit values
     Frame = hsv2rgb(frame_hsv);
     Out = abs(Frame - Background);
     Out = rgb2gray(Out);
    
    Out(Out>0.06)=255;
    Out(Out<=0.06)=0;
    se = strel('disk',10);%fs
    Out=imclose(Out,se);%fs
    Out=imfill(Out,'holes');%fs
     %fgMask = detector(frame);
    %Post - processing here
     bw1 = im2bw(Out, graythresh(Out));
    %perform binary operations
    bw1 = bwmorph(bw1, "open",25);
    % bw1 = bwmorph(bw1, "close",10);
    %make thicker the selected area
    bw1 = bwmorph(bw1, "fatten",3);
    FilteredImg = medfilt2(bw1, [5 5]);
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
   % [L2 num2] = bwlabel(L);
     %here we can do some post-processing
     Overlap(:,:,1) = uint8(L) .* frame(:,:,1);
     Overlap(:,:,2) = uint8(L) .* frame(:,:,2);
     Overlap(:,:,3) = uint8(L) .* frame(:,:,3);
     L2=ones(size(L))-L;
     %oo(:,:,1)=uint8(L2).*backframe(size(L2,1),size(L2,2),1);
     %oo(:,:,2)=uint8(L2).*backframe(size(L2,1),size(L2,2),2);
     %oo(:,:,3)=uint8(L2).*backframe(size(L2,1),size(L2,2),3);
     oo=uint8(L2).*backframe;
     vid=Overlap+oo;
     mode=1;%overlaymode
     if mode==3
         L(L>1)=1;
         over1(:,:,1)=uint8(L)*255;
         over1(:,:,3)=uint8(L)*255;
         over1(:,:,2)=zeros(size(L));
         L2=ones(size(L))-L;
         overback(:,:,2)=uint8(L2)*255;
         overback(:,:,1)=zeros(size(L));
         overback(:,:,3)=uint8(L2)*255;
         Over=over1+overback;
         videoPlayer(Over);
     else
         videoPlayer(vid);
     end
         
         
         
         
     %videoPlayer(Overlap);
     pause(0.01);
end
release(videoPlayer);