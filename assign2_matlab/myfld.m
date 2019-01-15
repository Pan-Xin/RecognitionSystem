% MYFLD classifies an input sample into either class 1 or class 2.
%
%   [output_class, w, s_w, mean_c1, mean_c2] = myfld(input_sample, class1_samples, class2_samples)
%   classifies an input sample into either class 1 or class 2,
%   from samples of class 1 (class1_samples) and samples of
%   class 2 (class2_samples).
% 
% The implementation of the Fisher linear discriminant must follow the
% descriptions given in the lecture notes.
% In this assignment, you do not need to handle cases when 'inv' function
% input is a matrix which is badly scaled, singular or nearly singular.
% All calculations are done using double-precision floating point. 
%
% Input parameters:
% input_sample = an input sample
%   - The number of dimensions of the input sample is N.
%
% class1_samples = a NC1xN matrix
%   - class1_samples contains all samples taken from class 1.
%   - The number of samples is NC1.
%   - The number of dimensions of each sample is N.
%
% class2_samples = a NC2xN matrix
%   - class2_samples contains all samples taken from class 2.
%   - The number of samples is NC2.
%   - NC1 and NC2 do not need to be the same.
%   - The number of dimensions of each sample is N.
%
% Output parameters:
% output_class = the class to which input_sample belongs. 
%   - output_class should have the value either 1 or 2.
%
% w = weight vector.
%   - The vector length must be one.
%
% s_w = within-class scatter matrix
%
% mean_c1 = mean vector of Class 1 samples
%
% mean_c2 = mean vector of Class 2 samples
%
% For ALL submitted files in this assignment, 
%   you CANNOT use the following MATLAB functions:
%   mean, diff, classify, classregtree, eval, mahal.
function [output_class, w, s_w, mean_c1, mean_c2] = myfld(input_sample, class1_samples, class2_samples)
disp('--- computing process ---');
% compute the mean vector of samples
mean_c1 = get_mean_vector(class1_samples);
mean_c2 = get_mean_vector(class2_samples);
disp('The mean of class1_samples is:');
disp(mean_c1);
disp('The mean of class2_samples is:');
disp(mean_c2);

% compute the variance of samples
var_c1 = get_variance(class1_samples, mean_c1);
var_c2 = get_variance(class2_samples, mean_c2);
disp('The variance of class1_samples is:');
disp(var_c1);
disp('The variance of class2_samples is:');
disp(var_c2);

% compute the within class variance
s_w = var_c1 + var_c2;
disp('Total within class variance is:');
disp(s_w);

% compute the between class variance
diff_c = mean_c1 - mean_c2;
diff_c = diff_c';
s_b = diff_c * diff_c';
disp('Between class variance is:');
disp(s_b);

% compute the w which makes the ratio of between class variance to
% total within variance maximum
w = inv(s_w) * diff_c;
disp('The weight vector is:');
disp(w');

% compute the separation point for decision making
sep_point = 0.5 * w' * (mean_c1 + mean_c2)';
disp('The separation point is:');
disp(sep_point);

% decision making
projection = input_sample * w;
if projection > sep_point
    output_class = 1
else
    output_class = 2
end
w = w';

% show the weight before normalizing
disp('The weight vector before normalizing');
disp(w);

% normalize the weight vector
[w_row, w_col] = size(w);
w_len = 0;
for i = 1 : w_col
    w_len = w_len + w(1, i) * w(1, i);
end
w_len = sqrt(w_len);
for i = 1 : w_col
    w(1, i) = w(1, i) / w_len;
end

% show the weight after normalizing
disp('The weight vector after normalizing');
disp(w);

disp('------------------------')
return

% compute the mean vector of given samples
function res = get_mean_vector(samples)
[sample_num, dim] = size(samples);
sum_arr = zeros(1, dim);
for i = 1 : sample_num
    sum_arr = sum_arr + samples(i, : );
end
res = zeros(1, dim);
for i = 1 : dim
    res(i) = sum_arr(i) / sample_num;
end
return

% compute the variance of given samples
function res = get_variance(samples, mean_c)
[sample_num, dim] = size(samples);
res = zeros(dim, dim);
for i = 1 : sample_num
    temp = samples(i, : ) - mean_c;
    temp = temp';
    res = res + temp * temp';
end
return 







