%% Computer Vision Challenge 2020 challenge.m

%% Start timer here


%% Generate Movie
config
loop=0;
ir=ImageReader(src, L, R, start, N);
%sumImage=calcBack(src, L);


i=1;
while loop ~= 1
  % Get next image tensors
  [left, right, l]=ir.next();
    loop=l;
    
  % Generate binary mask
  [mask, background]=segmentation(left,right); %sumImage);
  
  frame=left(:,:,(end-2:end));
  % Render new frame
  [result, result2,mask] = render(frame,mask,bg,mode);
  subplot(3, 3, 1);
  imshow(result2);
  drawnow;
  subplot(3, 3, 2);
  str= sprintf('Image: %d', i);
  
  imshow(result);
  title(str, 'FontSize', fontSize, 'Interpreter', 'None');
  
  subplot(3, 3, 3);
  imshow(mask);
  
  subplot(3, 3, 4);
  grayImage = rgb2gray(result2);
  diffImage = abs(double(grayImage) - double(background));
  imshow(diffImage)
  i=i+1;
  
  
end
% subplot(3, 3, 1);
% imshow(result2);
% 
% subplot(3, 3, 2);
% imshow(result);
% 
% subplot(3, 3, 3);
% imshow(mask);
% 
% subplot(3, 3, 4);
% grayImage = rgb2gray(result2); 
% diffImage = abs(double(grayImage) - double(background));
% imshow(diffImage)


%% Stop timer here
elapsed_time = 0;


%% Write Movie to Disk
store=false;
if store
  %v = VideoWriter(dst,'Motion JPEG AVI');
end
