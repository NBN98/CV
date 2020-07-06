%% Computer Vision Challenge 2020 config.m
fontSize = 20;
%% Generall Settings
% Group number: 21
 group_number = 21;

% Group members:
 members = {'Noah Binh Nguyen', 'Fatbardh Smajli', 'Roberto Ruano Martinez', 'Florian Butsch', 'Marta Caneda Portela'};

% Email-Address (from Moodle!):
 mail = {'noahbinh.nguyen@tum.de', 'fatbardh.sm@tum.de', 'Roberto.ruano@tum.de', 'florian.butsch@tum.de', 'marta.caneda@tum.de'};


%% Setup Image Reader
% Specify Scene Folder
src = "C:\Users\fatis\Desktop\Semester 1 Master\Computer Vision\Bilder\P1E_S1";

% Select Cameras
 L =2;
 R =3;

% Choose a start point
start = 10;

% Choose the number of succseeding frames
%(think 5 works better)
N = 10;



%% Output Settings
% Output Path
dst = "output.avi";

% Select rendering mode (Choose between foreground, background, overlay,
% substitute, bonus
mode = "bonus"; 

% Load Virual Background
if mode=="substitute";
    bg = "C:\Users\fatis\Desktop\Semester 1 Master\Computer Vision\bg.jpg";
elseif mode=="bonus";
    bg = "C:\Users\fatis\Desktop\Semester 1 Master\Computer Vision\wavesloop.mp4";
end



% Create a movie array
% movie =

% Store Output?
store = true;