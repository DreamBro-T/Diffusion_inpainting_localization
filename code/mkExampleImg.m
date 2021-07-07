%%
clear
cwd = pwd;
cd gmic
method = {'0','1','2'};
smoothness = '40%';
diffusion_iter = '15';
database = 'UCID';
img_dir = ['..\..\imgdb\' database '\example\orig\'];
gt_dir = ['..\..\imgdb\' database '\groundtruth\example\'];if ~exist(gt_dir,'dir'); mkdir(gt_dir); end
fileList = dir([img_dir '*.tif']);


for k = 1:length(method)
    out_dir = ['..\..\imgdb\' database '\inpaint-' method{k} '_example\']; if ~exist(out_dir,'dir'); mkdir(out_dir); end
    
    for p = 1:length(fileList)
        filename = fileList(p).name;
        comm = ['gmic "' img_dir filename '" "' gt_dir filename '" -inpaint_diffusion[0] [1],' smoothness ',' method{k} ',' diffusion_iter ' -o[0] ' out_dir filename ',uchar,lzw > nul'];
        fprintf('%s\n',comm)
        system(comm);
    end
end

cd(cwd)