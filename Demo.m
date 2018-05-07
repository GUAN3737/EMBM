%=====================================================================
% File: Demo.m
% Code written by J. GUAN, SDU, China (http://ivulab.asu.edu)
% 
%===================================================================== 
% Reference:
% Guan J, Zhang W, Gu J, et al. No-reference Blur Assessment Based on Edge
% Modeling[J]. Journal of Visual Communication and Image Representation,
% 2015.
%===================================================================== 
% Acknowledgement
% -----------------
% We would like to thank the following papers and their code since they inspire our work a lot.
% 
%  - Zhang W, Cham W K. Single-image refocusing and defocusing[J]. Image
%  Processing, IEEE Transactions on, 2012, 21(2): 873-882.
% 
%  - Narvekar N D, Karam L J. A no-reference image blur metric based on the
%  cumulative probability of blur detection (CPBD)[J]. Image Processing,
%  IEEE Transactions on, 2011, 20(9): 2678-2683.
% =====================================================================  
% 
% Copyright Notice:
% 
% All Rights Reserved.
% This copyright statement may not be removed from any file containing it 
% or from modifications to these files.
% This copyright notice must also be included in any file or product 
% that is derived from the source files. 
%  
% Redistribution and use of this code in source and binary forms, 
% with or without modification, are permitted provided that the 
% following conditions are met:  
% - Redistribution's of source code must retain the above copyright 
%   notice, this list of conditions and the following disclaimer. 
% - Redistribution's in binary form must reproduce the above copyright 
%   notice, this list of conditions and the following disclaimer in the 
%   documentation and/or other materials provided with the distribution. 
% 
% The code and our papers are to be cited in the bibliography as:
% 
% Guan J, Zhang W, Gu J, et al. No-reference Blur Assessment Based on Edge
% Modeling[J]. Journal of Visual Communication and Image Representation,
% 2015.
% 
% 
% DISCLAIMER:
% This software is provided by the copyright holders and contributors 
% "as is" and any express or implied warranties, including, but not 
% limited to, the implied warranties of merchantability and fitness for 
% a particular purpose are disclaimed. In no event shall the Chinese 
% University of HongKong, IVP Lab members, authors, or 
% contributors be liable for any direct, indirect, incidental, special,
% exemplary, or consequential damages (including, but not limited to, 
% procurement of substitute goods or services; loss of use, data, or 
% profits; or business interruption) however caused and on any theory 
% of liability, whether in contract, strict liability, or tort 
% (including negligence or otherwise) arising in any way out of the use 
% of this software, even if advised of the possibility of such damage. 
% ===================================================================== 

clc;
clear;
close all;
input_image = imread('.\test.bmp');     
fprintf('Image load finished. \n')
%% For a given image, compute the edge width and edge contrast for every detected edge pixel (A pixel that belongs to an edge).
% convert to gray scale if color image
[x y z] = size(input_image);
if z > 1
    input_image = rgb2gray(input_image);
end
% convert the image to double for further processing
input_image = double(input_image);
figure,imshow(input_image/255);
xlabel('Original Image');

%% Using edge model to compute width map and constrat map according to the given image
[width,contrast] = edge_width(input_image); 
figure,imshow(width);       % width of detected edge pixels.
xlabel('Width of detected edges');
figure,imshow(contrast);    % contrast of detected edge pixels.
xlabel('Contrast of detected edges');     
fprintf('Width and contrast computation finished.\n')

%% Evluate the qulaity of the image according to edge model based 
% metric. 'Q_image' is the computed quality of the Image.
Q_image = EdgeModelBasedIQA(input_image);
fprintf('Quality of test image is %f \n', Q_image);

