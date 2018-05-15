function P = calibrate(pts3d, pts2d)
% -------------------------------------------------------------------------
% Function Introdution:
% Given a set of 2D and 3D point correspondences, perform normalized DLT
% algorithm to compute camera matrix
% 
%       Usage: 
%           P = calibration(pts3d, pts2d)
% 
%       where:
%           pts3d - target 3d points in space [N x 3]
%           pts2d - target 2d points in space [N x 2]
%           P - the 3x4 camera matrix
% 
% Function flow
% - Input check
% - Reformat and normalize input points
% - Apply DLT and construct coefficient matrix
% - Extract solution from null space using least squares
% - Denormalize and reformat soltution
% 
% Author: Frederic Zhang
% Last modified: 13 May 2018
% Version: 2.0
% -------------------------------------------------------------------------

% Input check
[nrow1, ncol1] = size(pts3d);
[nrow2, ncol2] = size(pts2d);

if(ncol1 ~= 3) && (ncol1 ~= 4)
    error('Incorrect format of 3D points. Use [N x 3] matrix');
elseif(ncol2 ~= 2) && (ncol2 ~= 3)
    error('Inccorect format of 2D points. Use [N x 2] matrix');
elseif((nrow1 < 6) || (nrow2 < 6))
    error('Insufficient number of points to recover camera matrix.');
elseif(nrow1 ~= nrow2)
    error('Imbalanced number of 3D and 2D points.');
end

% Reformat data
if ncol1 == 3
    pts3d = [pts3d, ones(nrow1, 1)];
end
if ncol2 == 2
    pts2d = [pts2d, ones(nrow1, 1)];
end

% Get normalization matrix
T = getNormMat2d(pts2d');
S = getNormMat3d(pts3d');

% Normalize the input points
pts3d = transpose(S * pts3d');
pts2d = transpose(T * pts2d');

% Construct matrix A
% [0', -wX', yX';
%  wX', 0', -xX'];
A = zeros(12, 12);
for num = 1: nrow1
    A(num * 2 - 1: num * 2, :) = ...
        [zeros(1, 4), -pts3d(num, :), pts2d(num, 2) * pts3d(num, :); ...
        pts3d(num, :), zeros(1, 4), -pts2d(num, 1) * pts3d(num, :)];
end

% Solve camera matrix with least squares
[~, Sig, V] = svd(A);
% Get the smallest singular value
singVal = diag(Sig);
[~, ind] = min(singVal);
% Get the corresponding right-singular vector
p = V(:, ind);

% Format camera matrix
mask = [1, 2, 3, 4; ...
        5, 6, 7, 8; ...
        9, 10, 11, 12];

% Denormalize
P = T \ (p(mask) * S);


end