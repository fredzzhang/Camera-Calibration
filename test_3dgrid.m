% -------------------------------------------------------------------------
% Test camera calibration algorithm
% -------------------------------------------------------------------------
% Institute: Australian National University
% Author: Zhen Zhang
% Uid: u6127359
% Last modified: 17 May 2018
%% ------------------------------------------------------------------------
close all;
clear;
clc;

strImg = 'images/stereo2012a.jpg';      % prepare path for input image
srcImg = imread(strImg);                % load input image
npoint = 12;                            % number of target points used

imshow(srcImg);
[x, y] = ginput(npoint);                % get the 2d points
close;

uv = [x, y];

XYZ = dlmread('pts3d.txt');             % read 3d data

% Compute camera matrix
P = calibrate(XYZ, uv);
% Decompose the camera matrix
[K, R, t] = vgg_KR_from_P(P);

% Display the camera matrix
disp('Camera Matrix:');
disp(P);
% Display the intrinsic matrix
disp('Intrinsic Matrix:');
disp(K);

%% ------------------------------------------------------------------------