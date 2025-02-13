%% Computer Vision Challenge 2020 config.m
fontSize = 20;
%% Generall Settings
% Group number: 21
 group_number = 21;

% Group members:
 members = {'Noah Binh Nguyen', 'Fatbardh Smajli', 'Roberto Ruano Martinez', 'Florian Butsch', 'Marta Caneda Portela'};

% Email-Address (from Moodle!):
 mail = {'noahbinh.nguyen@tum.de', 'fatbardh.smajli@tum.de', 'Roberto.ruano@tum.de', 'florian.butsch@tum.de', 'marta.caneda@tum.de'};


%% Add path
addpath('bonus')
 
 %% Setup Image Reader
% Specify Scene Folder
src = "C:\Users\noahb\Desktop\Elektrotechnik\Master\1. Semester SS20\Computer Vision\Challenge\ChokePoint\P1E_S3";
%src="C:\Users\noahb\Desktop\Elektrotechnik\Master\1. Semester SS20\Computer Vision\Challenge\ChokePoint\P2L_S4";
% Select Cameras
 L =1;
 R =3;

% Choose a start point
start = 2280;

% Choose the number of succseeding frames
%
N = 7;

ir = ImageReader(src, L, R, start, N);


%% Output Settings
% Output Path
dest = "output.avi";

% Show rendering process
% If showImage = true, the rendering process will be shown (increased runtime)
% else rendering process is not shown (better runtime)
showImage=false;

% Select rendering render_mode (Choose between foreground, background, overlay,
% substitute, bonus
render_mode = "substitute"; 

% Load Virual Background/video
if render_mode=="substitute";
    bg = "C:\Users\noahb\Documents\GitHub\CV\Backgrounds\bg.jpg";
elseif render_mode=="bonus";
    bg = "C:\Users\noahb\Documents\GitHub\CV\Backgrounds\wavesloop.mp4";
    
else %default value
    bg = "C:\Users\noahb\Documents\GitHub\CV\Backgrounds\bg.jpg";
end



% Create a movie array
% movie =

% Store Output?
store = true;
