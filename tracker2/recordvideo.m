aviObject = avifile('myVideo.avi');   % Create a new AVI file
cam = webcam

for iFrame = 1:100                    % Capture 100 frames
  I - snapshit(cam);
  F = im2frame(I);                    % Convert I to a movie frame
  aviObject = addframe(aviObject,F);  % Add the frame to the AVI file
end
aviObject = close(aviObject);         % Close the AVI file