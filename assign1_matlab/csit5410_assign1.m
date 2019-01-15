% CSIT5410_ASSIGN1.m contains the main routine for CSIT5410 assignment 1.
%
%   CSIT5410_ASSIGN1(FILENAME) takes a gray scale image with filename FILENAME.
%   This routine completes the following tasks:
%
%   TASK 1: An image specified by FILENAME is read and displayed.
%   TASK 2: The corresponding binary edge image with a given threshold T is 
%           computed and displayed.
%   TASK 3: The corresponding binary edge image with the automatic threshold 
%           is computed and displayed.
%   TASK 4:  Longest line segment extraction based on Hough transform.
%   TASK 5: Image Alignment using SIFT.
%
%   REMINDER: Please feel free to modify this file to meet the requirement of the assignment.
%
function csit5410_assign1(FILENAME)

%
% TASK 1
%
% Read the image.
disp('======================= TASK 1 ==========================')
Im = im2double(imread(FILENAME));
% Show the image in a new window.
figure('Name', 'Task 1'), imshow(Im);
% save the image
imwrite(Im, '01original.jpg');
disp('*** Task 1 result has been saved as 01original.jpg ***')
disp('Original image is read and displayed successfully.');


%
% TASK 2
%
% Generate the corresponding binary edge image of the given image Im.
disp('======================= TASK 2 ==========================')
T = double(max(max(Im)))*0.2;
direction = 'all';
g = myprewittedge(Im,T,direction);
% Show the image in a new window.
figure('Name', 'Task 2'), imshow(g);
% save as an uint8 file
imwrite(uint8(g), '02binary1.jpg');
disp('*** Task 2 result has been saved as 02binary1.jpg ***')
disp('The corresponding binary edge image is computed and displayed successfully.');


%
% TASK 3
% Generate the corresponding binary edge image of the given image Im
% without specifying the threshold
disp('======================= TASK 3 ==========================')
direction = 'all';
f = myprewittedge(Im,[],direction);
% Show the image in a new window.
figure('Name', 'Task 3'), imshow(f);
% save as an uint8 file
imwrite(uint8(f), '03binary2.jpg')
disp('*** Task 3 result has been saved as 03binary2.jpg ***')
disp('The corresponding binary edge image is computed and displayed successfully.');

% TASK 4
% Find the longest line segment based on Hough transform.
disp('======================= TASK 4 ==========================')
figure('Name', 'Task 4'); imshow(Im, [min(min(Im)) max(max(Im))]), hold on
[x, y] = mylineextraction(f);
% Plot the line in the image

plot([x(1) y(1)], [x(2) y(2)],'LineWidth',2,'Color','blue');
plot(x(1),x(2),'x','LineWidth',2,'Color','red');
plot(y(1),y(2),'x','LineWidth',2,'Color','red');
hold off
disp('*** Task 4 result has been saved as 04longestline.jpg ***')
saveas(gcf, '04longestline.jpg')
%
% TASK 5
%
% Find the image which matches image I best.
disp('======================= TASK 5 ==========================')
I = double(imread('QR-Code.png'));
% 3 candidate images for matching.
I1 = double(imread('image1.png'));
I2 = double(imread('image2.png'));
I3 = double(imread('image3.png'));
n=findBestMatching(I,I1,I2,I3);
% save the output images
saveas(6, '05QR_img1.png');
saveas(8, '06QR_img2.png');
saveas(10, '07QR_img3.png');
disp('*** Task 5 result has been saved ***')
fprintf('The image matches QR-code.jpg best is image%d.jpg\n', n);

