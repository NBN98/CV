function [result, result2, mask,v] = render_bonus(frame,mask,bg,mode,v)

    
          backgroundImage=bg;
          
          
          
      if mode == 'bonus'
      
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
  %end

end