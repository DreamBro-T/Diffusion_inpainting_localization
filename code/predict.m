%%
addpath('ensemble');

load('..\results\models\model_UCID_All_n_vs_UCID_All_p_used_in_paper.mat','trained_ensemble');

result_dir = ['..\results\' dataBase '\' method '_' type]; mkdir(result_dir);
img_dir = ['..\imgdb\' dataBase '\' method '_' type];
fileList = dir(fullfile(img_dir,'*.tif'));
if isempty(fileList); fileList = dir(fullfile(img_dir,'*.jpg')); end

for k = 1:length(fileList)
    fprintf('#%05d',k);
    I = imread(fullfile(img_dir,fileList(k).name));
    d_IL = getChangeofLaplacian(I);
    [intra_std,inter_std] = getVarMap(d_IL);
    
    % compute the abnormal exposed regions for later use
    t1 = sum(imfilter(double(I<10),ones(3),'replicate'),3);
    t2 = sum(imfilter(double(I>245),ones(3),'replicate'),3);
    abn = t1==27 | t2==27;
    
    m = size(d_IL,1); n = size(d_IL,2);
    F = zeros(m*n,16);
    for j = 1:length(intra_std)
        tmp = reshape(intra_std{j},m*n,[]);
        F(:,(1:3)+(j-1)*3) = tmp(:,1:end);
    end
    for j = 1:length(inter_std)
        tmp = reshape(inter_std{j},m*n,[]);
        F(:,12+j) = tmp(:,1:end);
    end

    test_result = ensemble_testing(F,trained_ensemble);
    votes = reshape(test_result.votes,m,n);
    predictions = reshape(test_result.predictions,m,n);
    save(fullfile(result_dir, [fileList(k).name(1:end-3) 'mat']),'votes','predictions','abn');
    fprintf('\b\b\b\b\b\b');
end
