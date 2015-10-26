
input_image = imread('C:\Users\lenovo G40-70\Desktop\MATLAB Files\RAW\segments\textline_segmentation_line_2.png');
input_image = input_image';

imshow(input_image);

for n = 1 : length(input_image(1,:));
rows(n) = sum(input_image(:,n));
end

index = 1;
for i = 1 : length(rows);
   copies = rows(i);
   if copies == 0
       continue;
   else
       for j = 1 : copies;
          hist_params(index) = i;
           index = index + 1;
       end
   end 
end

hist(hist_params,1:length(input_image(:,1)));

spc = 0;

for k = 1 : length(rows)-1;
    if rows(k) > 0 && rows(k+1) == 0
        spc = spc+1; 
        segmentation_points(spc) = k+1;
    elseif rows(k) == 0 && rows(k+1) > 0
        spc = spc+1;
        segmentation_points(spc) = k;
    end
end

number_of_line_segments = floor(length(segmentation_points)/2);
spc = 1;

for n = 1 : number_of_line_segments;
z = input_image(: , segmentation_points(spc): segmentation_points(spc+1));
imwrite(z, strcat('C:\Users\lenovo G40-70\Desktop\MATLAB Files\RAW\segments\textline_segmentation', '_word_', int2str(n), '.png'));
spc = spc+2;
end