clear; % it's always important to clear the workspace!
%cam = webcam(2); % select the USB webcam
%cam.resolution = '640x480';
vid1 = imaq.VideoDevice('kinectv2imaq', 1);

mode = 3; % Either pick 'ced' or 'scr' or 'normal' mode (options 1 and 2 and 3 below)
capture = 1; % set 1 if you want to save images

for frame = 1:150 % set the limits of the for-loop to the desired image labels
    im = imresize(step(vid1), [240 450]); 
    im = (im); % comment this out if you don't want mirrored
    
    % Normal operation
    if mode == 3
        imshow(im);
    end
    
    % Option 1: Canny Edge Detection
    if mode == 1
        gs = rgb2gray(im); % convert image to grayscale (necessary for canny)
        bw = edge(gs, 'canny'); % perform edge detection
        imshow(bw); % preview the image
    end
    
    % Option 2: Skin Colour Recognition (comment out block if not desired)
    if mode == 2
        q = rgb2ycbcr(im); % convert image to Y-Cb-Cr
        Y = q(:,:,1); % grab the Y values
        Cb = q(:,:,2); % Grab the Cb values
        Cr = q(:,:,3); % Grab the Cr values

        for i = 1:480 % iterate through image pixels (rows)
            for j = 1:640 % iterate through image pixels (columns)
                % check to see if pixel colour is within skin colour bounds
                if((Cb(i,j)>=80)&&(Cr(i,j)>=133)&&(Cb(i,j)<=120)&&(Cr(i,j)<=173)&&(Y(i,j)>=80))
                    w(i,j)=1; % make 'result pixel' white
                else
                    w(i,j)=0; % make 'result pixel' black
                end
            end
        end
        
        % perform canny on the binary skin image
        bw = edge(w, 'canny');
        imshow(q); % preview the image
    end
    
    % Option 4: RGB Skin Colour Recognition
    if mode == 4
        R = im(:,:,1);
        G = im(:,:,2);
        B = im(:,:,3);
        for i = 1:480 % iterate through image pixels (rows)
           for j = 1:640 % iterate through image pixels (columns)
               % check to see if pixel colour is within skin colour bounds
               if((R(i,j)>=210)&&(R(i,j)<=255) && (G(i,j)>=160)&&(G(i,j)<=235) && (B(i,j)>=130)&&(B(i,j)<=235))
                   w(i,j)=1; % make 'result pixel' white
               else
                   w(i,j)=0; % make 'result pixel' black
               end
           end
        end
        
        imshow(w);
    end
    
    % Choose whether to save the image or not
    if capture == 1
        filename = strcat('calib_img\penreal\Image',int2str(frame),'.png');
        imwrite(im, filename);
        pause(0.03333333); % in seconds
    end
end