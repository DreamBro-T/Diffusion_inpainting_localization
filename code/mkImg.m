%%
clear
cwd = pwd;
cd gmic
method = {'0','1','2'}; % diffusion method: 0-isotropic 1-delaunay-oriented 2-edge-oriented
smoothness = '40%';
diffusion_iter = '15';
maskType = {'rect','circ','irrg'};
maskSz = {'64','32','16','8'};
img_dir = '..\..\imgdb\UCID\orig_color\';
filelist = dir([img_dir '*.tif']);
for i = 1:length(maskType)
    for j = 1:length(maskSz)
        gt_dir = ['..\..\imgdb\UCID\groundtruth\' maskType{i} '_' maskSz{j} '\'];
        for k = 1:length(method)
            out_dir = ['..\..\imgdb\UCID\inpaint-' method{k} '_' maskType{i} '_' maskSz{j} '\'];
            if ~exist(out_dir,'dir'); mkdir(out_dir); end
            for p = 1:length(filelist)
                filename = filelist(p).name;
                comm = ['gmic "' img_dir filename '" "' gt_dir filename '" -inpaint_diffusion[0] [1],' smoothness ',' method{k} ',' diffusion_iter ' -o[0] ' out_dir filename ',uchar,lzw > nul'];
                fprintf('%s\n',comm)
                system(comm);
            end
        end
    end
end
cd(cwd)