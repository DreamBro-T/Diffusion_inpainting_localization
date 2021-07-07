function [intra,inter] = getVarMap(d_IL)
% compute the local variance
% in this implementation, we use 'stdfilt' to calculate the standard deviation instead

filtsz1 = [3 5 7 9];                  % filter size of intra-channel variance
filtsz2 = [1 3 5 7];                  % filter size of inter-channel variance

intra= cell(length(filtsz1),1);
inter = cell(length(filtsz1),1);
for fk = 1:length(filtsz1)
    intra_j = stdfilt(d_IL,ones(filtsz1(fk)));
    if fk > 1
        for c = 1:3
            tmp = intra_j(:,:,c);
            tmp = ordfilt2(tmp,1,ones(filtsz1(fk)-2),'symmetric');    % use min filtering to improve performance
            intra_j(:,:,c) = tmp;
        end
    end
    intra{fk} = intra_j;
end

for fk = 1:length(filtsz1)
    tmp = stdfilt(d_IL,ones(filtsz2(fk),filtsz2(fk),3));
    inter{fk} = tmp(:,:,2);
end