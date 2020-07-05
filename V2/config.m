%% Computer Vision Challenge 2020 config.m
fontSize = 20;
%% Generall Settings
% Group number: 21
 group_number = 21;

% Group members:
 members = {'Noah Binh Nguyen', 'Fatbardh Smajli', 'Roberto Ruano Martinez', 'Florian Butsch', 'Marta Caneda Portela'};

% Email-Address (from Moodle!):
 mail = {'noahbinh.nguyen@tum.de', 'fatbardh.smajli@tum.de', 'Roberto.ruano@tum.de', 'florian.butsch@tum.de', 'marta.caneda@tum.de'};


%% Setup Image Reader
% Specify Scene Folder
src = "C:\Users\noahb\Desktop\Elektrotechnik\Master\1. Semester SS20\Computer Vision\Challenge\ChokePoint\P1E_S3";

% Select Cameras
 L =2;
 R =3;

% Choose a start point
start = 400;

% Choose the number of succseeding frames
%(think 5 works better)
N = 4;



%% Output Settings
% Output Path
dst = "output.avi";

% Load Virual Background
bg = "C:\Users\noahb\Desktop\Elektrotechnik\Master\1. Semester SS20\Computer Vision\Challenge\bg.jpg";

% Select rendering mode (Choose between foreground, background, overlay,
% substitute, bonus
mode = "foreground"; 

% Create a movie array
% movie =

% Store Output?
store = true;
