clear all;
close all;
% Create a cascade detector object.
handDetector = vision.CascadeObjectDetector('D:\tracker2\hand_detector.xml','MergeThreshold',20);

INPUT_LIMITS = [0 0 0; .8 .8 0.5];
OUTPUT_LIMITS = []; %[0.2 0.2 0.2; 1 1 1]

GAMMA = 1;

% Read a video frame from CAM and run the detector.
cam = webcam;
videoFrame = (snapshot(cam)); % comment out if you don't want mirror image  
%videoFrame = imadjust(videoFrame1,INPUT_LIMITS,OUTPUT_LIMITS,GAMMA);

bbox = step(handDetector, videoFrame); % grab the bounding box for a possible region with hand in it
frameSize = size(videoFrame);

% Read a video frame and run the detector from PC
%videoFileReader = vision.VideoFileReader('C:\MATLAB\R2015a\twoheads.avi');
%videoFrame      = step(videoFileReader);
%bbox            = step(handDetector, videoFrame);

% Draw the returned bounding box around the detected face.
videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');
figure, imshow(videoOut), title('Detected face');

% Get the skin tone information by extracting the Hue from the video frame
% converted to the HSV color space
[hueChannel,~,~] = rgb2hsv(videoFrame)

N =size(bbox)

Num_of_BBox = N(1);

% Display the Hue Channel data and draw the bounding box around the face.
figure, imshow(hueChannel), title('Hue channel data');

for i = 1:Num_of_BBox
    rectangle('Position',bbox(i,:),'LineWidth',2,'EdgeColor',[1 1 0])
    
    % Detect the nose within the face region. The nose provides a more accurate
    % measure of the skin tone because it does not contain any background
    % pixels.
    palmDetector = vision.CascadeObjectDetector('D:\tracker2\palm_detector.xml','MergeThreshold',2, 'UseROI', true); %'D:\tracker2\palm_detector.xml'
    %palmBBox(i)  = 
    step(palmDetector, videoFrame, bbox(i,:));
    
    % Create a tracker object.
    tracker{i} = vision.HistogramBasedTracker;
    
    % Initialize the tracker histogram using the Hue channel pixels from the
    % nose.
    initializeObject(tracker{i}, hueChannel, bbox(i,:),20);
end

% Create the video player object. (from CAM)
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);

% Create a video player object for displaying video frames. (from PC)
%videoInfo    = info(videoFileReader);
%videoPlayer  = vision.VideoPlayer('Position',[300 300 videoInfo.VideoSize+30]);

% Track the face over successive video frames until the video is finished.
% (from PC)
%while ~isDone(videoFileReader)

% Track the face over successive video frames until the video is finished.
% (from CAM)
while true

    % Extract the next video frame (from cam)
    videoFrame = (snapshot(cam));
    
    %videoFrame = imadjust(videoFrame1,INPUT_LIMITS,OUTPUT_LIMITS,GAMMA);
 
    % Extract the next video frame (from PC)
   % videoFrame = step(videoFileReader);
        
    % RGB -> HSV
    [hueChannel,~,~] = rgb2hsv(videoFrame);
    
    % RGB -> LAB
    %lab = rgb2lab(videoFrame);
    %hueChannel1 = LABhistogram(lab);
    
    for i = 1:Num_of_BBox
     % Track using the Hue channel data
     bbox(i,:) = step(tracker{i}, hueChannel);
     % Insert a bounding box around the object being tracked
        videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox, 'Hand');
    end
    
    % Display the annotated video frame using the video player object
    step(videoPlayer, videoOut);
end

% Release resources
release(videoFileReader);
release(videoPlayer);