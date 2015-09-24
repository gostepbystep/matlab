function [ out ] = loadPicture( path)
    imdata = imread(path);
%     out = rgb2gray(imdata);
    out = imdata;
end

