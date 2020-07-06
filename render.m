function [result, result2, mask,v] = render(frame,mask,bg,mode,v)
  % Add function description here
  %
  %
  input = true;
  %is this while necessary??
  
  
  while input
      
      if mode == 'foreground'
          maskedRgbImage = bsxfun(@times, frame, cast(mask, 'like', frame));
          result=maskedRgbImage;
          result2=frame;
          v=0;
          input = false;
      elseif mode == 'background'
          maskedRgbImage = bsxfun(@times, frame, cast(~mask, 'like', frame));
          result=maskedRgbImage;
          result2=frame;
          v=0;
          input = false;
      elseif mode == 'overlay'
          
          input = false;
          v=0;
      elseif mode == 'substitute'
          backgroundImage=bg;
          maskedRgbImage = bsxfun(@times, frame, cast(mask, 'like', frame));
          rgbImage=frame; %imread('C:\Users\noahb\Documents\object_tracking\img\00004384.jpg');
          maskedImage=maskedRgbImage;
          maskImage = logical(maskedImage(:, :, 1));
          %subplot(3, 3, 7);
          %imshow(~maskImage);
          %rgbImage=imread('r
          %maskedRgbImage = bsxfun(@times, rgbImage, cast(~maskedImage, 'like', rgbImage));
          maskedRgbImage = bsxfun(@times, rgbImage, cast(maskImage, 'like', rgbImage));
          
          maskedBackground=bsxfun(@times, backgroundImage, cast(~maskImage, 'like', backgroundImage));
          rgbImage = maskedRgbImage + maskedBackground;
          result=rgbImage;
          result2=frame;
          mask=mask;
          v=0;
          %imshow(rgbImage);
          
          input = false;
      elseif mode == 'bonus'
      
             backframe=read(bg,v); %taking single frame of video

             %resizing background into dimensions of input image
             backframe=imresize(backframe,[size(frame,1) size(frame,2)]);
             v=v+1;
             % reseting video when over
             if v==bg.NumberOfFrames+1;
                 v=1;
             end

             %inv_mask=ones(size(mask))-mask;
             maskedFrame=bsxfun(@times, frame, cast(mask, 'like', frame));
             maskedBack=bsxfun(@times, backframe, cast(~mask, 'like', backframe));
             result=maskedFrame+maskedBack;% adding for-and background together
             result2=frame;
             mask=mask;
            % videoPlayer(result);
             %pause(0.01);
            
          input = false;
      else
          disp('Wrongt input')
          
      end
  end

end