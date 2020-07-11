classdef ImageReader < handle
  % Add class description here
  % ImageReader inherits from handle
  %
  
  %the following are the initial values for the variables that are needed
  %for the ImageReader class. This will be changed acording to the config.m
  %file or the GUI depending on the use. 
  
  properties
      src='';
      L=0;
      R=0;
      start=0;
      N=0;
      joint_path_L='';
      joint_path_R='';
      loop=0;
      counter =0;
      
      
      
  end
  
  methods
      % constructor with input parser
      function obj = ImageReader(src, L, R, varargin)
          global numberOfImages;
          p = inputParser;
          defaultstart = 0;
          defaultN = 1;
         
           %set the functions to verify valid variables
          validnumber = @(x) isnumeric(x);
          validstring = @(x) isstring(x) | ischar(x);
          validL = @(x) (x==2) | (x==1);
          validR = @(x) (x==2) | (x==3);
      
          %add the parameters to the input parser
          addRequired(p,'src', validstring);
          addRequired(p,'L', validL);
          addRequired(p,'R', validR);
          
          %add Optional parameters
          addOptional(p,'start',defaultstart,validnumber);
          addOptional(p,'N',defaultN,validnumber);
          
          %parse and assign the parameters.
          parse(p, src, L, R, varargin{:});
          obj.src = p.Results.src;
          obj.L = p.Results.L;
          obj.R = p.Results.R;
          obj.start=p.Results.start;
          obj.N=p.Results.N;
          
          
          %verify which was the selected number for the left variable
          if obj.L == 1
              % sub Directory 1 (search whether a folder has 'C1' in
              % name)
              path_L = dir(fullfile(obj.src, '*C1*')); %returns struct array
              obj.joint_path_L=fullfile(path_L.folder, path_L.name);
              
              
          else
              % sub directory 2
              path_L = dir(fullfile(obj.src, '*C2*')); %returns struct array
              obj.joint_path_L=fullfile(path_L.folder, path_L.name);
              
              
          end
          
          if R ==2
              %sub directory 2
              path_R = dir(fullfile(obj.src, '*C2*')); 
              obj.joint_path_R=fullfile(path_R.folder, path_R.name);
              
          else
             % sub directory 3
             path_R = dir(fullfile(obj.src, '*C3*')); 
             obj.joint_path_R=fullfile(path_R.folder, path_R.name);
             
          
          end
          %get the total number of images, may be used in the progress bar
          dirL = dir([obj.joint_path_L '\*.jpg']);
          numberOfImages = length(dirL);
      end%end Image reader function
      

      
          %use the next function to load the next tensors in the data set 
          function [left, right, loop]=next(obj)
              joint_path_L = obj.joint_path_L;
             
              %loads the images into a struct array
              images_L = dir(fullfile(obj.joint_path_L, '*.jpg'));
              images_R = dir(fullfile(obj.joint_path_R, '*.jpg'));
              
              
              file_count=dir(fullfile(joint_path_L, '*.jpg'));% does it work?
              number_of_files=length(file_count);
            
              % for every call, we increase the the class property counter
              obj.counter = obj.counter+1;
              
              %preallocate the memory (improve performance) 
              ImageArray_L=cell(1, number_of_files);
              ImageArray_R=cell(1, number_of_files);
              index=1;
               
          try    
              if obj.counter == 1
                  %if loop is not 1, then start at the
                  %start value
                  if obj.loop ~= 1
                      if obj.start==0
                          % added +1 to obj.start, becauce if start=0 -->
                          % array ind ex starts at 1
                          
                          for i=obj.start+1:obj.start+1+obj.N
                              %read the Left and Right images
                              ImageArray_L{index}=imread(fullfile(obj.joint_path_L, images_L(i).name));
                              ImageArray_R{index}=imread(fullfile(obj.joint_path_R, images_L(i).name));
                              index=index+1;
                              
                          end

                          loop=obj.loop;

                          left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
                          right=cat(3, ImageArray_R{:});
                          
                      % if start is not zero    
                      else
                          for i=obj.start+1:obj.start+obj.N+1
                              ImageArray_L{index}=imread(fullfile(obj.joint_path_L, images_L(i).name));
                              ImageArray_R{index}=imread(fullfile(obj.joint_path_R, images_L(i).name));
                              index=index+1;
                              %disp(strcat(obj.joint_path_R, '\', images_L(i).name))
                              obj.counter = i-obj.N;
                              %disp(images_L(i).name);
                              if images_L(i).name == images_L(end).name
                                  obj.counter = 0;
                                  i=obj.counter;
                                  obj.loop=1;
                                  break;
                                      
                              else
                                  continue;
                                  
                              end
                              
                          end

                            loop=obj.loop;

                            left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
                            right=cat(3, ImageArray_R{:});
                      end
                      
                      % if loop is equal to 1, start at the beginning even
                      % though the initial start variable has a different
                      % start
                  else
                      for i=obj.counter:obj.counter+obj.N
                          ImageArray_L{index}=imread(fullfile(obj.joint_path_L, images_L(i).name));
                          ImageArray_R{index}=imread(fullfile(obj.joint_path_R, images_L(i).name));
                          index=index+1;
                          
                          obj.loop = 0;     %reset the loop value
                      end

                      loop=obj.loop;

                      left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
                      right=cat(3, ImageArray_R{:});

                  end %end obj.loop if statement
                  
                  
              else %if the obj.counter is not 1
                  
                  
                  for j=obj.counter:obj.counter+obj.N
                      %disp(images_L(j).name)
                      ImageArray_L{index}=imread(fullfile(obj.joint_path_L, images_L(j).name));
                      ImageArray_R{index}=imread(fullfile(obj.joint_path_R, images_L(j).name));
                      index=index+1;
                      %obj.counter = j;
                      %disp(strcat(obj.joint_path_R, '\', images_L(j).name))
                      % if the loaded image is the last one, we should
                      % start at the beginning, since obj.loop is only
                      % defined here equal to 1
                      if images_L(j).name == images_L(end).name
                          obj.counter = 0;
                          j=obj.counter;
                          obj.loop=1;

                          break;
                          
                      else
                          continue;
                          
                      end
                      

                  end %end if for the counter
                  loop=obj.loop;
                  left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
                  right=cat(3, ImageArray_R{:});         
              end
              
          catch
              
              %this error happens if the path is wrong or there are no
              %images there
              if length(images_L) == 0
                  error("Please verify the structure of the folders and that the path is correct"); 
                  %wrong start value
              elseif obj.start > length(images_L)
                  error('Start value exceeds the number of images. Value should be within 0 and %d', length(images_L));          
              else
                  %general syntax errors
                  error('Errors occur. Check value N or syntax');
              end
          end
          
          
          end
          
      
  end
  
end