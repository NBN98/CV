%name the video here
writerObj = VideoWriter('TestVideo.avi');
%open folder with images
myFolder = 'C:\Users\fatis\Desktop\Semester 1 Master\Computer Vision\Pro\P1E_S1\P1E_S1_C2';

if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end

%start video
open(writerObj);

%put images to video
filePattern = fullfile(myFolder, '*.jpg');
jpegFiles = dir(filePattern);
for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  thisimage = imread(fullFileName);
  writeVideo(writerObj, thisimage);
end
close(writerObj);