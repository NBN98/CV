function [result, result2, mask] = render(frame,mask,bg,mode)
  % Add function description here
  %
  %
  input = true;
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
% %           if ~exist('bwMask', 'var') || ~ismatrix(bwMask) 
% %               error('bwMask matrix is a required argument'); 
% %           end
% %           if ~exist('colour', 'var') 
% %               colour = [0 0 1]; end;
% %           if ~exist('transparency', 'var'), transparency = 0.6; end;
%            if ~exist('axHandle', 'var'), axHandle = gca; end;
% %           if ~isvector(colour) || ~isscalar(transparency) || ~ishandle(axHandle), error('One or more arguments is not in the correct form'); end;
% %           maskRange = max(max(bwMask))-min(min(bwMask));
% %           if maskRange ~= 1 && maskRange ~= 0, error('bwMask must consist only of the values 0 and 1'); end;
%           transparency = 0.5;
%           colour=[255 0 0];
%           % Create colour image and overlay it
%           result = uint8(cat(3, colour(1)*ones(size(mask)), colour(2)*ones(size(mask)), colour(3)*ones(size(mask))));
%           hold on,
%           hOVM = imshow(result, 'Parent', axHandle);
%           set(hOVM, 'AlphaData', mask*transparency);
%           
%           colour=[0 1 255];
%           % Create colour image and overlay it
%           result = uint8(cat(3, colour(1)*ones(size(~mask)), colour(2)*ones(size(~mask)), colour(3)*ones(size(~mask))));
%           hold on,
%           hOVM = imshow(result, 'Parent', axHandle);
%           set(hOVM, 'AlphaData', ~mask*transparency);
%           result2=frame;
%           input = false;
%           
%       elseif mode == 'substitute'
%           maskedRgbImage = bsxfun(@times, frame, cast(mask, 'like', frame));
%           rgbImage=frame; %imread('C:\Users\noahb\Documents\object_tracking\img\00004384.jpg');
%           maskedImage=maskedRgbImage;
%           maskImage = logical(maskedImage(:, :, 1));
%           %subplot(3, 3, 7);
%           %imshow(~maskImage);
%           %rgbImage=imread('r
%           %maskedRgbImage = bsxfun(@times, rgbImage, cast(~maskedImage, 'like', rgbImage));
%           maskedRgbImage = bsxfun(@times, rgbImage, cast(maskImage, 'like', rgbImage));
%           backgroundImage=imread(bg);
%           maskedBackground=bsxfun(@times, backgroundImage, cast(~maskImage, 'like', backgroundImage));
%           rgbImage = maskedRgbImage + maskedBackground;
          invertedmask=~mask;
          
          
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
