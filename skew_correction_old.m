mini_A = imread('RAW\tpof.png');
gray_mini_A = rgb2gray(mini_A);
bw_mini_A = im2bw(gray_mini_A, 0.56863);

input_image = xor(1, bw_mini_A);

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

hist(hist_params,1:length(input_image(1,:)));
