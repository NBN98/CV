function [result, result2, mask,v2] = render(frame,mask,bg,mode,v)
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
          input = false;
      elseif mode == 'background'
          maskedRgbImage = bsxfun(@times, frame, cast(~mask, 'like', frame));
          result=maskedRgbImage;
          result2=frame;
          input = false;
      elseif mode == 'overlay'
          
          input = false;
          
      elseif mode == 'substitute'
          maskedRgbImage = bsxfun(@times, frame, cast(mask, 'like', frame));
          rgbImage=frame; %imread('C:\Users\noahb\Documents\object_tracking\img\00004384.jpg');
          maskedImage=maskedRgbImage;
          maskImage = logical(maskedImage(:, :, 1));
          %subplot(3, 3, 7);
          %imshow(~maskImage);
          %rgbImage=imread('r
          %maskedRgbImage = bsxfun(@times, rgbImage, cast(~maskedImage, 'like', rgbImage));
          maskedRgbImage = bsxfun(@times, rgbImage, cast(maskImage, 'like', rgbImage));
          backgroundImage=imread(bg);
          maskedBackground=bsxfun(@times, backgroundImage, cast(~maskImage, 'like', backgroundImage));
          rgbImage = maskedRgbImage + maskedBackground;
          result=rgbImage;
          result2=frame;
          mask=mask;
          %imshow(rgbImage);
          
          input = false;
      elseif mode == 'bonus'
          
             videoBack=VideoReader(bg);
            
             backframe=read(videoBack,v); %taking single frame of video

             %resizing background into dimensions of input image
             backframe=imresize(backframe,[size(frame,1) size(frame,2)]);
             v2=v+1;
             % reseting video when over
             if v==videoBack.NumberOfFrames+1;
                 v=1;
             end

             inv_mask=ones(size(mask))-mask;

             result=frame.*uint8(mask)+backframe.*uint8(inv_mask);% adding for-and background together
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