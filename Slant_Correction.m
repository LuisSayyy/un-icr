function slant_angle = Slant_Correction(input_image)

a = -0.90;

max_peak_average = 0;

    for n = 1 : 13;

        if (n == 13)
            a = 0;
        end

        T = maketform('affine', [1 0 0; a 1 0; 0 0 1] );
        transformed_image = imtransform(input_image,T, 'FillValues', 0);
        
        columns = 0;
        for n = 1 : length(transformed_image(1,:));
            columns(n) = sum(transformed_image(:,n));
        end

        peaks = 0;
        peaks = findpeaks(columns);
        
        if max_peak_average < mean(peaks);
           max_peak_average = mean(peaks);
           slant_angle = a;
        end

        a = a+0.15;
    end

end