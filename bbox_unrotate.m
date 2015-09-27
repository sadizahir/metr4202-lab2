function rbbox = bbox_unrotate(bbox, cx, cy, angle, imaxx, imaxy)
% give the function the bbox, the pivot points (cx, cy), angle, and it can
% unrotate the bbox back to a polygon, and then turn that into a boundary
% box

bboxPf = bbox2points(bbox); % convert the bbox to points!
fixedbbox = zeros(4, 2); % allocate the unrotated points

for i = 1:4
    px = bboxPf(i, 1); % x-coord of point
    py = bboxPf(i, 2); % y-coord of points
    coord = [cosd(angle), -sind(angle), 0; sind(angle), cosd(angle), 0; 0, 0, 1]*[px-cx; py-cy; 1];
    coord = coord + [cx;cy;1];
    fixedbbox(i,:) = coord(1:2,:)';
end

minx = min(fixedbbox(:, 1));
maxx = max(fixedbbox(:, 1));
miny = min(fixedbbox(:, 2));
maxy = max(fixedbbox(:, 2));

if minx < 0
    minx = 0;
end

if miny < 0
    miny = 0;
end

if maxx > imaxx
    maxx = imaxx;
end

if maxy > imaxy
    maxy = imaxy;
end

width = maxx - minx;
height = maxy - miny;

rbbox = [minx, miny, width-10, height-10];

