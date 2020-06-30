%% Computer Vision Challenge 2020 challenge.m

%% Start timer here


%% Generate Movie
config
loop=0;
ir=ImageReader(src, L, R, start, N);
while loop ~= 1
  % Get next image tensors
  [left, right, joint_path_L]=ir.next();

  % Generate binary mask
  [mask, background]=segmentation(left,right, joint_path_L);
  
  frame=left(:,:,(end-2:end));
  % Render new frame
  [result, result2,mask] = render(frame,mask,bg,mode);
  loop=1;
end
subplot(3, 3, 1);
imshow(result2);

subplot(3, 3, 2);
imshow(result);

subplot(3, 3, 3);
imshow(mask);

subplot(3, 3, 4);
grayImage = rgb2gray(result2); 
diffImage = abs(double(grayImage) - double(background));
imshow(diffImage)


%% Stop timer here
elapsed_time = 0;


%% Write Movie to Disk
store=false;
if store
  %v = VideoWriter(dst,'Motion JPEG AVI');
end
