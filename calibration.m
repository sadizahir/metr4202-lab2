% Auto-generated by cameraCalibrator app on 10-Sep-2015
%-------------------------------------------------------
clear; 
%cam = webcam(2); % assign webcam
vid1 = imaq.VideoDevice('kinectv2imaq', 1);
NoOfImage = 30; % number of images

%image_capture = zeros(1, 5, NoOfImage, uint8); % set image array

preview(vid1);

for i = 1:NoOfImage
    image_capture = imresize(fliplr(step(vid1)), [240 450]);  % take camera shot
    filename = strcat('C:\Users\Sadi\github\metr4202-lab2\calib_example\Image',int2str(i),'.png')
    imwrite(image_capture,filename)
    pause(0.333333); % wait 1 second
end


release(vid1);

% Define images to process
imageFileNames = {'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image1.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image2.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image3.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image4.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image5.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image6.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image7.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image8.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image9.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image10.png'...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image11.png',...
        'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image12.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image13.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image14.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image15.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image16.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image17.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image18.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image19.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image20.png'...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image21.png',...
        'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image22.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image23.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image24.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image25.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image26.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image27.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image28.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image29.png',...
    'C:\Users\Sadi\github\metr4202-lab2\calib_example\Image30.png'...
    };

% imageFileNames = {'C:\Users\Sadi\github\metr4202-lab2\calib_example\image1.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image2.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image3.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image4.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image5.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image6.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image7.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image8.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image9.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image10.jpg'...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image11.jpg',...
%         'C:\Users\Sadi\github\metr4202-lab2\calib_example\image12.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image13.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image14.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image15.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image16.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image17.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image18.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image19.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image20.jpg'...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image21.jpg',...
%         'C:\Users\Sadi\github\metr4202-lab2\calib_example\image22.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image23.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image24.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image25.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image26.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image27.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image28.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image29.jpg',...
%     'C:\Users\Sadi\github\metr4202-lab2\calib_example\image30.jpg'...
%     };

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Generate world coordinates of the corners of the squares
squareSize = 15;  % in units of 'mm'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'mm');

% View reprojection errors
h1=figure; showReprojectionErrors(cameraParams, 'BarGraph');

% Visualize pattern locations
h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
originalImage = imread(imageFileNames{1});
undistortedImage = undistortImage(originalImage, cameraParams);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('SparseReconstructionExample')




% imOrig = imread('C:\Users\Sadi\github\metr4202-lab2\calib_example\Original.png');
% 
% [im, newOrigin] = undistortImage(imOrig, cameraParams, 'OutputView', 'full');




%COMPUTE EXTRINSICS

% Detect the checkerboard.
% [imagePoints1, boardSize1] = detectCheckerboardPoints(im);
% 
% 
% 
% % Compute rotation and translation of the camera.
% [R, t] = extrinsics(imagePoints1, worldPoints, cameraParams);
% 
% worldPoints1 = pointsToWorld(cameraParams, R, t, imagePoints1);

save('cal.mat', 'cameraParams', 'worldPoints');


% 
% 
% %Compute Extrinsics
% [R, t] = extrinsics(imagePoints, worldPoints, cameraParams);
