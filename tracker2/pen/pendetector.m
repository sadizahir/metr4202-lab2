clear all;
cam = webcam

I = snapshot(cam)

BW  = rgb2gray(I);
Edge = edge(BW,'canny');
SE = strel('rectangle',[0 0]);
%Edge = imerode(Edge,SE);
imshow(Edge);
[H,T,R] = hough(Edge,'RhoResolution',0.5,'ThetaResolution',0.5)



    