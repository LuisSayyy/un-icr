for line_segment_number = 1 : handles.number_of_line_segments
    for word_segment_number = 1 : handles.number_of_word_segments
        for char_segment_number = 1 : handles.number_of_char_segments
            input_image = imread(strcat(handles.file_pwd, '\segments\', 'line_', int2str(line_segment_number), '_word_', int2str(word_segment_number), '_char_', int2str(char_segment_number), '_', handles.file_name, handles.file_extension));
            
            character_segment = imresize(input_image, [100 100]);
            imshow(character_segment);
            character_count = 0;
            
            for row = 0 : 19
                current_row = row*5+1;
                for column = 0 : 19
                    current_column = column*5+1;
                    character_count = character_count+1;
                    if sum(sum(character_segment(current_row:current_row+4,current_column:current_column+4))) > 0;
                        euler_character(character_count) = 1;
                    else
                        euler_character(character_count) = 0;
                    end              
                end
            end
            
            ZZ = reshape(euler_character,20,20);
            YY = (padarray(ZZ, [2 2], 0))';
            imshow(YY)
            
            euler_character = reshape(YY, 1, 576);
            
            cx = 0;
            cc = 0;
            dg = 0;
            z = 0;
            E = 0;
            x = 1;
            i = 1;
            m = 24;
            n = 24;

            while i <= (m - 1) * (n - 1)
                z = euler_character(x) + euler_character(x+1) + euler_character(x+n) + euler_character(x+n+1);
                if (z==1)
                    cx = cx+1;
                elseif(z == 3)
                    cc = cc+1;
                elseif (z == 2 & ~(euler_character(x) ==  + euler_character(x+1)) & ~(euler_character(x) == euler_character(x+n)))
                    dg = dg+1;
                end
                x = x+1;
                i = i+1;
            end

            if (cx == 0 & cc == 0 & dg == 0)
                'no character'
            else
                E = (cx - cc - 2 * dg) / 4;
                sprintf('cx = %d', cx);
                sprintf('cc = %d', cc);
                sprintf('dg = %d', dg);
                sprintf('Euler Number = %d', E)

                if(E == 1)
                    output = 'CLASS: no holes';
                elseif(E == 0)
                     output = 'CLASS: ONE hole';
                elseif(E == -1)
                     output = 'CLASS: TWO holes';
                elseif(E == -2)
                     output = 'CLASS: THREE holes';
                end
            end

            set(handles.output_display, 'string', output);
        end
    end
end