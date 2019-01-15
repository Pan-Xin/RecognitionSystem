function [bp, ep] = mylineextraction(BW)
%   The function extracts the longest line segment from the given binary image
%       Input parameter:
%       BW = A binary image.
%
%       Output parameters:
%       [bp, ep] = beginning and end points of the longest line found
%       in the image.
%
%   You may need the following predefined MATLAB functions: hough,
%   houghpeaks, houghlines.

PEAK_NUM = 8;
% do hough transform 
[hspace, angles, dists] = hough(BW);
% choose top PEAK_NUM peaks
peaks = houghpeaks(hspace, PEAK_NUM);
% find the start point and end point of each line
lines = houghlines(BW, angles, dists, peaks);

% find the longest line
max_len = 0;
for i = 1: length(lines)
    p1 = lines(i).point1;
    p2 = lines(i).point2;
    len = (p1(1) - p2(1))^2 + (p1(2) - p2(2))^2;
    if len > max_len
        bp = p1;
        ep = p2;
        max_len = len;
    end
end
end


