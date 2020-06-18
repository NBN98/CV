classdef ImageReader
  % Add class description here
  %
  %
  properties
      src='';
      L=0;
      R=0;
      start=0;
      N=0;
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
              joint_path_L=strcat(path_L.folder,'\', path_L.name);
              disp(joint_path_L)

              
          else
              % sub directory 2
              path_L = dir(strcat(obj.src, '\*C2*')); %returns struct array
              joint_path_L=strcat(path_L.folder,'\', path_L.name);
              disp(joint_path_L)
              
          end
          
          if R ==2
              %sub directory 2
              path_R = dir(strcat(obj.src, '\*C2*')); 
              joint_path_R=strcat(path_R.folder,'\', path_R.name);
              disp(joint_path_R)
          else
             % sub directory 3
             path_R = dir(strcat(obj.src, '\*C3*')); 
             joint_path_R=strcat(path_R.folder,'\', path_R.name);
             disp(joint_path_R)
          
          end
      
          function obj = next()
              % load images at start variable and increment by N
              %path = dir(strcat(obj.src, '\*.png'))
              %for
          
          end
      
      end

  end
end
