function  result=ldmlkrr(trainFeature,trainDistribution,testFeature,testDistribution,chit,dtype,lambda)

disType = 'Ma';
 
M=LDLMLkrr(trainFeature',trainDistribution,chit,dtype,lambda);  
% M=eye(size(trainFeature,2));

preDistribution = aaknn(trainFeature,trainDistribution, testFeature, 3, disType,M);

testNum=size(testFeature,1);
% To visualize two distribution and display some selected metrics of distance
for i=1:testNum
    % Show the comparisons between the predicted distribution
	[~, distance] = computeMeasures(testDistribution(i,:), preDistribution(i,:));
    % Draw the picture of the real and prediced distribution.
    D(i,:)=distance;
%    drawDistribution(testDistribution(i,:),preDistribution(i,:),disName, distance);
end

result=mean(D);