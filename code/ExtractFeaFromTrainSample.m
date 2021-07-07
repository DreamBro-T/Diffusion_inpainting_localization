%%
clear
method = {'inpaint-0','inpaint-1','inpaint-2'};
type = {'rect','circ','irrg'};
inpaintsz = {'64','32','16','8'};
filesuffix = '.tif';
selectNum = 50;       % No. of samples in each image
load('..\data\trainImgIdx_UCID_for_demo.mat'); % index for the training images
for methodIdx = 1:length(method)
    for typeIdx = 1:length(type)
        for inpaintszIdx = 1:length(inpaintsz)
            fprintf('%s\n',[method{methodIdx}  ' ' type{typeIdx} '_' inpaintsz{inpaintszIdx}]);
            img_dir = ['..\imgdb\UCID\' method{methodIdx}  '_' type{typeIdx} '_' inpaintsz{inpaintszIdx}];
            gt_dir  = ['..\imgdb\UCID\groundtruth\' type{typeIdx} '_' inpaintsz{inpaintszIdx}];
            Fn = cell(length(imgIdx),2);
            Fp = cell(length(imgIdx),2);
            for k = 1:length(imgIdx)
                fprintf('# %05d: %05d\n',k,imgIdx(k));
                I = imread(fullfile(img_dir,['\ucid' num2str(imgIdx(k),'%05d') filesuffix]));
                d_IL = getChangeofLaplacian(I);          % compute the changes in the image Laplacians along the direction of isophote
                [intra_std,inter_std] = getVarMap(d_IL);
                
                gt = imread([gt_dir '\ucid' num2str(imgIdx(k),'%05d') '.tif']);
                if size(gt,3)==3; gt = ~(gt(:,:,1)==255 & gt(:,:,2)==0 & gt(:,:,3)==0); else gt = gt==0; end  % after this process, gt==0: inpainted pixel; gt==1: untouched pixel 
                m = size(d_IL,1); n = size(d_IL,2);
                inxP = find(gt==0);
                if length(inxP)<selectNum; continue; end
                inxP = inxP(randperm(length(inxP),selectNum));
                inxN = find(gt==1);
                if length(inxN)<selectNum; continue; end
                inxN = inxN(randperm(length(inxN),selectNum));
                for j = 1:length(intra_std)
                    tmp = reshape(intra_std{j},m*n,[]);
                    Fp{k,1} = [Fp{k,1} tmp(inxP,1:end)];
                    Fn{k,1} = [Fn{k,1} tmp(inxN,1:end)];
                end
                for j = 1:length(inter_std)
                    tmp = reshape(inter_std{j},m*n,[]);
                    Fp{k,2} = [Fp{k,2} tmp(inxP,1:end)];
                    Fn{k,2} = [Fn{k,2} tmp(inxN,1:end)];
                end
                fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
            end
            F = cell2mat(Fp);
            save(['..\data\' method{methodIdx}  '_' type{typeIdx} '_' inpaintsz{inpaintszIdx} '_p.mat'],'F');
            F = cell2mat(Fn);
            save(['..\data\' method{methodIdx}  '_' type{typeIdx} '_' inpaintsz{inpaintszIdx} '_n.mat'],'F');
        end
    end
end

