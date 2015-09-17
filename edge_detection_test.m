% I = imread('calib_example/002.jpg');
% J = rgb2gray(I);
% B = edge(J, 'canny');
% imshow(B);

clear;
cam = webcam(2);
cam.resolution = '640x480';

for mmm = 400:450
    im = fliplr(snapshot(cam));
%     j = rgb2gray(im);
%     b = edge(j, 'canny');
%     imshow(b);
    
%     q = rgb2ycbcr(im);
%     a = q(:,:,2);
%     b = q(:,:,3);
%     
%     for i = 1:480
%         for j = 1:640
%             if((a(i,j)>=80)&&(b(i,j)>=133)&&(a(i,j)<=120)&&(b(i,j)<=173))
%                 w(i,j)=1;
%             else
%                 w(i,j)=0;
%             end
%         end
%     end
%                 
%     b = edge(w, 'canny');
%     imshow(b);
    filename = strcat('C:\Users\Sadi\github\metr4202-lab2\calib_example\HandColour\Image',int2str(mmm),'.png');
    imshow(im);
    imwrite(im, filename);
    pause(0.1);
end