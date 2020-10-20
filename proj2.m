%% ECE 4950 Fall 2020 Project 2 Demo - Image Processing
clear all
close all
clc

%% Check Camera List (may have to install MATLAB package)
cam_list = webcamlist
cam_name = cam_list{1};
cam = webcam(cam_name);
preview(cam)

%% Read in rectangle reference point template
rect = imread('rectangleReferencePoint.png');

%% Take Snapshot
x = input('Hit enter to take original image\n');
closePreview(cam)
[Image_Orig, img] = snapshot(cam);
preview(cam)

%% Use rectangle template to get well locations

%% Take another snapshot
x = input('Hit enter to take original image\n');
closePreview(cam)
[Image_Background, img2] = snapshot(cam);

%% Read in Original and Background Images
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
Image_BackgroundSub = Image_Orig - Image_Background;
figure();
imshow(Image_BackgroundSub);
title('Background Subtraction Image');

%% Compute Binary Image for imageprops
%Image_Binary = im2bw(Image_BackgroundSub);
%figure();
%imshow(Image_Binary);
%title('Binary Background Subtraction Image (Broken)');

%[centers, radii, metric] = imfindcircles(Image_Binary, [5 35]);

%viscircles(centers, radii, 'EdgeColor', 'b')


%% Fix Image to Compute Binary Image
Image_BackgroundSub2 = Image_BackgroundSub;
% complement = imcomplement(Image_BackgroundSub);
% figure();
% imshow(complement);
title('Background Subtraction Image (Inverted)');
for i=1:height
    for j=1:width
        if (Image_BackgroundSub(i,j,1) > 35) || ...
           (Image_BackgroundSub(i,j,2) > 35) || ...
           (Image_BackgroundSub(i,j,3) > 35) 
            
            % Will Show in Green
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
SE = strel('disk',3);

Image_Erode = imerode(Image_Binary2, SE);
figure();
imshow(Image_Erode);
title('Binary Image Erosion');

%% Dilate Image
% Set Morphological Operation
SE = strel('disk',7);

Image_Dilate = imdilate(Image_Erode, SE);
figure();
imshow(Image_Dilate);
title('Binary Image Dilate');

%% Call regionprops 
STATS = regionprops(Image_Dilate, 'all')
% 
% %% Print overlay
figure();
imshow(Image_Background)
hold on;
% 
items = size(STATS);
numWashers = 0;
for i = 1:items
    %fprintf('Perimeter: %f \t', STATS(i).Perimeter(1));
    %fprintf('Circularity: %f -->', STATS(i).Circularity(1));
    if STATS(i).Circularity(1) > 0.65
        if STATS(i).Perimeter(1) > 75 && STATS(i).Perimeter(1) < 150
            %fprintf(' Circle :)\n');
            numWashers = numWashers + 1;
            x = round(STATS(i).Centroid(1));
            y = round(STATS(i).Centroid(2));
            red = round(Image_Background(y, x, 1));
            green = round(Image_Background(y, x, 2));
            blue = round(Image_Background(y, x, 3));

            pixelAtCentroid = [red, green, blue];
            [intensity, color] = max(pixelAtCentroid);

            if color == 1
                if abs(intensity - green) < 20
                   colorStr = 'y'; 
                else
                    colorStr = 'r';
                end
            elseif color == 2
                if abs(intensity - red) < 20
                   colorStr = 'y'; 
                else
                    colorStr = 'g';
                end
            else
                colorStr = 'b';
            end
            %fprintf('%s\n', colorStr);
            plot(STATS(i).Centroid(1),STATS(i).Centroid(2),'kO','MarkerFaceColor', colorStr);

            fprintf('Washer location: (%d, %d)\n', x, y);
            fprintf('Washer color: %s\n', colorStr);
        else
            %fprintf(' No Circle :(\n');
            plot(STATS(i).Centroid(1),STATS(i).Centroid(2),'kO','MarkerFaceColor','w');
        end
    else
        %fprintf(' No Circle :(\n');
        plot(STATS(i).Centroid(1),STATS(i).Centroid(2),'kO','MarkerFaceColor','k');
    end 
end
% 
title('Original Image with Centroid Dots');

fprintf('Washers: %d\n', numWashers);