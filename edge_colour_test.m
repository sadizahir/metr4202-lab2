clear; % it's always important to clear the workspace!
cam = webcam(2); % select the USB webcam
cam.resolution = '640x480';
mode = 2; % Either pick 'ced' or 'scr' mode (options 1 and 2 below)
capture = 0; % set 1 if you want to save images

for frame = 1:1000 % set the limits of the for-loop to the desired image labels
    im = snapshot(cam); 
    im = fliplr(im); % comment this out if you don't want mirrored
    
    % Option 1: Canny Edge Detection
    if mode == 1
        gs = rgb2gray(im); % convert image to grayscale (necessary for canny)
        bw = edge(gs, 'canny'); % perform edge detection
        imshow(bw); % preview the image
    end
    
    % Option 2: Skin Colour Recognition (comment out block if not desired)
    if mode == 2
        q = rgb2ycbcr(im); % convert image to Y-Cb-Cr
        Cb = q(:,:,2); % Grab the Cb values
        Cr = q(:,:,3); % Grab the Cr values

        for i = 1:480 % iterate through image pixels (rows)
            for j = 1:640 % iterate through image pixels (columns)
                % check to see if pixel colour is within skin colour bounds
                if((Cb(i,j)>=80)&&(Cr(i,j)>=133)&&(Cb(i,j)<=120)&&(Cr(i,j)<=173))
                    w(i,j)=1; % make 'result pixel' white
                else
                    w(i,j)=0; % make 'result pixel' black
                end
            end
        end
        
        imshow(q); % preview the image
    end
    
    % Choose whether to save the image or not
    if capture == 1
        filename = strcat('sample\Image',int2str(frame),'.png');
        imwrite(im, filename);
        pause(0.1); % in seconds
    end
end