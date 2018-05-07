
function [sharpness_metric] = EdgeModelBasedIQA(input_image)
% Syntax:[sharpness_metric] = EdgeModelBasedIQA(input_image)
% Compute the score 'sharpness_metric' representing the quality of
% input_image
%
% input_image is the image to be processed.
% sharpness_metric is the computed score representing the quality of the image.
% 
% Reference:
% Guan J, Zhang W, Gu J, et al. No-reference Blur Assessment Based on Edge
% Modeling[J]. Journal of Visual Communication and Image Representation,
% 2015.

%%%%%%%%%%%% pre-processing %%%%%%%%%%%%
% convert to gray scale if given a color image
[m n z] = size(input_image);
if z > 1
    input_image = rgb2gray(input_image);
end
% convert the image to double for further processing
input_image = double(input_image);


%%%%%%%%%%%% parameters %%%%%%%%%%%%
% threshold to characterize blocks as edge/non-edge blocks
% fitting parameter
beta = 3.6;
k1 = 1;
k2 = 1;

widthjnb = [0.8*ones(1,50) 0.72*ones(1,300)];
%%%%%%%%%%%% initialization %%%%%%%%%%%%
% arrays and variables used during the calculations

Number_small = 0;
Number_big = 0 ;

%%%%%%%%%%%% edge detection %%%%%%%%%%%%
% edge detection using canny and sobel canny edge detection is done to 
% classify the blocks as edge or non-edge blocks and sobel edge 
% detection is done for the purpose of edge width measurement. 

[width,contrast] = edge_width(input_image); 
width = width(width ~= 0);
width = width';
% find the contrast for the block
contrast = contrast(contrast ~= 0);
contrast = contrast';
contrast = round(contrast);
blk_jnb = widthjnb(contrast+1);
%total_num_edges = length(local_width);

for k = 1:numel(width)     
    if width(k) <= blk_jnb(k) 
        Number_small = Number_small+1 ;
    else
        Number_big = Number_big+1 ;
	end
end

if((k1*Number_small + k2*Number_big) ~=0)
    sharpness_metric = Number_small / (k1*Number_small + k2*Number_big);  
else
    sharpness_metric = 0;
end



