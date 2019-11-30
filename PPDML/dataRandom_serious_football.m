function [X_train,Y_train,X_test,Y_test]=dataRandom_serious_football(X,Y,V_num,train_rate)
% basic statistics
% X-->n*d
class_num = size(unique(Y),1);
sample_num = size(Y,1);

if min(Y)==0
    Y =Y+1;
end
% the row-number of each class
f=cell(1,class_num);
for i=1:class_num
    f{i}=find(Y==i);
end

train_index = [];

for i=1:class_num
    num_per_cls=length(f{i}); % 每类的样本数目  
    p = randperm(num_per_cls,ceil(num_per_cls*train_rate));
    k=f{i};index=k(p); % 选出的训练样本在数据集中的索引
%     p = p';
    train_index = [train_index;index];
end

train_index = uint16(train_index);
indexAll = (1:sample_num)';
indexAll(train_index) = [];
test_index = indexAll;

X_train=cell(1,V_num);
X_test=cell(1,V_num);
for v=1:V_num
    X_train{v} = X{v}(train_index,:);
    X_test{v} = X{v}(test_index,:);
end
Y_train = Y(train_index,:);
Y_test = Y;
Y_test(train_index) = [];