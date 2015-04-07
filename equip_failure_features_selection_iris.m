clear, clc, close all;
% Perform sequential feature selection for CLASSIFY on iris data with
% noisy features and see which non-noise features are important

% Preprocessing
load('fisheriris');

% Features selection SVM
%X = randn(150,10);
X = [meas(:,1), meas(:,2)];
%X(:,[1 3 5 7 ])= meas;
%y = species;
y = nominal(ismember(species,'setosa'));
opt = statset('display','iter');
% Generating a stratified partition is usually preferred to
% evaluate classification algorithms.
cvp = cvpartition(y,'k',10); 
%cvp = cvpartition(y,'Leaveout'); 
[fs,history] = sequentialfs(@classf,X,y,'cv',cvp,'options',opt);


figure;

% ROC curve
load fisheriris
x = meas(51:end,1:2);        % iris data, 2 classes and 2 features
y = (1:100)'>50;             % versicolor=0, virginica=1
b = glmfit(x,y,'binomial');  % logistic regression
p = glmval(b,x,'logit');     % get fitted probabilities for scores

[X,Y] = perfcurve(species(51:end,:),p,'virginica');
plot(X,Y)
xlabel('False positive rate'); ylabel('True positive rate')
title('ROC for classification by logistic regression')

% Obtain errors on TPR by vertical averaging
[X,Y] = perfcurve(species(51:end,:),p,'virginica','nboot',1000,'xvals','all');
errorbar(X,Y(:,1),Y(:,2)-Y(:,1),Y(:,3)-Y(:,1)); % plot errors