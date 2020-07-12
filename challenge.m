%% Computer Vision Challenge 2020 challenge.m

%% Start timer here
tStart=tic;

%% Generate Movie
config
loop=0;
v=1;
movie = VideoWriter(dst, 'Motion JPEG AVI');
%uncomment to enable adaptive background
% global seg_times;
% global GBackground;
%end global variables adaptive background
seg_times = 0;
%pre allocate variable
%movie_frames=cell(1, 3000);

% Read in background image/video
if mode == 'substitute'
    if contains(bg, 'jpg') | contains(bg, 'png') %Check whether the background is an image or not
        bg=imread(bg);
        
    else
        error('Background image is not .jpg or .png');
    end
elseif mode =='bonus'
    if contains(bg, 'jpg') | contains(bg, 'png')
        error('Background is in image. Should be a video');
    else
        bg=VideoReader(bg);
    end
    
end

warning('off','images:bwfilt:tie')
%i=1;
while loop ~= 1
    
    % Set up figure properties:
    % Enlarge figure to full screen.
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    % Get rid of tool bar and pulldown menus that are along top of figure.
    set(gcf, 'Toolbar', 'none', 'Menu', 'none');
    % Give a name to the title bar.
    set(gcf, 'Name', 'G21 Computer Vision Challenge', 'NumberTitle', 'Off')
    
  % Get next image tensors
  [left, right, loop]=ir.next();
   
   
  % Generate binary mask
  [mask]=segmentation(left,right); %sumImage);
  
  % always the last frame of the tensor should masked
  frame=left(:,:,(end-2:end));
  
  % Render new frame
  if mode=='bonus'
      [result, v] = render_bonus( frame, mask, bg, mode, v);
  else
      result = render(frame,mask,bg,mode);
  end
  subplot(3, 3, 1);
  imshow(frame);
  title('Left Camera', 'FontSize', fontSize, 'Interpreter', 'None');
  drawnow;
  
  
  
  subplot(3, 3, 2);
  str= sprintf('Selected Mode: %s', mode);
  imshow(result);
  title(str, 'FontSize', fontSize, 'Interpreter', 'None');
  
  subplot(3, 3, 3);
  frame2=right(:,:,(end-2:end));
  imshow(frame2);
  title('Right Camera', 'FontSize', fontSize, 'Interpreter', 'None');
  
 
  
%   subplot(3, 3, 4);
%   grayImage = rgb2gray(result2);
%   diffImage = abs(double(grayImage) - double(background));
%   imshow(diffImage)
  
  %Saves the result into the movie_frames cell array
  %movie_frames{i}=result;
  %i=i+1;
  
%warning('off','last') 
%store=true;
if store
    
    
    %v.Quality=85;
    %for K = 1 : length(movie_frames)
    % check if result is not empty
    if ~isempty(result)
        movie_frames=result;
        open(movie)
        writeVideo(movie, movie_frames);
    else
        break;
    end
    %end
   
    
end
  
  
  
end
close(movie);

%% Write Movie to Disk


% 
% %store=true;
% if store
%     
%     v = VideoWriter(dst, 'Motion JPEG AVI');
%     %v.Quality=85;
%     for K = 1 : length(movie_frames)
%         if ~isempty(movie_frames{K})
%             movie=movie_frames{K};
%             open(v)
%             writeVideo(v, movie);
%         else
%             break;
%         end
%     end
%     close(v);
% end

%% Stop timer here
tEnd = toc(tStart);
 fprintf('Elapsed time: %d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));


