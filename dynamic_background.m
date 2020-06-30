function [output] = dynamic_background(mask,raw,v) %also path as input
%function adds a video as background
%not tested properly yet look into setBinaryMask for working example

% to be used in for loop 

%   raw: raw image of camera
%   v: should be set to 1 outside of the function

     % better: path as input of function
     videoBack=VideoReader('C:\Users\fatis\Desktop\Semester 1 Master\Computer Vision\wavesloop.mp4');
     
     backframe=read(videoBack,v); %taking single frame of video
     
     %resizing background into dimensions of input image
     backframe=imresize(backframe,[size(raw,1) size(raw,2)]);
     v=v+1;
     % reseting video when over
     if v==videoBack.NumberOfFrames+1;
         v=1;
     end

     inv_mask=ones(size(mask))-mask;
     
     output=raw.*mask+backframe.*inv_mask;% adding for-and background together
     
     videoPlayer(output);
     pause(0.01);
     

end

