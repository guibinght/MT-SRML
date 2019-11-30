function [zr,doubletLabels]=LDLpair(X,chit)
% function
% [zr,yr,doubletLabels]=ConstructDoubletMatrix(X,Y,chit,cmiss)
% Construct doublets set based on training instances.
%
% Input:
% X     training samples (each column is a sample)
% Y     labels
% chit  the number of hits for each sample
% cmiss the number of misses for each sample
%
% Output:
%
% zr   the constructed doublets set (each column is a doublet)
% yr   the labels of each doublet in zr (in row vector form)
%
[dim,sampleNum]=size(X);
zrNum=chit*sampleNum;
zr=zeros(2*dim,zrNum);
doubletLabels=zeros(zrNum,2);
indexzr=1;
for i=1:sampleNum
    %disp(num2str(i));
    Xik=X-X(:,i)*ones(1,sampleNum);
    Xik=Xik.^2;
    Distik=sum(Xik,1); %X(:,i)到X(:,k)距离的平方（k=1,2,3,...,sampleNum）
    Distik(i)=Inf;
    [~,SortedHitIndex]=sort(Distik);
    HitSet=SortedHitIndex(1:chit);
    for k=1:chit
        doubletLabels(indexzr,:)=[i,HitSet(k)];
        zr(:,indexzr)=[X(:,i);X(:,HitSet(k))];
        indexzr=indexzr+1;
    end
end
end