function err = classf(xtrain,ytrain,xtest,ytest)
 %yfit = classify(xtest,xtrain,ytrain,'quadratic');
 
 % Load the data and select features for classification
    load fisheriris
    X = xtrain;
    % Extract the Setosa class
    Y = ytrain;

    % Use a linear support vector machine classifier
    %svmStruct = svmtrain(X,Y,'showplot',true);
    svmStruct = svmtrain(X,Y,'showplot',false);
    
    %figure;
    %C = svmclassify(svmStruct,xtest,'showplot',true);
    C = svmclassify(svmStruct,xtest,'showplot',false);
    errRate = sum(ytest~= C)/size(ytest, 1);  %mis-classification rate
    conMat = confusionmat(ytest,C); % the confusion matrix
    yfit = C;
    err = sum(~strcmp(ytest,yfit));