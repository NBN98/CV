classdef ImageReader < handle
  % Add class description here
  %
  %
 
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
         
          p = inputParser;
          defaultstart = 0;
          defaultN = 1;
         
          
          validnumber = @(x) isnumeric(x);
          validstring = @(x) isstring(x) | ischar(x);
          validL = @(x) (x==2) | (x==1);
          validR = @(x) (x==2) | (x==3);
      
          
          addRequired(p,'src', validstring);
          addRequired(p,'L', validL);
          addRequired(p,'R', validR);
          
          
          addOptional(p,'start',defaultstart,validnumber);
          addOptional(p,'N',defaultN,validnumber);
          
          
          parse(p, src, L, R, varargin{:});
          obj.src = p.Results.src;
          obj.L = p.Results.L;
          obj.R = p.Results.R;
          obj.start=p.Results.start;
          obj.N=p.Results.N;
          
          
          
          if obj.L == 1
              % sub Directory 1 (search whether a folder has 'C1' in
              % name)
              path_L = dir(strcat(obj.src, '\*C1*')); %returns struct array
              obj.joint_path_L=strcat(path_L.folder,'\', path_L.name);
              
              
          else
              % sub directory 2
              path_L = dir(strcat(obj.src, '\*C2*')); %returns struct array
              obj.joint_path_L=strcat(path_L.folder,'\', path_L.name);
              
              
          end
          
          if R ==2
              %sub directory 2
              path_R = dir(strcat(obj.src, '\*C2*')); 
              obj.joint_path_R=strcat(path_R.folder,'\', path_R.name);
              
          else
             % sub directory 3
             path_R = dir(strcat(obj.src, '\*C3*')); 
             obj.joint_path_R=strcat(path_R.folder,'\', path_R.name);
             
          
          end
          
      end
      

      
           
          function [left, right]=next(obj)
              
             
              %loads the images into a struct array
              images_L = dir(strcat(obj.joint_path_L, '\*.jpg'));
              images_R = dir(strcat(obj.joint_path_R, '\*.jpg'));
              
             
              %saves the image properties to workspace
              assignin('base','image_L',images_L);
              assignin('base','image_R', images_R);

            
              % for every call, we increase the the class property counter
              obj.counter = obj.counter+1;
              ImageArray_L=cell(1, 2292);
              ImageArray_R=cell(1, 2292);
              index=1;
%               for i=50:70
%                   
%                   ImageArray{tt}=imread(strcat(obj.joint_path_L, '\', images_L(i).name));
%                   tt=tt+1;
%               end
              
           
              %whos ImageArray
              
%               for i=2:length(ImageArray)
%                  if ~isempty(ImageArray{1,i})
%                    Image0 =  ImageArray{1,1};
%                    tmp = ImageArray{1,i};
%                    left=cat(3, Image0, tmp);
%                    assignin('base','left', left);
%                  else
%                      break
%                  end
%               end
               
          try    
              if obj.counter == 1
                  %if loop is not 1, then start at the
                  %start value
                  if obj.loop ~= 1
                      if obj.start==0
                          % added +1 to obj.start, beauce if start=0 -->
                          % array inex starts at 1
                          
                          for i=obj.start+1:obj.start+1+obj.N
                              %disp(images_L(i).name)
                              % ImageArray{i}=imread(strcat(obj.joint_path_L, '\', images_L(i).name));
                              ImageArray_L{index}=imread(strcat(obj.joint_path_L, '\', images_L(i).name));
                              ImageArray_R{index}=imread(strcat(obj.joint_path_R, '\', images_L(i).name));
                              index=index+1;
                              obj.counter = i;
                              
                          end
                          assignin('base','ImageArray_L', ImageArray_L);
                          assignin('base','ImageArray_R', ImageArray_R);
                          left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
                          right=cat(3, ImageArray_R{:});
                          assignin('base','left', left);
                          assignin('base','right', right);
                          
                      % if start is not zero    
                      else
                          for i=obj.start:obj.start+ obj.N
                              
                              %disp(images_L(i).name)
                              % ImageArray{i}=imread(strcat(obj.joint_path_L, '\', images_L(i).name));
                              ImageArray_L{index}=imread(strcat(obj.joint_path_L, '\', images_L(i).name));
                              ImageArray_R{index}=imread(strcat(obj.joint_path_R, '\', images_L(i).name));
                              index=index+1;
                              obj.counter = i;
                              %disp(images_L(i).name);
                              if images_L(i).name == images_L(end).name
                                  
                                  obj.counter = 0;
                                  i=obj.counter;
                                  obj.loop=1;
                                  
                                  
%                                   assignin('base','ImageArray_L', ImageArray_L);
%                                   assignin('base','ImageArray_R', ImageArray_R);
%                                   left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
%                                   right=cat(3, ImageArray_R{:});
%                                   assignin('base','left', left);
%                                   assignin('base','right', right);
                                  break;
                                  
                                  
                              else
                                  continue;
                                  
                              end
                              
                          end
                          
                            assignin('base','ImageArray_L', ImageArray_L);
                            assignin('base','ImageArray_R', ImageArray_R);
                            left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
                            right=cat(3, ImageArray_R{:});
                            assignin('base','left', left);
                            assignin('base','right', right);
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
                          obj.counter = i;
                          
                          obj.loop = 0;     %reset the loop value
                          %disp(obj.loop)
                      end
                      assignin('base','ImageArray_L', ImageArray_L);
                      assignin('base','ImageArray_R', ImageArray_R);
                      left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
                      right=cat(3, ImageArray_R{:});
                      assignin('base','left', left);
                      assignin('base','right', right);
                  end
                  
                  
              else %if the obj.counter is not 1
                  
                  for j=obj.counter:obj.counter+obj.N
                      %disp(images_L(j).name)
                      ImageArray_L{index}=imread(strcat(obj.joint_path_L, '\', images_L(j).name));
                      ImageArray_R{index}=imread(strcat(obj.joint_path_R, '\', images_L(j).name));
                      index=index+1;
                      obj.counter = j;
                      % if the loaded image is the last one, we should
                      % start at the beginning, since obj.loop is only
                      % defined here equal to 1
                      if images_L(j).name == images_L(end).name
                          obj.counter = 0;
                          j=obj.counter;
                          obj.loop=1;
                          
                          %disp(images_L(j).name);
%                           assignin('base','ImageArray_L', ImageArray_L);
%                           assignin('base','ImageArray_R', ImageArray_R);
%                           left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
%                           right=cat(3, ImageArray_R{:});
%                           assignin('base','left', left);
%                           assignin('base','right', right);
                          break;
                          
                          
                      else
                          continue;
                          
                      end
                      
                  end
                  assignin('base','ImageArray_L', ImageArray_L);
                  assignin('base','ImageArray_R', ImageArray_R);
                  left=cat(3, ImageArray_L{:}); %To show the image use figure, then montage(left)
                  right=cat(3, ImageArray_R{:});
                  assignin('base','left', left);
                  assignin('base','right', right);
                      
              end
              
          catch
              
              if obj.start > length(images_L)
                  error('Start value exceeds the number of images. Value should be within 0 and %d.', length(images_L));
                  
                  
              else
                  error('Errors occur. Check value N or syntax');
                  
              end
          end
          
          end
          
      
  end
end
