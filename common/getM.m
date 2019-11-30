function M=getM(model,psd_option)

%function: get M from svm model

%Input:
%model        trained svm model        
%psd_option   0-Positive Semi-Definite  1-No constraints

[nSV,dim]=size(model.SVs);
dim=dim/2;
SVs=model.SVs';
M=zeros(dim,dim);
for i=1:nSV
    M=M+model.sv_coef(i)*(SVs(1:dim,i)-SVs(dim+(1:dim),i))*(SVs(1:dim,i)-SVs(dim+(1:dim),i))';
end

if psd_option==0
   M=PosCone(M);
end