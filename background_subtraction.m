%% ECE 4950 Fall 2020 Project 2 Demo - Image Processing
clear all
close all
clc
%% Read in Original and Background Images
Image_Orig = imread('StickersWithNoise.png');
Image_Background = imread('NoiseBackground.png');
[height,width,depth] = size(Image_Orig);
[height_b,width_b,depth_b] = size(Image_Background);

figure();
imshow(Image_Orig);
title('Original Image');

figure();
imshow(Image_Background);
title('Background Image');

%% Compute Background Subtraction
% Notes:
% This step is not required but helps with noisy images
% Save a background.png so you do not have to take a new image every run
Image_BackgroundSub = Image_Background - Image_Orig;
figure();
imshow(Image_BackgroundSub);
title('Background Subtraction Image');

%% Compute Binary Image for imageprops
Image_Binary = im2bw(Image_BackgroundSub);
figure();
imshow(Image_Binary);
title('Binary Background Subtraction Image (Broken)');
% Check the image, notice blue stickers have ben classified as background

%% Fix Image to Compute Binary Image
Image_BackgroundSub2 = Image_BackgroundSub;
for i=1:height
    for j=1:width
        if (Image_BackgroundSub(i,j,1) > 2) || ...
           (Image_BackgroundSub(i,j,2) > 2) || ...
           (Image_BackgroundSub(i,j,3) > 2)
            
            %Will Show in Green
            Image_BackgroundSub2(i,j,:) = [175,200,175];
        end
    end
end

figure();
imshow(Image_BackgroundSub2);
title('Background Subtraction Image (New)');

Image_Binary2 = im2bw(Image_BackgroundSub2);
figure();
imshow(Image_Binary2);
title('Binary Background Subtraction Image (Fixed)');

%% Erode Image
% Set Morphological Operation
SE = strel('disk',20);

Image_Erode = imerode(Image_Binary2, SE);
figure();
imshow(Image_Erode);
title('Binary Image Erosion');

%% Dilate Image
% Set Morphological Operation
SE = strel('disk',20);

Image_Dilate = imdilate(Image_Binary2, SE);
figure();
imshow(Image_Dilate);
title('Binary Image Dilate');

%% Call regionprops 
STATS = regionprops(Image_Binary2, 'all')

%% Print overlay
figure();
imshow(Image_Orig)
hold on;

items = size(STATS);
for i = 1:items
    plot(STATS(i).Centroid(1),STATS(i).Centroid(2),'kO','MarkerFaceColor','k');
end

title('Original Image with Centroid Dots');










