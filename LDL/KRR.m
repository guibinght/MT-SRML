function M=KRR(Xtrain,yr,pairIndex,lambda)


    [dim,nouse,sampleNum]=size(Xtrain);
    l=size(pairIndex,1);
    M=zeros(dim,dim);

    for i=1:size(pairIndex,1)
       c1=pairIndex(i,1);
       c2=pairIndex(i,2);
       P1=Xtrain(:,c1);
       P2=Xtrain(:,c2);
       xx1=(P1-P2)*(P1-P2)';
       for j=i:size(pairIndex,1)
           c3=pairIndex(j,1);
           c4=pairIndex(j,2);
           P3=Xtrain(:,c3);
           P4=Xtrain(:,c4);
           xx2=(P3-P4)*(P3-P4)';
           for k=1:size(xx1,1)
              xx3(k)=xx1(k,:)*xx2(:,k); 
           end
           %Ktr(i,j)=trace(xx1*xx2);
           Ktr(i,j)=sum(xx3);
           Ktr(j,i)=Ktr(i,j);
       end
    end
%     lambda=1e-3;
%    alpha=pinv(Ktr+lambda*eye(size(Ktr,1)))*yr;
	alpha=yr*Ktr'*pinv(Ktr*Ktr'+lambda*eye(size(Ktr,1)));
    for i=1:length(alpha)
        p=pairIndex(i,1);
        q=pairIndex(i,2);
        M=M+alpha(i)*((Xtrain(:,p)-Xtrain(:,q))*(Xtrain(:,p)-Xtrain(:,q))');
    end
end