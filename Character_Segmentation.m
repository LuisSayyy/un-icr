function [segmentation_points] = Character_Segmentation(input_image_raw)
    
    [image_height,image_width] = size(input_image_raw);

     for n = 1 : length(input_image_raw(1,:));
        columns(n) = sum(input_image_raw(:,n));
    end
    
    
    histogram_mins = imregionalmin(columns);
    
    reference = 1;
    ctr_psp = 0;
    for n = 2 : length(histogram_mins);
        if histogram_mins(n-1) == 0 && histogram_mins(n) == 1
            reference = n;
        elseif histogram_mins(n-1) == 1 && histogram_mins(n) == 0
            ctr_psp = ctr_psp+1;
            psp(ctr_psp)= floor((reference + (n-1))/2);
            reference = 0;
        end
    end
    segmentation_points = psp
%     segmentation_points(1) = 1;
%     reference = 1;
%     spc = 1;
%     
%     for n = 2 : length(psp)
%         if psp(n)- psp(n-1) > 6
%             spc = spc + 1;
%             segmentation_points(spc) = floor((psp(n-1) + reference)/2);
%             reference = psp(n);
%         end
%     end
%     
%     spc = spc + 1;
%     segmentation_points(spc) = image_width;
%     segmentation_points
%     
end

% USING THE 1 PIXEL WIDTH ALGORITHM
% 
% function [segmentation_points] = Character_Segmentation(input_image_raw)
%     
%     input_image = bwmorph(input_image_raw,'thin',Inf);
%     [image_height,image_width] = size(input_image);
%     
%     segmentation_points = [];
%     
%     for n = 1 : length(input_image(1,:));
%         columns(n) = sum(input_image(:,n));
%     end
%     
%     ctr_psp = 0;
%     for n = 1 : length(columns)-1
%        if columns(n) <= 1
%         ctr_psp = ctr_psp+1;
%         psp(ctr_psp) = n;
%        end
%     end
% 
%     segmentation_points(1) = 1;
%     reference = segmentation_points(1);
%     ctr_sp = 1;
%     
%     for n = 2 : length(psp)
%         if psp(n)- psp(n-1) > 6
%             ctr_sp = ctr_sp + 1;
%             segmentation_points(ctr_sp) = floor((psp(n-1) + reference)/2);
%             reference = psp(n);
%         end
%     end
%     
%     ctr_sp = ctr_sp + 1;
%     segmentation_points(ctr_sp) = image_width;
%     
%     
% end
% 
