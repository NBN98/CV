classdef ImageReader < handle
  % Add class description here
  %
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
         %start iput parser
          p = inputParser;
          %set some default values
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
              path_L = dir(strcat(obj.src, '\*C1*')); %returns struct array
              %join the strings depending on the selected number
              obj.joint_path_L=strcat(path_L.folder,'\', path_L.name); 
              
          else
              % sub directory 2
              path_L = dir(strcat(obj.src, '\*C2*')); %returns struct array
              obj.joint_path_L=strcat(path_L.folder,'\', path_L.name);

          end
          %verify the number selected for the right variable
          if R ==2
              %sub directory 2
              path_R = dir(strcat(obj.src, '\*C2*')); 
              obj.joint_path_R=strcat(path_R.folder,'\', path_R.name);
              
          else
             % sub directory 3
             path_R = dir(strcat(obj.src, '\*C3*')); 
             obj.joint_path_R=strcat(path_R.folder,'\', path_R.name);
             
          
          end
          
      end %end Image reader function
      

      
          %use the next function to load the next tensors in the data set 
          function [left, right, l]=next(obj)
              %get the already constructed path of the object
              joint_path_L = obj.joint_path_L;
             
              %loads the images into a struct array
              images_L = dir(strcat(obj.joint_path_L, '\*.jpg'));
              images_R = dir(strcat(obj.joint_path_R, '\*.jpg'));
            
              % for every call, we increase the class property counter
              obj.counter = obj.counter+1;
              ImageArray_L=cell(1, 2292);
              ImageArray_R=cell(1, 2292);
              index=1;
        
          try    
              %check for the first call of this function
              if obj.counter == 1
                  %if loop is not 1, then start at the
                  %start value
                  if obj.loop ~= 1
                      if obj.start==0
                          % added +1 to obj.start, becauce if start=0 -->
                          % array ind ex starts at 1
                          
                          for i=obj.start+1:obj.start+1+obj.N
                              %disp(images_L(i).name)
                              % ImageArray{i}=imread(strcat(obj.joint_path_L, '\', images_L(i).name));
                              ImageArray_L{index}=imread(strcat(obj.joint_path_L, '\', images_L(i).name));
                              ImageArray_R{index}=imread(strcat(obj.joint_path_R, '\', images_L(i).name));
                              index=index+1;
                              %obj.counter = i;
                              %disp(strcat(obj.joint_path_R, '\', images_L(i).name))
                              
                          end
                          l=obj.loop;
                          %assignin('base','ImageArray_L', ImageArray_L);
                          %assignin('base','ImageArray_R', ImageArray_R);
                          left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
                          right=cat(3, ImageArray_R{:});
                          %assignin('base','left', left);
                          %assignin('base','right', right);
                          
                      % if start is not zero    
                      else
                          for i=obj.start+1:obj.start+obj.N+1
                              %disp('K');
                              %disp(images_L(i).name)
                              % ImageArray{i}=imread(strcat(obj.joint_path_L, '\', images_L(i).name));
                              ImageArray_L{index}=imread(strcat(obj.joint_path_L, '\', images_L(i).name));
                              ImageArray_R{index}=imread(strcat(obj.joint_path_R, '\', images_L(i).name));
                              index=index+1;
                              %disp(strcat(obj.joint_path_R, '\', images_L(i).name))
                              obj.counter = i-obj.N;
                              %disp(images_L(i).name);
                              if images_L(i).name == images_L(end).name
                                  obj.counter = 0;
                                  i=obj.counter;
                                  obj.loop=1;
                                  %l = obj.loop;
                                  %disp(obj.loop);
                                  
                                  
                                   %assignin('base','ImageArray_L', ImageArray_L);
                                   %assignin('base','ImageArray_R', ImageArray_R);
%                                   left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
%                                   right=cat(3, ImageArray_R{:});
%                                   assignin('base','left', left);
%                                   assignin('base','right', right);
                                  break;
                                  
                                  
                              else
                                  continue;
                                  
                              end
                              
                          end
                            l=obj.loop;
                            %assignin('base','ImageArray_L', ImageArray_L);
                            %assignin('base','ImageArray_R', ImageArray_R);
                            left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
                            right=cat(3, ImageArray_R{:});
                            %assignin('base','left', left);
                            %assignin('base','right', right);
                      end
                      
                      % if loop is equal to 1, start at the beginning even
                      % though the initial start variable has a different
                      % start
                  else
                      for i=obj.counter:obj.counter+obj.N
                          %disp(images_L(i).name)
                          ImageArray_L{index}=imread(strcat(obj.joint_path_L, '\', images_L(i).name));
                          ImageArray_R{index}=imread(strcat(obj.joint_path_R, '\', images_L(i).name));
                          index=index+1;
                          %obj.counter = i;
                          %disp(strcat(obj.joint_path_R, '\', images_L(i).name));
                          %disp(obj.loop);
                          
                          obj.loop = 0;     %reset the loop value
                          %l = obj.loop;
                          %disp(obj.loop)
                      end
                      l=obj.loop;
                      %assignin('base','ImageArray_L', ImageArray_L);
                      %assignin('base','ImageArray_R', ImageArray_R);
                      left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
                      right=cat(3, ImageArray_R{:});
                      %assignin('base','left', left);
                      %assignin('base','right', right);
                  end
                  
                  
              else %if the obj.counter is not 1, so this is not the firs call
                  
                  %load N images based on the counter
                  for j=obj.counter:obj.counter+obj.N
                      %disp(images_L(j).name)
                      ImageArray_L{index}=imread(strcat(obj.joint_path_L, '\', images_L(j).name));
                      ImageArray_R{index}=imread(strcat(obj.joint_path_R, '\', images_L(j).name));
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
                      
                  end
                  l=obj.loop;

                  left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
                  right=cat(3, ImageArray_R{:});
                      
              end
          % From here, handle the errors that may be caused from a wront path or wrong values for the variables    
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