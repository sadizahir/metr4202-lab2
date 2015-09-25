clear;

%CALIBRATION
% Define images to process
imageFileNames = {'C:\Users\Kate\Documents\metr4202-lab2\calib_example\Image1.png',...
    'C:\Users\Kate\Documents\metr4202-lab2\calib_example\Image2.png',...
    'C:\Users\Kate\Documents\metr4202-lab2\calib_example\Image3.png',...
    'C:\Users\Kate\Documents\metr4202-lab2\calib_example\Image4.png',...
    'C:\Users\Kate\Documents\metr4202-lab2\calib_example\Image5.png',...
    'C:\Users\Kate\Documents\metr4202-lab2\calib_example\Image6.png',...
};

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Generate world coordinates of the corners of the squares
squareSize = 20;  % in units of 'mm'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'mm');


% filename = strcat('C:\Users\Kate\Documents\metr4202-lab2\depth','.png');
% filename = strcat('C:\Users\Kate\Documents\metr4202-lab2\locate1','.png');
% filename = strcat('C:\Users\Kate\Documents\metr4202-lab2\pitch','.png');
% filename = strcat('C:\Users\Kate\Documents\metr4202-lab2\angle1','.png');
% filename = strcat('C:\Users\Kate\Documents\metr4202-lab2\multiangle','.png');
% filename = strcat('C:\Users\Kate\Documents\metr4202-lab2\roll','.png');
% filename = strcat('C:\Users\Kate\Documents\metr4202-lab2\yaw','.png');
filename = strcat('C:\Users\Kate\Documents\metr4202-lab2\allAngle','.png');


imOrig = imread(filename);

[im, newOrigin] = undistortImage(imOrig, cameraParams, 'OutputView', 'full');




%COMPUTE EXTRINSICS

% Detect the checkerboard.
[imagePoints1, boardSize1] = detectCheckerboardPoints(im);



% Compute rotation and translation of the camera.
[R, t] = extrinsics(imagePoints1, worldPoints, cameraParams);

worldPoints1 = pointsToWorld(cameraParams, R, t, imagePoints1);


% point = 5;
% centreWorld = pointsToWorld(cameraParams, R, t, worldPoints(point,:));





% angles = zeros(8, 1);

% Get the world point for each checkboard point
wldP1 = [worldPoints1(1,:) 0];
wldP2 = [worldPoints1(5,:) 0];

wldP3 = [worldPoints1(6,:) 0];
wldP4 = [worldPoints1(10,:) 0];

wldP5 = [worldPoints1(11,:) 0];
wldP6 = [worldPoints1(15,:) 0];

wldP7 = [worldPoints1(16,:) 0];
wldP8 = [worldPoints1(20,:) 0];

wldP9 = [worldPoints1(21,:) 0];
wldP10 = [worldPoints1(25,:) 0];

wldP11 = [worldPoints1(26,:) 0];
wldP12 = [worldPoints1(30,:) 0];

wldP13 = [worldPoints1(31,:) 0];
wldP14 = [worldPoints1(35,:) 0];

wldP15 = [worldPoints1(36,:) 0];
wldP16 = [worldPoints1(40,:) 0];


%Get the position relative to the camera
camWld1 = wldP1*R + t;
camWld2 = wldP2*R + t;
camWld3 = wldP3*R + t;
camWld4 = wldP4*R + t;
camWld5 = wldP5*R + t;
camWld6 = wldP6*R + t;
camWld7 = wldP7*R + t;
camWld8 = wldP8*R + t;
camWld9 = wldP9*R + t;
camWld10 = wldP10*R + t;
camWld11 = wldP11*R + t;
camWld12 = wldP12*R + t;
camWld13 = wldP13*R + t;
camWld14 = wldP14*R + t;
camWld15 = wldP15*R + t;
camWld16 = wldP16*R + t;

% Get the Pitch Angle - X (Y)
angleP1 = asind((abs(camWld1(3)-camWld15(3)))/140);
angleP2 = asind((abs(camWld2(3)-camWld16(3)))/140);
pitch = (angleP1+angleP2)/2

% Get the Roll Angle - Y
angleR1 = asind((abs(camWld1(3)-camWld2(3)))/80);
angleR2 = asind((abs(camWld15(3)-camWld16(3)))/80);
roll = (angleR1+angleR2)/2

%Get the Yaw Angle - Z
angleY1 = atand(abs(abs(camWld1(2))-abs(camWld2(2)))/(abs(abs(camWld1(1))-abs(camWld2(1)))));
angleY2 = atand(abs(abs(camWld15(2))-abs(camWld16(2)))/(abs(abs(camWld15(1))-abs(camWld16(1)))));
angleY3 = atand(abs(abs(camWld9(2))-abs(camWld10(2)))/(abs(abs(camWld9(1))-abs(camWld10(1)))));
angleY4 = atand(abs(abs(camWld5(2))-abs(camWld6(2)))/(abs(abs(camWld5(1))-abs(camWld6(1)))));
yaw = (angleY1+angleY2+angleY3+angleY4)/4

iP = [imagePoints1(36,:); imagePoints1(40,:)];

% imshow(insertMarker(im, imagePoints1(5,:)));

%Get frame origin co-ordinate
imagePoints1(1,1)
cX = imagePoints1(1,1)- 40%hypot(20, 20)*sind(yaw)
corner = [cX, imagePoints1(1,2)+40];



worldCorner = pointsToWorld(cameraParams, R, t, corner);
wldPC = [worldCorner 0];
camWldC = wldPC*R + t;
x = camWldC(3); % x is the depth (z in world co-ordinates)
y = camWldC(1); % y is the horizontal value (x in world co-ordinates)
z = camWldC(2); % z is the vertical value (y in world co-ordinates)

CentralFrame = [camWldC(3), camWldC(1), camWldC(2)];
fprintf('x: %g, y: %g, z: %g. Pitch: %g, Roll: %g, Yaw: %g\n', x,y,z,pitch,roll,yaw);

imshow(insertMarker(im, imagePoints1));
