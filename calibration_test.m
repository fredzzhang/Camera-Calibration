clear all;
close all;
clc;
% -------------------------------------------------------------------------
% Program flow
% Randomly generate a camera matrix
% Randomly generate a set of points in space
% Project the 3D points onto the plane
% Compute the camera matrix using the 2D points obtained
% Evaluate error

% Author: Frederic Zhang
% Last modified: 22 June 2017
% Version: 1.0
% -------------------------------------------------------------------------

% Intrinsic matrix
K = eye(3);

% Rotation angle
thetad = (rand(1) - 0.5) * 360;     % random rotation angle -180~180
theta = thetad * pi / 180;          % rotation angle in radians

% Rotation axis
axis = rand(1, 3);

% Normalize the vector
axis = axis / sqrt(axis(1) ^ 2 + axis(2) ^ 2 + axis(3) ^ 2);    

% Corss product of rotaion vector
v = [0, -axis(3), axis(2); axis(3), 0, -axis(1); -axis(2), axis(1), 0];  
% Rotation matrix according to Rodrigues' Formula
R = eye(3, 3) + sin(theta) * v + (1 - cos(theta)) * v * v;  

% Translation vector
t = [(rand(2, 1) - 0.5) / 10; 1];

% Projection matrix
P = K * [R, t];

% 3D points generation
X = rand(4, 6);

% Projection
x = P * X;

% Reformat points
X = X ./ repmat(X(4, :), 4, 1);
X = X(1: 3, :);
x = x ./ repmat(x(3, :), 3, 1);
x = x(1: 2, :);


% Compute camera matrix
Pcal = calibrate(X', x');

% Normalize the last element
Pcal = Pcal / Pcal(3, 4);

% Compare with ground truth
disp('The ground truth of camera matrix is');
disp(P);
disp('The computed camera matrix after calibration is');
disp(Pcal);