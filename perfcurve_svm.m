% ROC curve
clear, clc, close all,
tic
load 'features_selection_model';
%x = meas(51:end,1:2);        % iris data, 2 classes and 2 features
x = mFeatures(:, fs);
%y = (1:100)'>50;             % versicolor=0, virginica=1
y = mTargets;
% b = glmfit(x,y,'binomial');  % logistic regression
% p = glmval(b,x,'logit');     % get fitted probabilities for scores

svmStruct = svmtrain(x,y,'showplot',true);

% SVM classify: svmclassify has to be modified as follows:
%function [outclass, p] = svmclassify(svmStruct,sample, varargin)
%[outclass, p] = svmdecision(sample,svmStruct);
[C, p] = svmclassify(svmStruct,x,'showplot',true);
%p = -p;% flip the sign to get the score for the +1 class
errRate = sum(y~= C)/size(x, 1)  %mis-classification rate
conMat = confusionmat(y,C) % the confusion matrix

%[X,Y] = perfcurve(species(51:end,:),p,'virginica');
[X_perf,Y_perf, T, AUC] = perfcurve(y,p,1);
AUC
plot(X_perf,Y_perf)
xlabel('False positive rate'); ylabel('True positive rate')
title('ROC for classification by SVM')

% Calculate precision
pr = conMat(2,2)/(conMat(2,1) + conMat(2,2))

% Calculate recall
re = conMat(2,2)/(conMat(1,2) + conMat(2,2))

% Calculate F1 score
F1 = 2 * (pr*re)/(pr+re)

saveas(gcf, ['ROC_' num2str(nDim) '_AUC_' num2str(AUC) '_F1_' num2str(F1) '.fig'], 'fig');
% Obtain errors on TPR by vertical averaging
%[X,Y] = perfcurve(species(51:end,:),p,'virginica','nboot',1000,'xvals','all');
% [X,Y] = perfcurve(y,p,0,'nboot',1000,'xvals','all');
% errorbar(X,Y(:,1),Y(:,2)-Y(:,1),Y(:,3)-Y(:,1)); % plot errors
toc