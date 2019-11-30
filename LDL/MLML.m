function  M=MLML(tr_dat,trls,chit)    
%Input:
%tr_dat  training set
%tt_dat  test set
%trls    training label
%ttls    test label
%chit    number of positive pair 
%cmiss   number of negative pair

%Output:
%accu    Classification accuracy

%get positive and negative sample pair

[zr,dl]=LDLpair(tr_dat,chit);

yr=zeros(1,size(dl,1));
%trls(trls==-1)=0;

for i=1:size(dl,1)
  distance = abs(trls(dl(i,1),:)-trls(dl(i,2),:));
  yr(i)=(sum(distance));
end
%yr=yr/max(yr);
%metric learning
[model,~]=svmtraintime(yr',zr','-s 3 -t 5 -p 0.0001 -h 0 -f 1');
%[model,~]=svmtraintime(yr',zr','-s 4 -t 5 -n 0.1 -h 0 -f 1');

[nSV,dim]=size(model.SVs);
dim=dim/2;
SVs=model.SVs';
M=zeros(dim,dim);
for i=1:nSV
    M=M+model.sv_coef(i)*(SVs(1:dim,i)-SVs(dim+(1:dim),i))*(SVs(1:dim,i)-SVs(dim+(1:dim),i))';
end
M=PosCone(M);
