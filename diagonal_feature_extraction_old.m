mini_A = imread('C:\Users\lenovo G40-70\Desktop\RAW\mini_A.png');
imwrite(mini_A, 'C:\Users\lenovo G40-70\Desktop\RAW\output\mini_A.png');
gray_mini_A = rgb2gray(mini_A);
imwrite(gray_mini_A, 'C:\Users\lenovo G40-70\Desktop\RAW\output\gray_mini_A.png');
bw_mini_A = im2bw(gray_mini_A, 0.5);
imwrite(bw_mini_A, 'C:\Users\lenovo G40-70\Desktop\RAW\output\bw_mini_A.png');

m = length(bw_mini_A(:,1));
n = length(bw_mini_A(1,:));
input_image = xor(1,bw_mini_A);

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
