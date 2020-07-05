%% Computer Vision Challenge 2020 challenge.m

%% Start timer here
tic;

%% Generate Movie
config
loop=0;
ir=ImageReader(src, L, R, start, N);
%sumImage=calcBack(src, L);


%pre allocate variable
movie_frames=cell(1, 3000);

i=1;
while loop ~= 1
    % Set up figure properties:
    % Enlarge figure to full screen.
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    % Get rid of tool bar and pulldown menus that are along top of figure.
    set(gcf, 'Toolbar', 'none', 'Menu', 'none');
    % Give a name to the title bar.
    set(gcf, 'Name', 'G21 Computer Vision Challenge', 'NumberTitle', 'Off')
    
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
  str= sprintf('Selected Mode: %s', mode);
  
  imshow(result);
  title(str, 'FontSize', fontSize, 'Interpreter', 'None');
  
  subplot(3, 3, 3);
  imshow(mask);
  
  subplot(3, 3, 4);
  grayImage = rgb2gray(result2);
  diffImage = abs(double(grayImage) - double(background));
  imshow(diffImage)
  
  %Saves the result into the movie_frames cell array
  movie_frames{i}=result;
  i=i+1;
  
  %if i== 4
  %loop=1;
  %end
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
elapsed_time = toc;


%% Write Movie to Disk



%store=true;
if store
    
    v = VideoWriter(dst, 'Motion JPEG AVI');
    %v.Quality=85;
    for K = 1 : length(movie_frames)
        if ~isempty(movie_frames{K})
            movie=movie_frames{K};
            open(v)
            writeVideo(v, movie);
        else
            break;
        end
    end
    close(v);
end
