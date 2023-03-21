% Kevin Cruse and Rachel Hammer
function ChromaSubsampling(input_image)
% Read in input image
img = imread(input_image);
    
% Perform conversion from RGB to YCbCr using matrix multiplication
% 'T' represents the transformation from RGB to YCbCr
% 'offset' is added to the transformed color values
% The 'reshape' function is used to convert the input 'img' into a 2D matrix
T = [0.299 0.578 0.114; -0.16874 -0.33126 0.5; 0.5 -0.41869 -0.08131];
offset = [0; 0.5; 0.5];
ycbcr = reshape((T * double(reshape(img, [], 3))')' + offset', size(img));
    
% Perform subsampling such that the horizontal color resolution is 1/2
% (4:2:2)
ycbcr_422 = ycbcr;
ycbcr_422(:, 2:2:end, 2:3) = ycbcr_422(:, 1:2:end-1, 2:3);
    
% Perform subsampling such that the horizontal color resolution is 1/4
% (4:1:1)
ycbcr_411 = ycbcr;
ycbcr_411(:, 2:4:end, 2:3) = ycbcr_411(:, 1:4:end-3, 2:3);
ycbcr_411(:, 3:4:end, 2:3) = ycbcr_411(:, 1:4:end-3, 2:3);
ycbcr_411(:, 4:4:end, 2:3) = ycbcr_411(:, 1:4:end-3, 2:3);

% Normalize YCbCr values to an 8-bit grey-scale image
ycbcr_norm = (ycbcr - min(ycbcr(:))) / (max(ycbcr(:)) - min(ycbcr(:))) * 255;
ycbcr_422_norm = (ycbcr_422 - min(ycbcr_422(:))) / (max(ycbcr_422(:)) - min(ycbcr_422(:))) * 255;
ycbcr_411_norm = (ycbcr_411 - min(ycbcr_411(:))) / (max(ycbcr_411(:)) - min(ycbcr_411(:))) * 255;

% Save the Cb and Cr grey-scale images
imwrite(uint8(ycbcr_norm(:, :, 2)), 'output_Cb_444.png');
imwrite(uint8(ycbcr_norm(:, :, 3)), 'output_Cr_444.png');
imwrite(uint8(ycbcr_422_norm(:, :, 2)), 'output_Cb_422.png');
imwrite(uint8(ycbcr_422_norm(:, :, 3)), 'output_Cr_422.png');
imwrite(uint8(ycbcr_411_norm(:, :, 2)), 'output_Cb_411.png');
imwrite(uint8(ycbcr_411_norm(:, :, 3)), 'output_Cr_411.png');
    
% Perform conversion from YCbCr to RGB
% 'T' represents the transformation from YCbCr to RGB
% 'offset' is added to the transformed color values
% 'reshape' changes the RGB values into 3d matrix of same size as 'img'
T = [1 0 1.402; 1 -0.34414 -0.71414; 1 1.77200 0];
offset = [0; -0.5; -0.5];
rgb = reshape((T * (double(reshape(ycbcr, [], 3))' + offset))', size(img));
rgb_422 = reshape((T * (double(reshape(ycbcr_422, [], 3))' + offset))', size(img));
rgb_411 = reshape((T * (double(reshape(ycbcr_411, [], 3))' + offset))', size(img));
    
% Save RGB images
imwrite(uint8(rgb), 'output_444.png');
imwrite(uint8(rgb_422), 'output_422.png');
imwrite(uint8(rgb_411), 'output_411.png');
end