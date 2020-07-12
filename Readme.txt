To use our project please follow the following steps:

Inside the folder G21 you will find the file config.
Edit the following to successfully run the challenge:

1) src: Replace this variable with the folder where you have the Scene you want to mask.
example: src = "C:\User\Documents\P1E_S1"
Note: please be sure to select the folder at that level and that it has the corresponding
*_C1, *_c2, and *_C3 folders inside and nothing else. Otherwise, it may lead to errors.

2) L: Replace this value with 1 or 2.
3) R: Replace this value with 2 or 3.

4) start: select the start value here, take into consideration that if you select a
start value bigger than the amount of files in the folder, the program will show an error.

5) bg: You can select here the background to be used in the substitute mode and the bonus mode(video).
Replace these paths with the paths where your image and/or video is located.
Background video should be mp4.
example: "C:\User\Pictures\bg.jpg"
example video: "C:\User\Videos\bgvideo.mp4"

6) showImage: If showImage is true, the rendernig process (displaying frame left, right and result) will be shown (longer runtime)
else the rendering process will not be shown (better runtime)

To run the program:
Option a) Just open the challenge.m file and click on Run.
Option b) You can also type from the command: challenge and then press enter.
		  example: >>challenge

After all images have been masked, the video will be generated. Stopping challenge before it reaches the end of the folder, will lead to not generating the video.


***************************************************************************************************
Using the GUI: 
The GUI has different parameters that can be chosen by the user, these are:
	* Scene Folder: Select the Scene folder as in src above.
	* Virtual Background: Select the jpg or png image you want to use for the background. Optionally choose for the bonus mp4
	* Output Folder: This will work as the store variable, if the user selects a folder, then
					 the generated video will be stored there.
	* Video Name: Select a name for the created video.
	* Mode: Select from the five modes possible: foreground, background, substitute, overlay and bonus.
	* Start at image: Select the image where the program will start from.
	* Loop Video: Checkbox to loop the video.

To run the program click on the Start button to begin.
The program will end if the user presses Stop, or if the Loop Video checkbox is not checked and all the images in the folder have been processed.
Then, the video is exported to the desired folder with the name given and a pop-up appears on the screen showing the video.

Optional Feature: 
	* The user can decide which cameras are used with the L and R value
	* The user can choose wheather the images are displayed while being processed. This will extend the runtime of the program by a lot
	* For information about the status of the program there is console showing the outputs of the program
	
	
***************************************************************************************************
Additional Information:
Trials led to a N number of 7. So 7 frames are used to calculate the background for the 8th image.
Note when starting at Image 0, the first image that is masked is image 8. Afterwards, all the images are masked.
