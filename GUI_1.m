function varargout = GUI_1(varargin)
% GUI_1 MATLAB code for GUI_1.fig
%      GUI_1, by itself, creates a new GUI_1 or raises the existing
%      singleton*.
%
%      H = GUI_1 returns the handle to a new GUI_1 or the handle to
%      the existing singleton*.
%
%      GUI_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_1.M with the given input arguments.
%
%      GUI_1('Property','Value',...) creates a new GUI_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_1

% Last Modified by GUIDE v2.5 20-Aug-2015 23:33:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_1_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_1 is made visible.
function GUI_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_1 (see VARARGIN)

% Choose default command line output for GUI_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_image.
function load_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
x = imgetfile();
[handles.file_pwd,handles.file_name,handles.file_extension] = fileparts(x);
%if ~(handles.file_extension == '.png');
%    set(handles.output_display, 'string', 'File format not supported');
    imshow(x);
    handles.filename = x;
    guidata(hObject, handles);
%end

% --- Executes on button press in gray_scale_image.
function gray_scale_image_Callback(hObject, eventdata, handles)
% hObject    handle to gray_scale_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = imread(handles.filename);
gray_x = rgb2gray(x);
imshow(gray_x);

% --- Executes on button press in binary_image.
function binary_image_Callback(hObject, eventdata, handles)
% hObject    handle to binary_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gray_scale_image_Callback(hObject, eventdata, handles);
gray_x = getimage();

%255 is white
%0 is black
%disp(gray_lgbt_a);

GS_hist=imhist(gray_x);
%1-256 where 1=0 and 256=255 (index 1-256(255)) 
%disp(GS_hist(256));
sum_all=sum(sum(gray_x));
%fprintf('sum_all=%f.\n',sum_all);

wht_back=0;
wht_fore=0;
varMax=0;
threshold=0;
sum_temp=0;
total=sum(GS_hist);
for t=1:256
    wht_back=wht_back+GS_hist(t);
    %fprintf('wht_back=%f.\n',wht_back);
    if(wht_back==0)
        continue;
    end
    wht_fore=total-wht_back;
    %fprintf('wht_fore=%f.\n',wht_fore);
    if(wht_fore==0)
        break;
    end
    sum_temp=sum_temp+((t-1)*GS_hist(t));
    %fprintf('sum_temp=%f.\n',sum_temp);
    
    mB=sum_temp/wht_back; %mean Backgroud
    mF=(sum_all-sum_temp)/wht_fore; %mean Foreground
   % fprintf('mB=%f.\n',mB);
    %fprintf('mF=%f.\n',mF);
    
    var_Between = wht_back * wht_fore * (mB - mF) * (mB - mF);
    %fprintf('var_Between=%f.\n',var_Between);

    if(var_Between > varMax) 
      varMax = var_Between;
      threshold = t-1;
    end
end
%fprintf('threshold=%f.\n',threshold);
%fprintf('sum_all=%f.\n',sum_all);

thres_percent=threshold/255;
%fprintf('thres_percent=%f.\n',thres_percent);
BW = im2bw(gray_x, thres_percent);
set(handles.output_display, 'string', strcat('THRESHOLD VALUE: ', num2str(thres_percent)));
%disp(BW);

input_image = xor(1,BW);

imshow(input_image);

%--------------- DISPLAY HISTOGRAM OF BINARY IMAGE -------------

rows = 0;
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

axes(handles.axes3);
hist(hist_params,1:length(input_image(1,:)));
axes(handles.axes1);

[handles.image_height, handles.image_width] = size(input_image);
guidata(hObject, handles);

% --- Executes on button press in skew_correction.
function skew_correction_Callback(hObject, eventdata, handles)
% hObject    handle to skew_correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

binary_image_Callback(hObject, eventdata, handles);
input_image = getimage();

rotation = -40;

for n = 1 : 18;
    
    if (n == 18)
        rotation = 0;
    end
    
    set(handles.output_display, 'string', strcat('ROTATION: ', num2str(rotation)));
    
    rotated_image = imrotate(input_image, rotation);
    imshow(rotated_image);
    
    clear rows;
    clear hist_params;
    for n = 1 : length(rotated_image(1,:));
        rows(n) = sum(rotated_image(:,n));
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
  
    histogram = hist(hist_params,1:length(rotated_image(1,:)));
   
    axes(handles.axes2);
    hist(hist_params,1:length(rotated_image(1,:)));
    axes(handles.axes1);

    rotation = rotation+5;
end

% --- Executes on button press in slant_correction.
function slant_correction_Callback(hObject, eventdata, handles)
% hObject    handle to slant_correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

binary_image_Callback(hObject, eventdata, handles);
input_image = getimage();

a = -0.90;

for n = 1 : 13;
    
    if (n == 13)
        a = 0;
    end
    
    set(handles.output_display, 'string', strcat('SLANT TRESHOLD: ', num2str(a)));
    
    T = maketform('affine', [1 0 0; a 1 0; 0 0 1] );
    transformed_image = imtransform(input_image,T, 'FillValues', 0);
    imshow(transformed_image);
    
    clear rows;
    clear hist_params;
    for n = 1 : length(transformed_image(1,:));
        rows(n) = sum(transformed_image(:,n));
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
  
    histogram = hist(hist_params,1:length(transformed_image(1,:)));
    
    axes(handles.axes2);
    hist(hist_params,1:length(transformed_image(1,:)));
    axes(handles.axes1);

    a = a+0.15;
end

% --- Executes on button press in line_segmentation.
function line_segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to line_segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

binary_image_Callback(hObject, eventdata, handles);
imshow(getimage());

input_image = getimage();

%imwrite(input_image, strcat(handles.file_pwd, '\segments\', '1.png'));

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

    axes(handles.axes2);
    [counts,bins] = hist(hist_params,1:image_height);
    barh(bins, counts);
    axes(handles.axes1);
 
    line_segmentation_threshold = 0.02;
    spc = 0;
    for k = 1 : length(rows)-1;
        if rows(k) > 0 && rows(k+1) == 0 && ((k+1 - segmentation_points(spc)) > image_height*line_segmentation_threshold)
            spc = spc+1; 
            segmentation_points(spc) = k+1;
        elseif rows(k) == 0 && rows(k+1) > 0
            spc = spc+1;
            segmentation_points(spc) = k;
        end
    end
    
    imshow(input_image);
    hold on;
    
    for l = 1 : length(segmentation_points)
        line([1,image_width],[segmentation_points(l),segmentation_points(l)]);
    end
    
    hold off;
    
    number_of_line_segments = floor(spc/2);
    
    spc = 1;
    for line_number = 1 : number_of_line_segments;
    z = input_image(segmentation_points(spc): segmentation_points(spc+1), 1:image_width);
    imwrite(z, strcat(handles.file_pwd, '\segments\', 'line_', int2str(line_number), '_', handles.file_name, handles.file_extension));
    spc = spc+2;
    end

    set(handles.output_display, 'string', strcat('NUMBER OF LINE SEGMENTS: ', num2str(number_of_line_segments)));
    handles.number_of_line_segments = number_of_line_segments;
    handles.line_segmentation_points = segmentation_points;
    guidata(hObject, handles);

% --- Executes on button press in word_segmentation.
function word_segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to word_segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

line_segmentation_Callback(hObject, eventdata, handles);

image_height = handles.image_height;
image_width = handles.image_width;
line_segmentation_points = handles.line_segmentation_points;

line_top = 1;
line_bottom = 2;

total_words = 0;

for segment_number = 1 : handles.number_of_line_segments
    
    input_image = imread(strcat(handles.file_pwd, '\segments\', 'line_', int2str(segment_number), '_', handles.file_name, handles.file_extension));

    clear rows;
    clear hist_params;
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

    axes(handles.axes2);
    hist(hist_params,1:length(input_image(1,:)));
    axes(handles.axes1);

    spc = 0;
    clear segmentation_points;
    for k = 1 : length(rows)-1;
        if rows(k) > 0 && rows(k+1) == 0
            spc = spc+1; 
            segmentation_points(spc) = k+1;
        elseif rows(k) == 0 && rows(k+1) > 0
            spc = spc+1;
            segmentation_points(spc) = k;
        end
    end
    
    for w = 1 : length(segmentation_points)
        line([segmentation_points(w), segmentation_points(w)],[line_segmentation_points(line_top),line_segmentation_points(line_bottom)]);
    end
    
    line_top = line_top + 2;
    line_bottom = line_bottom + 2;
    
    number_of_word_segments = floor(length(segmentation_points)/2);
    total_words = total_words + number_of_word_segments;
    
    spc = 1;
    
    for n = 1 : number_of_word_segments;
        z = input_image(: , segmentation_points(spc): segmentation_points(spc+1));
        imwrite(z, strcat(handles.file_pwd, '\segments\', 'line_', int2str(segment_number), '_word_', int2str(n), '_', handles.file_name, handles.file_extension));
        spc = spc+2;
    end
end

handles.number_of_word_segments = total_words;
set(handles.output_display, 'string', strcat('NUMBER OF WORD SEGMENTS: ', num2str(total_words)));
guidata(hObject, handles);

% --- Executes on button press in character_segmentation.
function character_segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to character_segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

line_segmentation_Callback(hObject, eventdata, handles);

for line_segment_number = 1 : handles.number_of_line_segments
    for word_segment_number = 1 : handles.number_of_word_segments
        input_image = imread(strcat(handles.file_pwd, '\segments\', 'line_', int2str(line_segment_number), '_word_', int2str(word_segment_number), '_', handles.file_name, handles.file_extension));
        input_image = input_image;

        imshow(input_image);

        clear rows;
        clear hist_params;
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

        axes(handles.axes2);
        hist(hist_params,1:length(input_image(1,:)));
        axes(handles.axes1);

        
%         hist_params
%         [temp,originalpos] = sort( m, 'ascend' );
%         n = temp(1:3)
%         p=originalpos(1:3)
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

        number_of_char_segments = floor(length(segmentation_points)/2);
        spc = 1;

        for n = 1 : number_of_char_segments;
        z = input_image(: , segmentation_points(spc): segmentation_points(spc+1));
        imwrite(z, strcat(handles.file_pwd, '\segments\', 'line_', int2str(line_segment_number), '_word_', int2str(word_segment_number), '_char_', int2str(n), '_', handles.file_name, handles.file_extension));
        spc = spc+2;
        end
    end
end

handles.number_of_char_segments = number_of_char_segments;
set(handles.output_display, 'string', strcat('NUMBER OF CHARACTER SEGMENTS: ', num2str(number_of_char_segments)));
guidata(hObject, handles);

% --- Executes on button press in euler_number.
function euler_number_Callback(hObject, eventdata, handles)
% hObject    handle to euler_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for line_segment_number = 1 : handles.number_of_line_segments
    for word_segment_number = 1 : handles.number_of_word_segments
        for char_segment_number = 1 : handles.number_of_char_segments
            input_image = imread(strcat(handles.file_pwd, '\segments\', 'line_', int2str(line_segment_number), '_word_', int2str(word_segment_number), '_char_', int2str(char_segment_number), '_', handles.file_name, handles.file_extension));
            
            character_segment = imresize(input_image, [90 60]);
            
%             YY = imdilate(input_image, strel('disk', 2,6));
%             size(YY)
%            
%             euler_character = reshape(ZZ, 1, m*n);
%             size(euler_character);
%             
%             imshow(ZZ);
            
            imshow(character_segment)
            ZZ = (padarray(character_segment, [2 2], 0));
            [n,m] = size(ZZ);
            euler_character = reshape(ZZ, 1, m*n);
            
            cx = 0;
            cc = 0;
            dg = 0;
            z = 0;
            E = 0;
            x = 1;
            i = 1;

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
                output = 'no character';
            else
                E = (cx - cc - 2 * dg) / 4;
                sprintf('cx = %d', cx);
                sprintf('cc = %d', cc);
                sprintf('dg = %d', dg);
                sprintf('Euler Number = %d', E)

                if(E == 1)
                     output = 'CLASS: NO holes';
                elseif(E == 0)
                     output = 'CLASS: ONE hole';
                elseif(E == -1)
                     output = 'CLASS: TWO holes';
                elseif(E == -2)
                     output = 'CLASS: THREE holes';
                elseif (E <= -3)
                    output = 'CLASS: MANY holes';
                end
            end

            set(handles.output_display, 'string', output);
        end
    end
end

% --- Executes on button press in diagonal_feature_extraction.
function diagonal_feature_extraction_Callback(hObject, eventdata, handles)
% hObject    handle to diagonal_feature_extraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for line_segment_number = 1 : handles.number_of_line_segments
    for word_segment_number = 1 : handles.number_of_word_segments
        for char_segment_number = 1 : handles.number_of_char_segments
            input_image = imread(strcat(handles.file_pwd, '\segments\', 'line_', int2str(line_segment_number), '_word_', int2str(word_segment_number), '_char_', int2str(char_segment_number), '_', handles.file_name, handles.file_extension));
            m = 90;
            n = 60;
            input_image = imresize(input_image, [m n]);
            
            imwrite(input_image, strcat(strcat(handles.file_pwd, '\segments\', 'resized.png')));
            imshow(input_image);
   
            zone_number = 1;
            y = 1;

            current_row = 1;
            while y <= 9 
                x = 1;
                current_column = 1;
                while x <= 6
                    zone(:,:,zone_number) = input_image(current_row:current_row+9,current_column:current_column+9);
                    x = x+1;
                    current_column = current_column+10;
                    zone_number = zone_number+1;
                end
                y = y+1;
                current_row = current_row+10;
            end

            row = 1;
            zone_number = 1;
            while row <= 9
                column = 1;
                while column <= 6
                sub_feature(row,column) = sum(sum(zone(:,:,zone_number)))/19;    
                zone_number = zone_number+1;
                column = column+1;
                end
                row = row+1;
            end

            column = 1;
            while column <= 6
                vertical_feature(column) = sum(sub_feature(:,column))/9;
                column = column+1;
            end

            row = 1;
            while row <= 9
                horizontal_feature(row) = sum(sub_feature(row,:))/6;
                row = row+1;
            end

            A = [reshape(sub_feature,1,54), vertical_feature, horizontal_feature]
            set(handles.output_display, 'string', A);
        end
    end
end
