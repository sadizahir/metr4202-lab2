function fbbox = bbox_flip(bbox, angle, imageheight)

if angle ~= 180
    fbbox = bbox;
else
    topleftx = bbox(1);
    toplefty = bbox(2);
    width = bbox(3);
    height = bbox(4);
    
    toplefty = imageheight - toplefty + height;
    
    fbbox = [topleftx, toplefty, width, height];
end
    
    