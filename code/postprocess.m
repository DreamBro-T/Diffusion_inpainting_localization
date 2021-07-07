%%
fprintf('%s %s\n',method,type);
result_dir = ['..\results\' dataBase '\' method '_' type '\'];
pos_ =  strfind(type,'_');
if length(pos_) <=1 
    gt_dir = ['..\imgdb\' dataBase '\groundtruth\' type '\'];
else
    gt_dir = ['..\imgdb\' dataBase '\groundtruth\' type(1:pos_(2)-1) '\'];
end
clear pos_
fileList = dir([result_dir '*.mat']);
if strcmp(dataBase, 'UCID') && isempty(strfind(type, 'example')) 
    load('..\data\imgIdx_UCID.mat');
    imgIdx = setdiff(1:1338,imgIdx);
    fileList = fileList(imgIdx);
end
L = length(fileList);
load('ccHistRef_conn8.mat','ccEdges','conn','ccHistRef','bound');
thr = 50;
for k = 1:L
    imgName = fileList(k).name(1:end-4);
    load([result_dir imgName '.mat']);
    if strcmp(method,'orig'); gt = false(size(abn)); else; gt = imread([gt_dir imgName '.tif']); end
    if size(gt,3)==3; gt = ~(gt(:,:,1)==255 & gt(:,:,2)==0 & gt(:,:,3)==0); else gt = gt==0; end
    for j = 1:length(thr)
        mask = ordfilt2(votes>=thr(j),1,ones(3),'symmetric');
        if all(mask(:)==0); mask = votes>=thr(j); end
        [F1(k,j),TPR(k,j),FPR(k,j),Prec(k,j)] = getMeasure(~mask,gt);
        mask(abn) = 0;
        [F1a(k,j),TPRa(k,j),FPRa(k,j),Preca(k,j)] = getMeasure(~mask,gt);
        
        CC = bwconncomp(mask,conn);
        tamperedIdx = find(gt==0);
        ccCounts = zeros(1,CC.NumObjects);
        ccCountsx = ccCounts;
        for cc = 1:CC.NumObjects
            ccCounts(cc) = length(CC.PixelIdxList{cc});
        end
        ccHist = histcounts(ccCounts,ccEdges)/CC.NumObjects;
        tmp = ccHist./ccHistRef; tmp(tmp<0|isnan(tmp)) = 0;
        ccHistDiff = tmp; 
        H = ccHist; 
        R = tmp; 
        maxIdxt = find([tmp(2:end-1)>tmp(1:end-2) & tmp(2:end-1)>tmp(3:end), tmp(end)>tmp(end-1)],1)+1;
        if isempty(maxIdxt); maxIdx = 1; else maxIdx = maxIdxt; end
        if maxIdx<=3
            erode_r = 1; dilate_r = 4;
        elseif maxIdx<=5
            erode_r = 2; dilate_r = 5;
        else
            erode_r = 4; dilate_r = 6;
        end
        erode_ri = erode_r;
        mask_e = imerode(mask,strel('disk',erode_ri));
        if sum(sum(mask_e))==0 && erode_ri > 0
            erode_ri = erode_ri-1;
            mask_e = imerode(mask,strel('disk',erode_ri));
        end
        dilate_ri = dilate_r-(erode_r-erode_ri);
        mask_d = imdilate(mask_e,strel('disk',dilate_ri));
        [F1b(k,j),TPRb(k,j),FPRb(k,j),Precb(k,j)] = getMeasure(~mask_d,gt);
    end
end
fprintf('             F1 \tTPR \tFPR \tPrecision\n')
fprintf('thr = %0.2f  %0.4f\t%0.4f\t%0.4f\t%0.4f\n',[thr;mean(F1,1);mean(TPR,1);mean(FPR,1);mean(Prec,1)])
fprintf('RemoveABN    %0.4f\t%0.4f\t%0.4f\t%0.4f\n',[mean(F1a,1);mean(TPRa,1);mean(FPRa,1);mean(Preca,1)])
fprintf('MorphFilt    %0.4f\t%0.4f\t%0.4f\t%0.4f\n\n',[mean(F1b,1);mean(TPRb,1);mean(FPRb,1);mean(Precb,1)])
