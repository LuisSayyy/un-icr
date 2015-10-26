function slant_angle = Slant_Correction(input_image)

a = -0.90;

    for n = 1 : 13;

        if (n == 13)
            a = 0;
        end

        set(handles.output_display, 'string', strcat('SLANT TRESHOLD: ', num2str(a)));

        T = maketform('affine', [1 0 0; a 1 0; 0 0 1] );
        transformed_image = imtransform(input_image,T, 'FillValues', 0);
        imshow(transformed_image);

        hist_params = Hist_Params(input_image);
        
%         histogram = hist(hist_params,1:length(transformed_image(1,:)));
        
        axes(handles.axes2);
        hist(hist_params,1:length(transformed_image(1,:)));
        axes(handles.axes1);

        a = a+0.15;
    end
    
    slant_angle = 9999;
end