
function slope = Skew_Correction(input_image)
   
    %bw = imfill(bw, 'holes');                                  %fill holes with pixels
    [label num] = bwlabel(input_image), title('num');                    %determines the number of bounding boxes to be created

    props = regionprops(label, 'BoundingBox');                  %extract bounding box and centroid properties of the image
    box = [props.BoundingBox];                                  %bounding box position and sizes to another matrix
    box = reshape(box, [4 num]);                                %reshape matrix to 4 rows, num columns

    hold on;
    for i=1:num;
       rectangle('position', box(:,i), 'edgecolor', 'r');       %label bounding boxes on output
    end

    for i=1:num;                                                %determine centroid for each bounding box
       box(5,i) = box(3,i) / 2;                                 %center of width
       box(6,i) = box(4,i) / 2;                                 %center of length
       box(7,i) = box(1,i) + box(5,i);
       box(8,i) = box(2,i) + box(6,i);
    end

    %centroid = cat(1, props.Centroid);                          %concatenate centroid property to another matrix
    plot(box(7,:), box(8, :), 'b*');                              %plot centroid on output
    hold off;

    height = box(8,num) - box(8,1), title('height');
    width = box(7,num) - box(7,1), title('width');
    slope = height/width, title('slope');                        %slope to be used as skew angle

    title('bounding box and centroid');
    
%     rotation = -40;
        %%%%

%     for n = 1 : 18;
% 
%         if (n == 18)
%             rotation = 0;
%         end
% 
%         set(handles.output_display, 'string', strcat('ROTATION: ', num2str(rotation)));
% 
%         rotated_image = imrotate(input_image, rotation);
%         imshow(rotated_image);
% 
%         hist_params = Hist_Params(rotated_image);
% 
%         histogram = hist(hist_params,1:length(rotated_image(1,:)));
% 
%         axes(handles.axes2);
%         hist(hist_params,1:length(rotated_image(1,:)));
%         axes(handles.axes1);
% 
%         rotation = rotation+5;
%     end
end