function result = is_skin(im, bbox)
% Works out of the majority of a bbox in an image (im) is within the skin
% colour threshold

% bounding box format: (top-left-x, top-left-y, width, height)

result = 0;

% convert to L*ab colour space
q = rgb2lab(im);
L = q(:,:,1);
a = q(:,:,2);
b = q(:,:,3);

total_pix = bbox(3) * bbox(4);
total_skin = 0;

for i = bbox(2):bbox(2)+bbox(4)
    for j = bbox(1):bbox(1)+bbox(3)
        if((L(i,j)>=72)&&(L(i,j)<=90) && (a(i,j)>=3)&&(a(i,j)<=15.5) && (b(i,j)>=-2)&&(b(i,j)<=20))
            total_skin = total_skin + 1;
        end
    end
end

if total_skin >= total_pix / 2
    result = total_skin/total_pix;
end

result = total_skin/total_pix;
