function err = classf_1(xtrain,ytrain,xtest,ytest)
 yfit = classify(xtest,xtrain,ytrain,'quadratic');
 err = sum(~strcmp(ytest,yfit));
end