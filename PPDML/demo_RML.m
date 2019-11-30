tic;
%%%%%%%%%%%%%%%     UCI    %%%%%%%%%%%%%%%%%%%%
load RAMLUCI;
dataset{1}=iris; 
dataset{2}=wpbc;
dataset{3}=wine; 
dataset{4}=sonar;
dataset{5}=glass; 
dataset{6}=wdbc; 
dataset{7}=australian_credit;
%%%%%%%%%%%%%%%%    IMAGE   %%%%%%%%%%%%%%%%%%%%
%  load PCA100;
% dataset{1}=binalpha1; 
% dataset{2}=caltech101_silhouettes_16_1; 
% dataset{3}=MnistData_05_1; 
% dataset{4}=Mpeg7_1; 
% dataset{5}=MSRA25_1; 
% dataset{6}=news20_1; 
% dataset{7}=TDT2_20_1; 
% dataset{8}=uspst1; 
% j=1;
% for lambda=[1e-3,1e-2,1e-1,1,10,100,1000];
method='KRRML';%KRRML
chit=1;
cmiss=1;
nu=0.5;
lambda=1;
for i=1:7
  [acc_mean(j),acc_std(j)]=crossvalidate(dataset{i},10,method,chit,cmiss,nu,lambda); 
  j=j+1
end
result=[acc_mean',acc_std'];
result=result/100
toc;