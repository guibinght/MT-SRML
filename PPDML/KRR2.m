function M=KRR2(Xtrain,pairIndex,s)


    [dim,~,~]=size(Xtrain);
    M=zeros(dim,dim);
    alpha = s;
    for i=1:length(alpha)
        p=pairIndex(i,1);
        q=pairIndex(i,2);
        M=M+alpha(i)*((Xtrain(:,p)-Xtrain(:,q))*(Xtrain(:,p)-Xtrain(:,q))');
    end
end