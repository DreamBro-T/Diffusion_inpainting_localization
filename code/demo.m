%%
mkImg;            % generate inpainted images with square/circular/irregular inpainted regions
mkExampleImg;     % generate example inpainted images with meaningful inpainted regions
ExtractFeaFromTrainSample;
combineFeature;
trainClassifier;

clear
dataBase = 'UCID';
Method = {'inpaint-0','inpaint-1','inpaint-2'};
Type = {'example'};
for methodIdx = 1:length(Method)
    for typeIdx = 1:length(Type)
        method = Method{methodIdx};
        type = Type{typeIdx};
        predict;
    end
end

clear
dataBase = 'UCID';
Method = {'inpaint-0','inpaint-1','inpaint-2'};
Type = {'example'};
for methodIdx = 1:length(Method)
    for typeIdx = 1:length(Type)
        method = Method{methodIdx};
        type = Type{typeIdx};
        postprocess;
    end
end