function [result, result2, mask] = render(frame,mask,bg,mode)
  % Add function description here
  %
  %
  input = true;
  while input
      
      if mode == 'foreground'
          maskedRgbImage = bsxfun(@times, frame, cast(mask, 'like', frame));
          input = false;
      elseif mode == 'background'
          maskedRgbImage = bsxfun(@times, frame, cast(~mask, 'like', frame));
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
          
          input = false;
      else
          disp('Wrongt input')
          
      end
  end

end
