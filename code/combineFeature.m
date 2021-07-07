%%
clear
method = {'inpaint-0','inpaint-1','inpaint-2'};
type = {'rect','circ','irrg'};
inpaintsz = {'64','32','16','8'};
Fn = [];
Fp = [];
for methodIdx = 1:length(method)
    for inpaintszIdx = 1:length(inpaintsz)
        for typeIdx = 1:length(type)
            tmp = load(['..\data\' method{methodIdx}  '_' type{typeIdx} '_' inpaintsz{inpaintszIdx} '_p.mat']);
            Fp = [Fp;tmp.F];
            tmp = load(['..\data\' method{methodIdx}  '_' type{typeIdx} '_' inpaintsz{inpaintszIdx} '_n.mat']);
            Fn = [Fn;tmp.F];
        end
    end
end
F = Fp;
save(['..\data\UCID_All_p.mat'],'F');
F = Fn;
save(['..\data\UCID_All_n.mat'],'F');