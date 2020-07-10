To use our project please follow the following steps:

Inside the folder G21 you will find the file config.
Edit the following to successfully run the challenge:

src: Replace this variable with the folder where you have the Scene you want to mask.
example: src = "C:\User\Documents\P1E_S1"
Note: please be sure to select the folder at that level and that it has the corresponding
*_C1, *_c2, and *_C3 folders inside and nothing else. Otherwise, it may lead to errors.

L: Replace this value with 1 or 2.
R: Replace this value with 2 or 3.

start: select the start value here, take into consideration that if you select a
start value bigger than the amount of files in the folder, the program will show an error.

bg: You can select here the background to be used in the substitute mode and the bonus mode(video).
Replace these paths with the paths where your image and/or video is located.
example: "C:\User\Pictures\bg.jpg"
example video: "C:\User\Videos\bgvideo.mp4"

To run the program then just open the challenge.m file and click on Run.
You can also type from the command: challenge.mask and then press enter.
example: >>challenge.m


***************************************************************************************************
Using the GUI: 
The GUI has different parameters that can be chosen by the user, these are:
	* Scene Folder: Select the Scene folder as in src above.
	* Virtual Background: Select the jpg or png image you want to use for the background.
	* Output Folder: This will work as the store variable, if the user selects a folder, then
					 the generated video will be stored there.
	* Video Name: Select a name for the created video.
	* Mode: Select from the five modes possible: foreground, background, substitute, overlay and bonus.
	* Start at image: Select the image where the program will start from.
	* Loop Video: Checkbox to loop the video.

To run the program then click on the Start button and it will begin.
The user can stop the program at any time by clicking on Stop
