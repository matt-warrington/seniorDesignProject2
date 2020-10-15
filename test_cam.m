%% ECE 4950 Fall 2020 Project 2 Demo - Camera Setup
close all
clc
clear
clear('cam')
%% Check Camera List (may have to install MATLAB package)
cam_list = webcamlist

%% Assign webcam to be used
% Pick an index from the camera list above
cam_name = cam_list{1}

%% Check webcam properties
cam = webcam(cam_name)

%% Preview cam
preview(cam)

%% Close Preview
closePreview(cam)

%% Snapshot 1
img = snapshot(cam);

figure();
imshow(img)
title('Snapshot 1')

%% Snapshot 2
img2 = snapshot(cam);

figure();
imshow(img2)
title('Snapshot 2')






