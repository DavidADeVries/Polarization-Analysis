function [ ] = crop_image_to_neg_and_pos(image_in_path, positive_crop, positive_out_path, negative_crop, negative_out_path)

% function takes in 16 images along with cropping instruction for the
% positive and negative areas of interest. Crops images as needed, saving
% them to where was specified.

% image_in_path: gives path to read in the 16 images (leave off _XXYY.bmp suffix)
% positive_crop: 4 element array of: [top_left_corner_x, top_left_corner_y, crop_width, crop_height]
% positive_out_path: where to save positive images
% negative_crop: same as positive variant
% negative_out_path: same as negative variant

I_4545 = imread(strcat(image_in_path, '_4545.bmp'));
I_4500 = imread(strcat(image_in_path, '_4500.bmp'));
I_4530 = imread(strcat(image_in_path, '_4530.bmp'));
I_4560 = imread(strcat(image_in_path, '_4560.bmp'));
I_0045 = imread(strcat(image_in_path, '_0045.bmp'));
I_0000 = imread(strcat(image_in_path, '_0000.bmp'));
I_0030 = imread(strcat(image_in_path, '_0030.bmp'));
I_0060 = imread(strcat(image_in_path, '_0060.bmp'));
I_3045 = imread(strcat(image_in_path, '_3045.bmp'));
I_3000 = imread(strcat(image_in_path, '_3000.bmp'));
I_3030 = imread(strcat(image_in_path, '_3030.bmp'));
I_3060 = imread(strcat(image_in_path, '_3060.bmp'));
I_6045 = imread(strcat(image_in_path, '_6045.bmp'));
I_6000 = imread(strcat(image_in_path, '_6000.bmp'));
I_6030 = imread(strcat(image_in_path, '_6030.bmp'));
I_6060 = imread(strcat(image_in_path, '_6060.bmp'));

pos_4545 = imcrop(I_4545, positive_crop);
pos_4500 = imcrop(I_4500, positive_crop);
pos_4530 = imcrop(I_4530, positive_crop);
pos_4560 = imcrop(I_4560, positive_crop);
pos_0045 = imcrop(I_0045, positive_crop);
pos_0000 = imcrop(I_0000, positive_crop);
pos_0030 = imcrop(I_0030, positive_crop);
pos_0060 = imcrop(I_0060, positive_crop);
pos_3045 = imcrop(I_3045, positive_crop);
pos_3000 = imcrop(I_3000, positive_crop);
pos_3030 = imcrop(I_3030, positive_crop);
pos_3060 = imcrop(I_3060, positive_crop);
pos_6045 = imcrop(I_6045, positive_crop);
pos_6000 = imcrop(I_6000, positive_crop);
pos_6030 = imcrop(I_6030, positive_crop);
pos_6060 = imcrop(I_6060, positive_crop);

neg_4545 = imcrop(I_4545, negative_crop);
neg_4500 = imcrop(I_4500, negative_crop);
neg_4530 = imcrop(I_4530, negative_crop);
neg_4560 = imcrop(I_4560, negative_crop);
neg_0045 = imcrop(I_0045, negative_crop);
neg_0000 = imcrop(I_0000, negative_crop);
neg_0030 = imcrop(I_0030, negative_crop);
neg_0060 = imcrop(I_0060, negative_crop);
neg_3045 = imcrop(I_3045, negative_crop);
neg_3000 = imcrop(I_3000, negative_crop);
neg_3030 = imcrop(I_3030, negative_crop);
neg_3060 = imcrop(I_3060, negative_crop);
neg_6045 = imcrop(I_6045, negative_crop);
neg_6000 = imcrop(I_6000, negative_crop);
neg_6030 = imcrop(I_6030, negative_crop);
neg_6060 = imcrop(I_6060, negative_crop);

imwrite(pos_4545, strcat(positive_out_path, '_4545.bmp'));
imwrite(pos_4500, strcat(positive_out_path, '_4500.bmp'));
imwrite(pos_4530, strcat(positive_out_path, '_4530.bmp'));
imwrite(pos_4560, strcat(positive_out_path, '_4560.bmp'));
imwrite(pos_0045, strcat(positive_out_path, '_0045.bmp'));
imwrite(pos_0000, strcat(positive_out_path, '_0000.bmp'));
imwrite(pos_0030, strcat(positive_out_path, '_0030.bmp'));
imwrite(pos_0060, strcat(positive_out_path, '_0060.bmp'));
imwrite(pos_3045, strcat(positive_out_path, '_3045.bmp'));
imwrite(pos_3000, strcat(positive_out_path, '_3000.bmp'));
imwrite(pos_3030, strcat(positive_out_path, '_3030.bmp'));
imwrite(pos_3060, strcat(positive_out_path, '_3060.bmp'));
imwrite(pos_6045, strcat(positive_out_path, '_6045.bmp'));
imwrite(pos_6000, strcat(positive_out_path, '_6000.bmp'));
imwrite(pos_6030, strcat(positive_out_path, '_6030.bmp'));
imwrite(pos_6060, strcat(positive_out_path, '_6060.bmp'));

imwrite(neg_4545, strcat(negative_out_path, '_4545.bmp'));
imwrite(neg_4500, strcat(negative_out_path, '_4500.bmp'));
imwrite(neg_4530, strcat(negative_out_path, '_4530.bmp'));
imwrite(neg_4560, strcat(negative_out_path, '_4560.bmp'));
imwrite(neg_0045, strcat(negative_out_path, '_0045.bmp'));
imwrite(neg_0000, strcat(negative_out_path, '_0000.bmp'));
imwrite(neg_0030, strcat(negative_out_path, '_0030.bmp'));
imwrite(neg_0060, strcat(negative_out_path, '_0060.bmp'));
imwrite(neg_3045, strcat(negative_out_path, '_3045.bmp'));
imwrite(neg_3000, strcat(negative_out_path, '_3000.bmp'));
imwrite(neg_3030, strcat(negative_out_path, '_3030.bmp'));
imwrite(neg_3060, strcat(negative_out_path, '_3060.bmp'));
imwrite(neg_6045, strcat(negative_out_path, '_6045.bmp'));
imwrite(neg_6000, strcat(negative_out_path, '_6000.bmp'));
imwrite(neg_6030, strcat(negative_out_path, '_6030.bmp'));
imwrite(neg_6060, strcat(negative_out_path, '_6060.bmp'));

end