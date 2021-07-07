%%
clear;
addpath('ensemble');
addpath('..\data');
feaType = '';
settings.mode = 1;
settings.trnRate = 1;
settings.isShuffle = false;
settings.verbose = 1;
settings.saveModel = true;
settings.saveModelPath = '..\results\models\';
settings.saveResult = false;

fileSet1 = {['UCID_All_n.mat' ]};
fileSet2 = {['UCID_All_p.mat' ]};

ensembleTrnTst(fileSet1,fileSet2,settings);
