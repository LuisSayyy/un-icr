function [segmentation_points] = Character_Segmentation(input_image_raw)
    
    clear columns;
    clear segmentation_points;

    input_image = bwmorph(input_image_raw,'thin',Inf);
    [image_height,image_width] = size(input_image);
    
    for n = 1 : length(input_image(1,:));
        columns(n) = sum(input_image(:,n));
    end

    
    
    ctr_psp = 0;
    for n = 1 : length(columns)
       if columns(n) <= 1
        ctr_psp = ctr_psp+1;
        psp(ctr_psp) = n;
       end
    end

    reference = psp(1);

    segmentation_points = 1;
    ctr_sp = 1;
    
    for n = 2 : length(psp)
        if psp(n)- psp(n-1) > 6
            ctr_sp = ctr_sp + 1;
            segmentation_points(ctr_sp) = floor((psp(n-1) + reference)/2);
            reference = psp(n);
        end
    end

    ctr_sp = ctr_sp + 1;
    segmentation_points(ctr_sp) = image_width;

end

