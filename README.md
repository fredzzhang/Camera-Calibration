# Camera-Calibration

## calibrate.m
Usage: P = calibrate(pts3d, pts2d)

    pts3d - target 3d points in space [Nx3]
    pts2d - target 2d poitns in image [Nx2]
    P - 3x4 camera matrix

## test_synth.m
Perform camera calibration on synthetic data

Changeable parameters:

    theta - rotation angle of the camera [Default: random between -pi and pi]
    axis - rotation axis [Default: ramdom axis in 3d space]
    f - focal length of the camera [Default: 500mm]
    bias - biases of camera center in both x and y axis of the camera plane[Default: 0, 0]

## test_3dgrid.m
Perform camera calibration using images taken on 3d calibration grid

![Coordinate](/coord.jpg)

1. Choose target 3d points (coordinate convention explained in coord.jpg)
2. Write all target 3d points in a txt file (e.g. pts3d.txt)
3. Run the script and choose corresponding 2d points in the image by clicking them in the exact order as the 3d points

