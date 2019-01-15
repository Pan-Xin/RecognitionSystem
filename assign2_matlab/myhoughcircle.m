function [y0detect,x0detect,Accumulator] = houghcircle(Imbinary,r,thresh)
%HOUGHCIRCLE - detects circles with specific radius in a binary image.
%
%Comments:
%       Function uses Standard Hough Transform to detect circles in a binary image.
%       According to the Hough Transform for circles, each pixel in image space
%       corresponds to a circle in Hough space and vice versa. 
%       upper left corner of image is the origin of coordinate system.
%
%Usage: [y0detect,x0detect,Accumulator] = houghcircle(Imbinary,r,thresh)
%
%Arguments:
%       Imbinary - a binary image. image pixels that have value equal to 1 are
%                  interested pixels for HOUGHLINE function.
%       r        - radius of circles.
%       thresh   - a threshold value that determines the minimum number of
%                  pixels that belong to a circle in image space. threshold must be
%                  bigger than or equal to 4(default).
%
%Returns:
%       y0detect    - row coordinates of detected circles.
%       x0detect    - column coordinates of detected circles. 
%       Accumulator - the accumulator array in Hough space.

if nargin == 2
    thresh = 4;
elseif thresh < 4
    error('treshold value must be bigger or equal to 4');
    return
end

% Voting
[tot_rows, tot_cols] = size(Imbinary); % get the image shape
acc = zeros(tot_rows, tot_cols); % initialize the accumulator array

for i = 1 : tot_rows
    for j = 1 : tot_cols
        if Imbinary(i, j) == 1 % current pixel is on the edge
           points = []; % record points which are on the circumference
           cont = 0;
           for t = 0 : 360 % traversing by angle from 0 to 360 degree
               angle = t * pi / 180;
               % calculate the coordinates of points on the circumference
               t_row = floor(i + r * cos(angle));
               t_col = floor(j + r * sin(angle));
               if t_row > 0 && t_row <= tot_rows % legal points
                   if t_col > 0 && t_col <= tot_cols
                       cont = cont + 1;
                       points(cont, : ) = [t_row, t_col];
                   end
               end
           end
           points = unique(points, 'rows'); % remove duplicate points
           [row_num, col_num] = size(points);
           for t = 1 : row_num
               t_row = points(t, 1);
               t_col = points(t, 2);
               acc(t_row, t_col) = acc(t_row, t_col) + 1; % voting
           end
        end
    end
end

% Finding local maxima in Accumulator
cont = 0;
circle_rows = [];
circle_cols = [];
max_acc = 0; % record maxium accumulator and its position
max_x = 0;
max_y = 0;
for i = 1 : tot_rows
    for j = 1 : tot_cols
        if acc(i, j) > thresh
            cont = cont + 1;
            circle_rows(cont) = i;
            circle_cols(cont) = j;
        end
        if acc(i, j) > max_acc
            max_x = i;
            max_y = j;
            max_acc = acc(i, j);
        end
    end
end

% if can not find a pixel which accumulator value is larger than threshold
% then return the pixel which has the maximum accumulator value
if cont == 0
    circle_rows(1) = max_x;
    circle_cols(1) = max_y;
end

% return results
y0detect = circle_rows;
x0detect = circle_cols;
Accumulator = acc;