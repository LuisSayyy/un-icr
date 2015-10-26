lgbt_a = imread('Y:\Thesis\LGBT_A.png');
imwrite(lgbt_a, 'Y:\Thesis\output\LGBT_A.png');
gray_lgbt_a = rgb2gray(lgbt_a);
imwrite(gray_lgbt_a, 'Y:\Thesis\output\GRAY_LGBT_A.png');
bw_lgbt_A = im2bw(gray_lgbt_a, 0.5);
imwrite(bw_lgbt_A, 'Y:\Thesis\output\BW_LGBT_A.png');

%255 is white
%0 is black
%disp(gray_lgbt_a);

GS_hist=imhist(gray_lgbt_a);
%1-256 where 1=0 and 256=255 (index 1-256(255)) 
%disp(GS_hist(256));
sum_all=sum(sum(gray_lgbt_a));
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
BW = im2bw(gray_lgbt_a, thres_percent);

%disp(BW);
imshow(BW);
