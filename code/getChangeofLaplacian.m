function d_IL = getChangeofLaplacian(I)
% Compute the changes in the image Laplacians along the direction of isophote

I_pad = padarray(I,[1 1],'replicate');
IL = del2(double(I_pad));
[FX,FY] = gradient(double(I_pad));
dx = abs(FY)./sqrt(FX.^2+FY.^2);
dy = abs(FX)./sqrt(FX.^2+FY.^2);
d_IL = ones(size(IL));
for i = 2:size(IL,1)-1
    for j = 2:size(IL,2)-1
        for channel = 1:size(d_IL,3)
            a = IL(i,j,channel);
            b = IL(i+sign(FX(i,j,channel)),j,channel);
            c = IL(i+sign(FX(i,j,channel)),j-sign(FY(i,j,channel)),channel);
            d = IL(i,j-sign(FY(i,j,channel)),channel);
            d_IL(i,j,channel) = (1-dx(i,j,channel))*(1-dy(i,j,channel))*a+(1-dx(i,j,channel))*dy(i,j,channel)*b+dx(i,j,channel)*(1-dy(i,j,channel))*d+dx(i,j,channel)*dy(i,j,channel)*c-a;
        end
    end
end
d_IL = d_IL(2:end-1,2:end-1,:);
d_IL(isnan(d_IL)) = 0;