clear, clc, close all;
% Perform sequential feature selection for CLASSIFY on iris data with
% noisy features and see which non-noise features are important

% Preprocessing
tic
%load('fisheriris');
sDirName = '.\Input';

% Horizon of prediction future points
nHorizon = 1;

% Number of reduced dim
nDimReductionPercent = 0.25;

%[mFeatures, mTargets, features_set] = ReadData(sDirName, nHorizon);
toc
load processed_data;

tic
% Features selection SVM
%X = randn(150,10);
X = mFeatures;

% Number of reduced dim
%nDim = floor(size(mFeatures, 2) * (1 - nDimReductionPercent));
nDim = 2;

%X(:,[1 3 5 7 ])= meas;
%y = species;
y = mTargets;
opt = statset('display','iter');
% Generating a stratified partition is usually preferred to
% evaluate classification algorithms.
cvp = cvpartition(y,'k',2); 
%cvp = cvpartition(y,'Leaveout'); 
[fs,history] = sequentialfs(@classf,X,y,'NFeatures', nDim, 'cv',cvp,'options',opt);

save 'features_selection_model';
toc

tic
% ROC curves and F1 score
figure;
bPlot = 1;
[errRate, AUC, F1, pr, re] = calc_performance(mFeatures, mTargets, fs, features_set, nDim, nHorizon, bPlot)

toc