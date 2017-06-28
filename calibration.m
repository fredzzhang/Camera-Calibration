function P = calibration(vec4, vec3)
% -------------------------------------------------------------------------
% Function Introdution:
% Given a set of correspondences between two images and the intrisic matrix
% of the calibrated camera for both views, extract the relatvie pose
% directly using five points

% Inputs:
% vec4 - the homogeneous coordinates of points in space(4xN)
% vec3 - the homogeneous coordinates of projected 2D points on a plane(3xN)

% Outputs:
% P - the 3x4 camera matrix

% Function flow
% Error check
% Apply DLT and construct coefficient matrix
% Extract solution from null space
% Format soltution

% Author: Frederic Zhang
% Last modified: 22 June 2017
% Version: 1.0
% -------------------------------------------------------------------------

% Error check
[c4, n4] = size(vec4);
[c3, n3] = size(vec3);

if(c4 ~= 4)
    error('Incorrect format of 3D points.');
elseif(c3 ~= 3)
    error('Inccorect format of 2D points.');
elseif((n4 < 6) || (n3 < 6))
    error('Insufficient number of points to recover camera matrix.');
end

% Construct matrix A
% [0', -wX', yX';
%  wX', 0', -xX'];
A = zeros(12, 12);
for num = 1: 6
    A(num * 2 - 1: num * 2, :) = [zeros(1, 4), ...
        -vec3(3, num) * transpose(vec4(:, num)), ...
        vec3(2, num) * transpose(vec4(:, num)); ...
        vec3(3, num) * transpose(vec4(:, num)), ...
        zeros(1, 4), ...
        -vec3(1, num) * transpose(vec4(:, num))];
end

% Extract camera matrix from null space
[~, ~, V] = svd(A);
p = V(:, 12);

% Format camera matrix
mask = [1, 2, 3, 4; ...
        5, 6, 7, 8; ...
        9, 10, 11, 12];

P = p(mask);

end