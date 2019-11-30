function  W = MTL_APG(X, Y, Q, group_index, opt)

% *************************************************************************
%   The Accelerated Gradient Descent method for multi-task joint sparse
%   representation.
%   Written by Xiaotong Yuan, March 2010.
% *************************************************************************
% Parameters:
% X: cell(K,1), X{k} stores training samples as columns for taks k
%
% Y: cell(K,1), Y{k} stores test sample for task k
%
% Q: cell(K,1), Q{k}stores the inverse of matrices (X{k}'X{k}+\beta I) fot task k
% where \beta is a small constant and I is a compatible identity matrix. 
% 
% group_index: cell(K,1), group_index{k} stores group index of samples in X{k} for task k
% 
% opt: structure to store the parameters, which include
%   --- opt.lambda: strngth of regularization term
%   --- opt.eta: gradient descent step size
%   --- opt.ite_num: prefixed total number of iterations
%   --- opt.kernel_view: boolean, 1 for kernel problem, while 0 for linear
%        problem
%   --- opt.R: cell(K,1). If problem is linear, i.e., opt.kernel_view = 0,
%        then R{k} stores X'{k}X{k}.


lambda = opt.lambda;
eta = opt.eta;
ite_num = opt.ite_num;
maxIter=10;

    

K = length(Q); % Get the number of tasks

W = cell(K,1);

% initialization with the results from ridge regression, which works
% better in practice than the conventional all-zero initialization

W_ridge = cell(K,1); % stores the ridge regression results
% APG variables
W_APG_cur = cell(K,1); 
W_APG_prev = cell(K,1); 

V_APG = cell(K,1); % aggregation variable

for (k=1:K)
    Q_t = Q{k};
    Y_t = Y{k};
    W_t = Q_t*Y_t;
    V_APG{k} = W_t;
    W_APG_prev{k} = W_t;
    W_ridge{k} = W_t;
end

if (opt.kernel_view==0)
    for k=1:K
        R{k} = X{k}' * X{k};
    end
end

group_t = group_index{1};
obj_val = zeros(maxIter,1);
IsConvergence = 0;
for (l=1:ite_num)
    
    %------------------------- Gradient Mapping -------------------------
    for (k=1:K)
       if (opt.kernel_view==1)
            W_APG_cur{k} = V_APG{k}-eta*(-Y{k}+X{k}*V_APG{k});%V_APG{k}-eta*(-X{k}'*Y{k}+R{k}*V_APG{k});%4
       else
            R = opt.R;
            W_APG_cur{k} = V_APG{k}-eta*(-X{k}'*Y{k}+ R{k}*V_APG{k});
       end
    end   
   

   for (i=1:length(group_t))
        W_t = [];
        for (k=1:K)
            W_t = [W_t; W_APG_cur{k}(find(group_t==i))];
        end
        S = norm(W_t);
        
        for (k=1:K)
            if (S<lambda)
               W_APG_cur{k}(find(group_t==i)) = 0;
            else
               W_APG_cur{k}(find(group_t==i)) = (1-lambda/S)*W_APG_cur{k}(find(group_t==i));%5
            end
        end
    end
   
    
    % ------------------------ Aggregation --------------------------
    alpha_prev = 2/(l+1);    
    alpha_cur = 2/(l+2);

    for (k=1:K)
        V_APG{k} = W_APG_cur{k} + (1-alpha_prev)*alpha_cur/alpha_prev*(W_APG_cur{k} - W_APG_prev{k});%7
    end

      
    W_APG_prev = W_APG_cur;   

end

    
for (k=1:K)
  W{k} = W_APG_prev{k}; %W_ridge{k}.*(W_APG_prev{k}~=0); 
end






