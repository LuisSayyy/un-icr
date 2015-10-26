function [segmentation_points] = Line_Segmentation(input_image)
    
    clear rows;
    clear hist_params;
    
    [image_height,image_width] = size(input_image);
    
    for n = 1 : image_height;
        rows(n) = sum(input_image(n,:));
    end

    index = 1;
    
    for i = 1 : image_height;
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

    [counts,bins] = hist(hist_params,1:image_height);
    barh(bins, counts);
 
    line_segmentation_threshold = 0.02;
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
 
    segmentation_points
    deleted_points = [];
    
    dpc = 1;
    for (j = 1 : length(segmentation_points)/2)
        if ((segmentation_points(j+1) - segmentation_points(j)) < image_height*line_segmentation_threshold)
            deleted_points(dpc) = j;
            dpc = dpc+1;
        end
        j = j+2;
    end
    
    
    if length(deleted_points) > 0
        clear j;
        for (j = length(deleted_points) : length(deleted_points-1))
            segmentation_points(deleted_points(j)) = [];
            segmentation_points(deleted_points(j)) = [];
            j = j-1;
        end
    end
    
end

