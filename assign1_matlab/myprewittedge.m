% myprewittedge computes a binary edge image from the given image.
%
%   g = myprewittedge(Im,T,direction) computes the binary edge image from the
%   input image Im.
%   
% The function myprewittedge, with the format g=myprewittedge(Im,T,direction), 
% computes the binary edge image from the input image Im. This function takes 
% an intensity image Im as its input, and returns a binary image g of the 
% same size as Im (mxn), with 1's where the function finds edges in Im and 0's 
% elsewhere. This function finds edges using the Prewitt approximation to the 
% derivatives with the assumption that input image values outside the bounds 
% are zero and all calculations are done using double-precision floating 
% point. The function returns g with size mxn. The image g contains edges at 
% those points where the absolute filter response is above or equal to the 
% threshold T.
%   
%       Input parameters:
%       Im = An intensity gray scale image.
%       T = Threshold for generating the binary output image. If you do not
%       specify T, or if T is empty ([ ]), myprewittedge(Im,[],direction) 
%       chooses the value automatically according to the Algorithm 1 (refer
%       to the assignment descripton).
%       direction = A string for specifying whether to look for
%       'horizontal' edges, 'vertical' edges, positive 45 degree 'pos45'
%       edges, negative 45 degree 'neg45' edges or 'all' edges.
%
%   For ALL submitted files in this assignment, 
%   you CANNOT use the following MATLAB functions:
%   edge, fspecial, imfilter, conv, conv2.
%

function g = myprewittedge(Im,T,direction)
[rows, cols] = size(Im);
g = zeros(rows, cols);
index = 6;
% determine which operator to use
if strcmp(direction, 'horizontal')
    index = 1;
elseif strcmp(direction, 'vertical')
    index = 2;
elseif strcmp(direction, 'pos45')
    index = 3;
elseif strcmp(direction, 'neg45')
    index = 4;
elseif strcmp(direction, 'all')
    index = 5;
end
% do the convolution
im = my_convolution(Im, index);
% if T = [], then compute the adaptive T value
if isempty(T)
    T = self_adapted_T(im);
end
% compare with threshold
for i = 2: rows - 1
    for j = 2: cols - 1
        if im(i, j) >= T
            g(i, j) = 255;
        end
    end
end
end

% use the algorithm to compute the self-adapted T
function res = self_adapted_T(im)
[rows, cols] = size(im);
max_value = -1;
min_value = 256;
for i = 2: rows - 1
    for j = 2: cols - 1
        temp = [max_value im(i, j)];
        max_value = max(temp);
        min_value = min(temp);
    end
end
res = (max_value + min_value) / 2;
rate = 1;
while rate >= 0.05
   g1_sum = 0;
   g1_tot_num = 0;
   g2_sum = 0;
   g2_tot_num = 0;
   for i = 2: rows - 1
       for j = 2: cols - 1
           if im(i, j) >= res
               g1_sum = g1_sum + im(i, j);
               g1_tot_num = g1_tot_num + 1;
           else
               g2_sum = g2_sum + im(i, j);
               g2_tot_num = g2_tot_num + 1;
           end
       end
   end
   m1 = g1_sum / g1_tot_num;
   m2 = g2_sum / g2_tot_num;
   last_res = res;
   res = 0.5 * (m1 + m2);
   rate = abs(res - last_res) / last_res;
end
end

% do the convolution
function res = my_convolution(Im, index)
% prewitt operators
p1 = [-1 -1 -1 0 0 0 1 1 1];
p2 = [-1 0 1 -1 0 1 -1 0 1];
p3 = [-1 -1 0 -1 0 1 0 1 1];
p4 = [0 1 1 -1 0 1 -1 -1 0];
[rows, cols] = size(Im);
res = zeros(rows, cols);
for i = 2: rows - 1
    for j = 2: cols - 1
        response = 0;
        if index == 1
            response = compute_response(Im, i, j, p1);
        elseif index == 2
            response = compute_response(Im, i, j, p2);
        elseif index == 3
            response = compute_response(Im, i, j, p3);
        elseif index == 4
            response = compute_response(Im, i, j, p4);
        elseif index == 5
            r1 = compute_response(Im, i, j, p1);
            r2 = compute_response(Im, i, j, p2);
            r3 = compute_response(Im, i, j, p3);
            r4 = compute_response(Im, i, j, p4);
            r = [r1 r2 r3 r4];
            response = max(r);
        end
        res(i, j) = response;
    end
end
end

% compute response
function res = compute_response(im, r, c, p)
res = p(1) * im(r-1, c-1) + p(2) * im(r, c-1) + p(3) * im(r+1, c-1) + ...
    p(4) * im(r-1, c) + p(5) * im(r, c) + p(6) * im(r+1, c) + ...
    p(7) * im(r-1, c+1) + p(8) * im(r, c+1) + p(9) * im(r+1, c+1);
res = abs(res);
end
