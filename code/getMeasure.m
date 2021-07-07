function [F1,TPR,FPR,Precision] = getMeasure(mask,groundTrue)

groundTrueZero = groundTrue==0;
groundTrueOne = groundTrue>0;
maskZero = mask==0;
sumGroundTrueZero = sum(sum(groundTrueZero));
sumGroundTrueOne = sum(sum(groundTrueOne));
TP = groundTrueZero & maskZero;
FP = groundTrueOne  & maskZero;
sumTP = sum(sum(TP));
sumFP = sum(sum(FP));
TPR = sumTP/sumGroundTrueZero; % also referred as recall
FPR = sumFP/sumGroundTrueOne;
F1 = 2*sumTP/(sumTP+sumFP+sumGroundTrueZero);
Precision = sumTP/sum(sum(maskZero));
if isnan(Precision); Precision = 0; end
