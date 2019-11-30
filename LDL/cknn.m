function result=cknn(trainFeature,trainDistribution,testFeature,testDistribution, k, distanceMark,M)

prediction = aaknn(trainFeature,trainDistribution,testFeature, k, distanceMark,M);

result=sum(abs(prediction-testDistribution))/size(testDistribution,1);

[prediction testDistribution]

