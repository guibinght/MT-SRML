function   [acc_mean,acc_std]=crossvalidation(features,labels,method,chit,dtype,lambda)

[M,N]=size(labels);
for k=1:10
     if k==10;
        b=9;
     else b=k+1;
     end
indices=crossvalind('Kfold',labels(1:M,N),10);
test = (indices == k); 

validation = (indices == b);
train = ((indices ~= k)&(indices ~= b));
trainDistribution=labels(train,:);
trainFeature=features(train,:);
testDistribution=labels(validation,:);
testFeature=features(validation,:);

    switch method
        case 'dml'
           result(k,:)=ldmlknn(trainFeature,trainDistribution,testFeature,testDistribution,chit,dtype);
        case 'krr'
           result(k,:)=ldmlkrr(trainFeature,trainDistribution,testFeature,testDistribution,chit,dtype,lambda); 
        case 'aaknn'
           result(k,:)=ldlknn(trainFeature,trainDistribution,testFeature,testDistribution,chit,dtype);
    end
    
end

acc_mean=mean(result);
acc_std=std(result);

