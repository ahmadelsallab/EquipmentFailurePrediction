% Load the data and select features for classification
load fisheriris
X = [meas(:,1), meas(:,2)];
% Extract the Setosa class
Y = nominal(ismember(species,'setosa'));
% Randomly partitions observations into a training set and a test
% set using stratified holdout
P = cvpartition(Y,'Holdout',0.20);
% Use a linear support vector machine classifier
svmStruct = svmtrain(X(P.training,:),Y(P.training),'showplot',true);
[C, probs] = svmclassify(svmStruct,X(P.training,:),'showplot',true);
errRate = sum(Y(P.training)~= C)/P.TestSize  %mis-classification rate
conMat = confusionmat(Y(P.training),C) % the confusion matrix

% Xnew = X(P.test);
% shift = svmStruct.ScaleData.shift;
% scale = svmStruct.ScaleData.scaleFactor;
% %Xnew = bsxfun(@plus,Xnew,shift);
% %Xnew = bsxfun(@times,Xnew,scale);
% sv = svmStruct.SupportVectors;
% alphaHat = svmStruct.Alpha;
% bias = svmStruct.Bias;
% kfun = svmStruct.KernelFunction;
% kfunargs = svmStruct.KernelFunctionArgs;
% f = kfun(sv,Xnew,kfunargs{:})'*alphaHat(:) + bias;
%f = -f; % flip the sign to get the score for the +1 class
conf = -probs;
% Perfcurves
[X_perf,Y_perf] = perfcurve(Y(P.training),conf,'true');
plot(X_perf, Y_perf);
