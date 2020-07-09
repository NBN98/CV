function [result] = render(frame,mask,bg,render_mode)
  % Add function description here
  % render takes 5 inputs, where v is for the bonus task.
  % frame is always the last frame from the tensor and bg is the background
  % image or video

  %% Implementation of render function
  
  
  if render_mode == "foreground"
      % applies the element-wise binary operation of arrays (specified
      % with @times) // cast function converts the mask to the same
      % data type and complexity as the variable frame.
      maskedRgbImage = bsxfun(@times, frame, cast(mask, 'like', frame));
      result=maskedRgbImage;
      
      % input = false;
  elseif render_mode == "background"
      % since background render_mode is the opposite of the foreground mound,
      % we only need to invert the bits in the mask
      maskedRgbImage = bsxfun(@times, frame, cast(~mask, 'like', frame));
      result=maskedRgbImage;
     
   
  elseif render_mode == "overlay"
      color1=zeros(size(frame));
      color2=zeros(size(frame));
      color1(:,:,3)=ones(size(frame,1),size(frame,2))*255;
      color2(:,:,1)=ones(size(frame,1),size(frame,2))*255;
      
      transp=bsxfun(@times, color1, cast(~mask, 'like', color1))+bsxfun(@times, color2, cast(mask, 'like', color2));
      
      
      result = imfuse(frame,transp,'blend','Scaling','joint');
      
      
     
  elseif render_mode == "substitute"
      
          backgroundImage=bg;
          maskedRgbImage = bsxfun(@times, frame, cast(mask, 'like', frame));
          rgbImage=frame;
          maskedImage=maskedRgbImage;
          maskImage = logical(maskedImage(:, :, 1));
          maskedRgbImage = bsxfun(@times, rgbImage, cast(maskImage, 'like', rgbImage));
          
          maskedBackground=bsxfun(@times, backgroundImage, cast(~maskImage, 'like', backgroundImage));
          rgbImage = maskedRgbImage + maskedBackground;
          result=rgbImage;
          mask=mask;
         
     
  
%   elseif render_mode == 'bonus'
%      
%           backframe=read(bg,v); %taking single frame of video
%           
%           %resizing background into dimensions of input image
%           backframe=imresize(backframe,[size(frame,1) size(frame,2)]);
%           v=v+1;
%           % reseting video when over
%           if v==bg.NumberOfFrames+1;
%               v=1;
%           end
%           
%           %inv_mask=ones(size(mask))-mask;
%           maskedFrame=bsxfun(@times, frame, cast(mask, 'like', frame));
%           maskedBack=bsxfun(@times, backframe, cast(~mask, 'like', backframe));
%           result=maskedFrame+maskedBack;% adding for-and background together
%           mask=mask;
          
  else
      disp('Wrongt input')
      
  end
  %end

end